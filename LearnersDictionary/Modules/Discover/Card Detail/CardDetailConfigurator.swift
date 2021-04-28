//
//  CardDetailConfigurator.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 26.04.2021.
//

import UIKit

class CardDetailConfigurator {
	func wordOfTheDay(_ wordOfTheDay: WordOfTheDayModel, cardView: CardView) -> CardDetailViewController {
		let entryPageVC = EntryPageViewController()
		let presenter = EntryPageViewPresenter(word: wordOfTheDay.title)
		entryPageVC.presenter = presenter
		presenter.view = entryPageVC
		let cardDetailVC = CardDetailViewController(
			cardView: cardView.viewCopy(),
			childViewController: entryPageVC,
			distanceFromChildToCard: 16
		)
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
		cardDetailVC.title = "Collection"
		return cardDetailVC
	}
}
