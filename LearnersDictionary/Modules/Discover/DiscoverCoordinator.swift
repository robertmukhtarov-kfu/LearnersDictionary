//
//  DiscoverCoordinator.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 11.04.2021.
//

import UIKit

protocol DiscoverCoordinatorProtocol {
	func showWordOfTheDay(_ wordOfTheDay: Word, cardView: CardView)
	func showDiscoverCollection(_ discoverCollection: DiscoverCollectionModel, cardView: CardView)
	func showEntry(for word: Word)
	func dismissCardDetail()
}

class DiscoverCoordinator: DiscoverCoordinatorProtocol {
	var discoverViewController: DiscoverViewController
	let cardTransitionManager = CardTransitionManager()
	let cardDetailNavigationController = UINavigationController()

	init(discoverViewController: DiscoverViewController = DiscoverViewController()) {
		self.discoverViewController = discoverViewController
		setupDiscoverController()
		setupNavigationController()
	}

	private func setupDiscoverController() {
		let discoverPresenter = DiscoverPresenter()
		discoverPresenter.coordinator = self
		discoverPresenter.view = discoverViewController
		discoverViewController.presenter = discoverPresenter
	}

	private func setupNavigationController() {
		cardDetailNavigationController.navigationBar.isTranslucent = false
		cardDetailNavigationController.modalPresentationStyle = .overFullScreen
		cardDetailNavigationController.transitioningDelegate = cardTransitionManager
	}

	func showWordOfTheDay(_ wordOfTheDay: Word, cardView: CardView) {
		let cardDetailConfigurator = CardDetailConfigurator()
		let wordOfTheDayVC = cardDetailConfigurator.wordOfTheDay(wordOfTheDay, cardView: cardView)
		wordOfTheDayVC.coordinator = self
		cardDetailNavigationController.setViewControllers([wordOfTheDayVC], animated: false)
		discoverViewController.present(cardDetailNavigationController, animated: true)
	}

	func showDiscoverCollection(_ discoverCollection: DiscoverCollectionModel, cardView: CardView) {
		let cardDetailConfigurator = CardDetailConfigurator()
		let collectionDetailVC = cardDetailConfigurator.discoverCollection(
			discoverCollection,
			cardView: cardView,
			coordinator: self
		)
		collectionDetailVC.coordinator = self
		cardDetailNavigationController.setViewControllers([collectionDetailVC], animated: false)
		discoverViewController.present(cardDetailNavigationController, animated: true)
	}

	func showEntry(for word: Word) {
		let entryPageViewPresenter = EntryPageViewPresenter(word: word)
		let entryPageViewController = EntryPageViewController()
		entryPageViewPresenter.view = entryPageViewController
		entryPageViewController.presenter = entryPageViewPresenter
		cardDetailNavigationController.pushViewController(entryPageViewController, animated: true)
	}

	func dismissCardDetail() {
		cardDetailNavigationController.dismiss(animated: true)
	}
}
