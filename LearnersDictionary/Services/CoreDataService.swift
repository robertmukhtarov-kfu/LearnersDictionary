//
//  CoreDataService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 05.03.2021.
//

import CoreData

protocol CoreDataServiceProtocol {
	func fetchWordlist(
		predicate: NSPredicate?,
		sortDescriptors: [NSSortDescriptor]?,
		completion: (Result<[Word], Error>) -> Void
	)
}

class CoreDataService: CoreDataServiceProtocol {
	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "LearnersDictionary")
		container.persistentStoreDescriptions = [description]
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()

	private let description = NSPersistentStoreDescription()

	init() {
		setupDescription()
	}

	func fetchWordlist(
		predicate: NSPredicate?,
		sortDescriptors: [NSSortDescriptor]?,
		completion: (Result<[Word], Error>) -> Void
	) {
		let context = persistentContainer.viewContext
		let fetchRequest = Word.fetchRequest() as NSFetchRequest<Word>
		fetchRequest.predicate = predicate
		fetchRequest.sortDescriptors = sortDescriptors
		do {
			let words = try context.fetch(fetchRequest)
			completion(.success(words))
		} catch {
			completion(.failure(error))
		}
	}

	private func setupDescription() {
		let wordlistURL = getWordlistURL()
		ensureWordlistExists(at: wordlistURL)
		description.shouldInferMappingModelAutomatically = true
		description.shouldMigrateStoreAutomatically = true
		description.url = wordlistURL
	}

	private func getWordlistURL() -> URL {
		guard let storeUrl = try? FileManager.default.url(
			for: .documentDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: false
		)
		.appendingPathComponent("Wordlist.sqlite") else {
			fatalError("Invalid storeURL")
		}
		return storeUrl
	}

	private func ensureWordlistExists(at url: URL) {
		do {
			if !FileManager.default.fileExists(atPath: url.path) {
				guard let wordlistURL = Bundle.main.url(forResource: "Wordlist", withExtension: "sqlite") else {
					fatalError("Wordlist.sql doesn't exist")
				}
				try FileManager.default.copyItem(at: wordlistURL, to: url)
			}
		} catch {
			print(error)
		}
	}
}
