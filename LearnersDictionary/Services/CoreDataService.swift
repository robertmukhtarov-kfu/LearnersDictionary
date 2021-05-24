//
//  CoreDataService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 05.03.2021.
//

import CoreData

protocol CoreDataServiceProtocol {
	var persistentContainer: NSPersistentContainer { get }
	func saveContext()
}

class CoreDataService: CoreDataServiceProtocol {
	static let shared = CoreDataService()

	lazy var persistentContainer: NSPersistentContainer = {
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

	private init() {
		setupDescription()
	}

	func saveContext() {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}

	// MARK: - Private Methods

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
