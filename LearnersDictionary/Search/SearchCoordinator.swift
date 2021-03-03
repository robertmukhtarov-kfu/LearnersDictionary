//
//  SearchCoordinator.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 01.03.2021.
//

import UIKit

class SearchCoordinator {
	var navigationController: UINavigationController

    init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
		let searchVC = SearchViewController()
		searchVC.coordinator = self
		searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
		navigationController.viewControllers = [searchVC]
		navigationController.navigationBar.prefersLargeTitles = true
    }
}
