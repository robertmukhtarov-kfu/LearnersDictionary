//
//  AppDelegate.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 01.03.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?
    var tabBarController: MainTabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.backgroundColor = .background

		tabBarController = MainTabBarController()
		window?.rootViewController = tabBarController
		window?.makeKeyAndVisible()

		return true
    }
}
