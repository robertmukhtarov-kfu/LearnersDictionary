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

	private let wordRepository = WordRepository()

	private let discoverService = FirebaseDiscoverService()
	private var tasksLeft = 2 {
		didSet {
			if tasksLeft == 0 {
				DispatchQueue.main.async { [weak self] in
					guard let self = self else { return }
					self.view?.reloadData()
					self.view?.hideActivityIndicator()
				}
			}
		}
	}

	var collectionCount: Int {
		collections.count
	}

	func viewDidLoad() {
		loadData()
	}

	func getWordOfTheDay() -> WordOfTheDayModel {
		wordOfTheDay
	}

	func getCollection(forCellAt indexPath: IndexPath) -> DiscoverCollectionModel {
		collections[indexPath.item]
	}

	func showWordOfTheDay(cardView: CardView) {
		guard let word = wordRepository.getWord(by: wordOfTheDay.title) else {
			// TODO: alert
			print("No such word in the database")
			return
		}
		coordinator?.showWordOfTheDay(word, cardView: cardView)
	}

	func showDiscoverCollection(at index: Int, cardView: CardView) {
		coordinator?.showDiscoverCollection(collections[index], cardView: cardView)
	}


	// MARK: - Private Methods

	private func loadData() {
		loadWordOfTheDay()
		loadCollections()
	}

	private func loadWordOfTheDay() {
		discoverService.wordOfTheDay { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let wordOfTheDay):
				self.wordOfTheDay = wordOfTheDay
			case .failure(let error):
				print(error)
			}
			self.tasksLeft -= 1
		}
	}

	private func loadCollections() {
		discoverService.collections { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let collections):
				self.collections = collections
			case .failure(let error):
				print(error)
			}
			self.tasksLeft -= 1
		}
	}
}
