//
//  CoreDataService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 05.03.2021.
//

import CoreData

class CoreDataService {
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "LearnersDictionary")
		var persistentStoreDescriptions: NSPersistentStoreDescription

		guard let storeUrl = try? FileManager.default.url(
			for: .documentDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: false
		)
		.appendingPathComponent("Wordlist.sqlite") else {
			fatalError("Invalid storeURL")
		}

		do {
			if !FileManager.default.fileExists(atPath: storeUrl.path) {
				guard let seededDataUrl = Bundle.main.url(forResource: "Wordlist", withExtension: "sqlite") else {
					fatalError("Wordlist.sql doesn't exist")
				}
				try FileManager.default.copyItem(at: seededDataUrl, to: storeUrl)
			}
		} catch {
			print(error)
		}

		let description = NSPersistentStoreDescription()
		description.shouldInferMappingModelAutomatically = true
		description.shouldMigrateStoreAutomatically = true
		description.url = storeUrl

		container.persistentStoreDescriptions = [description]

		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()
}
