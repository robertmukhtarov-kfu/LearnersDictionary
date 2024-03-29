//
//  CollectionDetailPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 26.04.2021.
//

import Foundation

class CollectionDetailPresenter: CollectionDetailPresenterProtocol {
	weak var view: CollectionDetailViewProtocol?
	weak var coordinator: DiscoverCoordinator?

	private let collection: DiscoverCollectionModel
	private let wordRepository = WordRepository()

	var wordCount: Int {
		collection.words.count
	}

	var title: String {
		collection.title
	}

	init(collection: DiscoverCollectionModel) {
		self.collection = collection
	}

	func viewDidLoad() {
		view?.reloadData()
	}

	func getWord(forCellAt indexPath: IndexPath) -> DiscoverWordModel {
		collection.words[indexPath.row]
	}

	func didSelectWord(at indexPath: IndexPath) {
		let wordSpelling = collection.words[indexPath.row].title
		guard let word = wordRepository.getWord(by: wordSpelling) else {
			view?.showError(message: "No such word in the database")
			return
		}
		coordinator?.showEntry(for: word)
	}
}
