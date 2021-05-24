//
//  CardDetailConfigurator.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 26.04.2021.
//

import UIKit

class CardDetailConfigurator {
	private let userCollectionRepository = UserCollectionRepository()

	func wordOfTheDay(_ wordOfTheDay: Word, cardView: CardView) -> CardDetailViewController {
		let entryPageVC = EntryPageViewController()
		let presenter = EntryPageViewPresenter(word: wordOfTheDay)
		entryPageVC.presenter = presenter
		presenter.view = entryPageVC
		let cardDetailVC = CardDetailViewController(
			cardView: cardView.viewCopy(),
			childViewController: entryPageVC,
			distanceFromChildToCard: 16
		)
		cardDetailVC.addButtonAction = { [weak cardDetailVC] in
			let navigationController = UINavigationController()
			let userCollectionPresenter = UserCollectionsPresenter(mode: .add(wordOfTheDay))
			let userCollectionVC = UserCollectionsViewController()
			userCollectionPresenter.view = userCollectionVC
			userCollectionVC.presenter = userCollectionPresenter
			navigationController.setViewControllers([userCollectionVC], animated: false)
			cardDetailVC?.present(navigationController, animated: true)
		}
		cardDetailVC.title = "Word of the Day"
		return cardDetailVC
	}

	func discoverCollection(_ discoverCollection: DiscoverCollectionModel, cardView: CardView, coordinator: DiscoverCoordinator) -> CardDetailViewController {
		let collectionDetailVC = CollectionDetailViewController()
		let presenter = CollectionDetailPresenter(collection: discoverCollection)
		collectionDetailVC.presenter = presenter
		presenter.coordinator = coordinator
		presenter.view = collectionDetailVC
		let cardDetailVC = CardDetailViewController(
			cardView: cardView.viewCopy(),
			childViewController: collectionDetailVC
		)
		cardDetailVC.addButtonAction = { [userCollectionRepository, weak cardDetailVC] in
			userCollectionRepository.save(from: discoverCollection)
			let alert = UIAlertController(title: "Added to your collections", message: "", preferredStyle: .alert)
			cardDetailVC?.present(alert, animated: true)
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				alert.dismiss(animated: true, completion: nil)
			}
		}
		cardDetailVC.title = "Collection"
		return cardDetailVC
	}
}
