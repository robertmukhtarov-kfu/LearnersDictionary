//
//  UserCollectionsCoordinator.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 15.04.2021.
//

import UIKit

protocol UserCollectionsCoordinatorProtocol {
	func showUserCollections()
	func showUserCollectionDetails(collection: UserCollectionModel)
	func showEntry(for word: String)
}

class UserCollectionsCoordinator: UserCollectionsCoordinatorProtocol {
	let navigationController: UINavigationController

	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
		navigationController.navigationBar.isTranslucent = false
		navigationController.navigationBar.prefersLargeTitles = true
		showUserCollections()
	}

	func showUserCollections() {
		let userCollectionPresenter = UserCollectionsPresenter()
		let userCollectionVC = UserCollectionsViewController()
		userCollectionPresenter.coordinator = self
		userCollectionPresenter.view = userCollectionVC
		userCollectionVC.presenter = userCollectionPresenter
		navigationController.pushViewController(userCollectionVC, animated: false)
	}

	func showUserCollectionDetails(collection: UserCollectionModel) {
		let userCollectionDetailPresenter = UserCollectionDetailPresenter(collection: collection)
		let userCollectionDetailVC = UserCollectionDetailViewController()
		userCollectionDetailPresenter.coordinator = self
		userCollectionDetailPresenter.view = userCollectionDetailVC
		userCollectionDetailVC.presenter = userCollectionDetailPresenter
		navigationController.pushViewController(userCollectionDetailVC, animated: true)
	}

	func showEntry(for word: String) {
		let entryPageViewPresenter = EntryPageViewPresenter(word: word)
		let entryPageViewController = EntryPageViewController()
		entryPageViewPresenter.view = entryPageViewController
		entryPageViewController.presenter = entryPageViewPresenter
		navigationController.pushViewController(entryPageViewController, animated: true)
	}
}
