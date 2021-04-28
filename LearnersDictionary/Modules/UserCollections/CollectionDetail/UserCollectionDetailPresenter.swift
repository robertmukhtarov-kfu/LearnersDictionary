//
//  UserCollectionDetailPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 25.04.2021.
//

import UIKit

class UserCollectionDetailPresenter: UserCollectionDetailPresenterProtocol {
	weak var view: UserCollectionDetailViewProtocol?
	var coordinator: UserCollectionsCoordinator?
	var collection: UserCollectionModel

	var wordCount: Int {
		collection.words.count
	}
	var color: UIColor {
		collection.color
	}
	var title: String {
		collection.title
	}

	init(collection: UserCollectionModel) {
		self.collection = collection
	}

	func viewDidLoad() {
		view?.reloadData()
	}

	func getWord(forCellAt indexPath: IndexPath) -> String {
		collection.words[indexPath.row]
	}

	func deleteWord(at indexPath: IndexPath) {
		collection.words.remove(at: indexPath.row)
	}

	func moveWord(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let sourceIndex = sourceIndexPath.item
		let destinationIndex = destinationIndexPath.item

		let word = collection.words[sourceIndex]
		collection.words.remove(at: sourceIndex)
		collection.words.insert(word, at: destinationIndex)
	}

	func didSelectWord(at indexPath: IndexPath) {
		let word = collection.words[indexPath.row]
		coordinator?.showEntry(for: word)
	}
}
