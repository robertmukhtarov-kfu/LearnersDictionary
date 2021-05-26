//
//  FirebaseUserCollectionNetworkService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 25.05.2021.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

protocol UserCollectionNetworkServiceProtocol {
	func saveCollections(_ collections: [UserCollection], modificationDate: Date)
	func getCollections(completion: @escaping (Result<[UserCollection], Error>) -> Void)
	func getModificationDate(completion: @escaping (Result<Date, Error>) -> Void)
}

class FirebaseUserCollectionNetworkService: UserCollectionNetworkServiceProtocol {
	private var usersRef = Database.database().reference().child("users")
	private let wordRepository = WordRepository()

	public func saveCollections(_ collections: [UserCollection], modificationDate: Date) {
		guard let user = Auth.auth().currentUser else { return }
		let userRef = usersRef.child(user.uid)
		let collectionsRef = userRef.child("collections")
		let lastModifiedRef = userRef.child("lastModified")

		collectionsRef.setValue(collections.toDictionaryArray())
		lastModifiedRef.setValue(Int(modificationDate.timeIntervalSince1970))
	}

	func getModificationDate(completion: @escaping (Result<Date, Error>) -> Void) {
		guard let user = Auth.auth().currentUser else {
			return completion(.failure(UserAuthenticationError.noUser))
		}
		usersRef.child(user.uid).child("lastModified").getData { error, snapshot in
			if let error = error {
				return completion(.failure(error))
			}
			guard let intDate = snapshot.value as? Int else {
				return completion(.failure(UserCollectionNetworkServiceError.modificationDateLoadFailure))
			}
			let date = Date(timeIntervalSince1970: TimeInterval(intDate))
			return completion(.success(date))
		}
	}

	public func getCollections(completion: @escaping (Result<[UserCollection], Error>) -> Void) {
		guard let user = Auth.auth().currentUser else {
			return completion(.failure(UserAuthenticationError.noUser))
		}

		let collectionsRef = usersRef.child(user.uid).child("collections")
		collectionsRef.getData { error, snapshot in
			if let error = error {
				return completion(.failure(error))
			}

			if !snapshot.exists() {
				return completion(.success([]))
			}

			guard let collectionDicts = snapshot.value as? [[String: Any]] else {
				return completion(.failure(UserCollectionNetworkServiceError.collectionsLoadFailure))
			}

			guard let userCollections = self.parseUserCollections(from: collectionDicts) else {
				return completion(.failure(UserCollectionNetworkServiceError.collectionsParsingFailure))
			}

			return completion(.success(userCollections))
		}
	}

	private func parseUserCollections(from collectionDicts: [[String: Any]]) -> [UserCollection]? {
		var userCollections: [UserCollection] = []
		for collectionDict in collectionDicts {
			guard
				let colorInt = collectionDict["color"] as? Int16,
				let color = UserCollectionColor(rawValue: colorInt),
				let title = collectionDict["title"] as? String,
				let words = collectionDict["words"] as? [String]
			else {
				return nil
			}
			let userCollection = UserCollection(context: CoreDataService.shared.persistentContainer.viewContext)
			userCollection.title = title
			userCollection.color = color
			for wordSpelling in words {
				guard let word = wordRepository.getWord(by: wordSpelling) else {
					return nil
				}
				userCollection.addToWords(word)
			}
			userCollections.append(userCollection)
		}
		return userCollections
	}
}

extension UserCollection {
	func toDictionary() -> [String: Any] {
		var dictionary: [String: Any] = [:]
		dictionary["color"] = color.rawValue
		dictionary["title"] = title

		guard let wordsArray = words.array as? [Word] else {
			return dictionary
		}
		dictionary["words"] = wordsArray.map(\.spelling)

		return dictionary
	}
}

extension Array where Element == UserCollection {
	func toDictionaryArray() -> [[String: Any]] {
		return map { $0.toDictionary() }
	}
}
