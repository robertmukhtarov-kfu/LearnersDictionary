//
//  DiscoverPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 26.04.2021.
//

import UIKit

class DiscoverPresenter: DiscoverPresenterProtocol {
	var coordinator: DiscoverCoordinator?
	weak var view: DiscoverViewProtocol?

	private var collections: [DiscoverCollectionModel] = []
	private let wordOfTheDay = WordOfTheDayModel(
		image: UIImage(named: "landscape")!,
		title: "landscape",
		shortDefinition: "A picture that shows a natural scene of land or the countryside"
	)

	let collectionService = MockDiscoverCollectionService()

	var collectionCount: Int {
		collections.count
	}

	func viewDidLoad() {
		loadCollections()
	}

	func loadCollections() {
		collectionService.collections { result in
			switch result {
			case .success(let collections):
				self.collections = collections
				self.view?.reloadData()
			case .failure(let error):
				print(error)
			}
		}
	}

	func getWordOfTheDay() -> WordOfTheDayModel {
		wordOfTheDay
	}

	func getCollection(forCellAt indexPath: IndexPath) -> DiscoverCollectionModel {
		collections[indexPath.item]
	}

	func showWordOfTheDay(cardView: CardView) {
		coordinator?.showWordOfTheDay(wordOfTheDay, cardView: cardView)
	}

	func showDiscoverCollection(at index: Int, cardView: CardView) {
		coordinator?.showDiscoverCollection(collections[index], cardView: cardView)
	}
}
