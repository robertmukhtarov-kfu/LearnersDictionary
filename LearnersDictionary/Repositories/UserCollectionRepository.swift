//
//  UserCollectionRepository.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 11.05.2021.
//

import CoreData

protocol UserCollectionRepositoryProtocol {
	func createCollection(named title: String) -> UserCollection
	func getUser() -> User
	func delete(collection: UserCollection)
	func save()
}

class UserCollectionRepository: UserCollectionRepositoryProtocol {
	private let context = CoreDataService.shared.persistentContainer.viewContext
	private let wordRepository = WordRepository()
	private let userCollectionNetworkService = FirebaseUserCollectionNetworkService()

	func createCollection(named title: String) -> UserCollection {
		let newCollection = UserCollection(context: context)
		newCollection.title = title
		newCollection.color = UserCollectionColor.allCases.randomElement() ?? .blue
		save()
		return newCollection
	}

	func getUser() -> User {
		let fetchRequest = User.fetchRequest() as NSFetchRequest<User>
		let user: User
		if let firstUser = try? context.fetch(fetchRequest).first {
			user = firstUser
		} else {
			user = createUser()
		}
		return user
	}

	func save(from discoverCollection: DiscoverCollectionModel) {
		let user = getUser()
		let userCollection = UserCollection(context: context)
		userCollection.title = discoverCollection.title
		userCollection.color = UserCollectionColor.allCases.randomElement() ?? .blue
		var words: [Word] = []
		discoverCollection.words.forEach { discoverWord in
			if let word = wordRepository.getWord(by: discoverWord.title) {
				words.append(word)
			}
		}
		userCollection.insertIntoWords(words, at: IndexSet(0..<words.count) as NSIndexSet)
		user.addToCollections(userCollection)
		save()
	}

	private func createUser() -> User {
		let user = User(context: context)
		context.insert(user)
		save()
		return user
	}

	func delete(collection: UserCollection) {
		context.delete(collection)
		save()
	}

	func save() {
		let modificationDate = Date()
		let user = getUser()
		user.lastModified = modificationDate
		CoreDataService.shared.saveContext()

		guard let collections = user.collections.array as? [UserCollection] else { return }
		userCollectionNetworkService.saveCollections(collections, modificationDate: modificationDate)
	}
}
