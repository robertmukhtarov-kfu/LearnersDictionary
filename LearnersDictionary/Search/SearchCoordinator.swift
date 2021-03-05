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
		let searchPresenter = SearchPresenterImplementation()
		let searchVC = SearchViewController()
		searchPresenter.coordinator = self
		searchPresenter.view = searchVC
		searchVC.presenter = searchPresenter
		searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
		navigationController.viewControllers = [searchVC]
		navigationController.navigationBar.prefersLargeTitles = true
    }
}
