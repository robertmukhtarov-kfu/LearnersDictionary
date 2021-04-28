//
//  CollectionDetailPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 26.04.2021.
//

import Foundation

class CollectionDetailPresenter {
	weak var view: CollectionDetailViewController?
	var coordinator: DiscoverCoordinator?
	let collection: DiscoverCollectionModel

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

	func getWord(forCellAt indexPath: IndexPath) -> (title: String, shortDefinition: String) {
		collection.words[indexPath.row]
	}

	func didSelectWord(at indexPath: IndexPath) {
		let word = collection.words[indexPath.row]
		coordinator?.showEntry(for: word.title)
	}
}
