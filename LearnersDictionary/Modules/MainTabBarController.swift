//
//  MainTabBarController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 01.03.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
	let searchCoordinator = SearchCoordinator()
	let discoverCoordinator = DiscoverCoordinator()
	let userCollectionsCoordinator = UserCollectionsCoordinator()

	override func viewDidLoad() {
		super.viewDidLoad()

		let searchVC = searchCoordinator.navigationController
		searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)

		let discoverVC = discoverCoordinator.discoverViewController
		discoverVC.tabBarItem = UITabBarItem(
			title: "Discover",
			image: UIImage(named: "discover"),
			selectedImage: nil
		)

		let userCollectionsVC = userCollectionsCoordinator.navigationController
		userCollectionsVC.tabBarItem = UITabBarItem(
			title: "My Collections",
			image: UIImage(named: "collections"),
			selectedImage: nil
		)

		viewControllers = [searchVC, discoverVC, userCollectionsVC]
    }
}
