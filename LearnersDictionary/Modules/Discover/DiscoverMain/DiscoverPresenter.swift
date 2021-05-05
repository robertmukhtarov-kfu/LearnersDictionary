//
//  DiscoverPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 26.04.2021.
//

import UIKit

class DiscoverPresenter: DiscoverPresenterProtocol {
	weak var coordinator: DiscoverCoordinator?
	weak var view: DiscoverViewProtocol?

	private var collections: [DiscoverCollectionModel] = []
	private var wordOfTheDay = WordOfTheDayModel(imageURL: "", title: "", shortDefinition: "")

	private let discoverService = DiscoverService()

	var collectionCount: Int {
		collections.count
	}

	func viewDidLoad() {
		loadWordOfTheDay()
		loadCollections()
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


	// MARK: - Private Methods
	
	private func loadWordOfTheDay() {
		discoverService.wordOfTheDay { [weak self] result in
			guard let self = self else { return }
			DispatchQueue.main.async {
				switch result {
				case .success(let wordOfTheDay):
					self.wordOfTheDay = wordOfTheDay
					self.view?.reloadWordOfTheDay()
				case .failure(let error):
					print(error)
				}
			}
		}
	}

	private func loadCollections() {
		discoverService.collections { [weak self] result in
			guard let self = self else { return }
			DispatchQueue.main.async {
				switch result {
				case .success(let collections):
					self.collections = collections
					self.view?.reloadCollections()
				case .failure(let error):
					print(error)
				}
			}
		}
	}
}
