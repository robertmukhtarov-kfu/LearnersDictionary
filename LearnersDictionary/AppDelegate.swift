//
//  AppDelegate.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 01.03.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
    var tabBarController: MainTabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)

		if #available(iOS 13, *) {
			window?.backgroundColor = .systemBackground
        } else {
			window?.backgroundColor = .white
        }

        tabBarController = MainTabBarController()
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()

        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "LearnersDictionary")
		var persistentStoreDescriptions: NSPersistentStoreDescription

		let documentsURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
		guard let storeUrl = documentsURL?.appendingPathComponent("Wordlist.sqlite") else {
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

    // MARK: - Core Data Saving support

    func saveContext () {
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
}
