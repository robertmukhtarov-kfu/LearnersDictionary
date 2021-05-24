//
//  UserCollectionsCoordinator.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 15.04.2021.
//

import UIKit

protocol UserCollectionsCoordinatorProtocol {
	func showUserCollections()
	func showUserCollectionDetails(collection: UserCollection, repository: UserCollectionRepositoryProtocol)
	func showEntry(for word: Word)
	func popToRootViewController()
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
		let userCollectionPresenter = UserCollectionsPresenter(mode: .main)
		let userCollectionVC = UserCollectionsViewController()
		userCollectionPresenter.coordinator = self
		userCollectionPresenter.view = userCollectionVC
		userCollectionVC.presenter = userCollectionPresenter
		navigationController.pushViewController(userCollectionVC, animated: false)
	}

	func showUserCollectionDetails(collection: UserCollection, repository: UserCollectionRepositoryProtocol) {
		let userCollectionDetailPresenter = UserCollectionDetailPresenter(collection: collection, repository: repository)
		let userCollectionDetailVC = UserCollectionDetailViewController()
		userCollectionDetailPresenter.coordinator = self
		userCollectionDetailPresenter.view = userCollectionDetailVC
		userCollectionDetailVC.presenter = userCollectionDetailPresenter
		navigationController.pushViewController(userCollectionDetailVC, animated: true)
	}

	func showEntry(for word: Word) {
		let entryPageViewPresenter = EntryPageViewPresenter(word: word)
		let entryPageViewController = EntryPageViewController()
		entryPageViewPresenter.view = entryPageViewController
		entryPageViewController.presenter = entryPageViewPresenter
		navigationController.pushViewController(entryPageViewController, animated: true)
	}

	func popToRootViewController() {
		navigationController.popToRootViewController(animated: true)
	}

	func showAuthorization() {
		let authorizationCoordinator = AuthorizationCoordinator()
		let authorizationNavigationController = authorizationCoordinator.navigationController
		authorizationNavigationController.modalPresentationStyle = .fullScreen
		navigationController.present(authorizationCoordinator.navigationController, animated: true)
	}
}
