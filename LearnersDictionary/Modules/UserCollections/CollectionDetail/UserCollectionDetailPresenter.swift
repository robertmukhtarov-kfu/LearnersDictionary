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
	var collection: UserCollection

	private let userCollectionRepository: UserCollectionRepositoryProtocol

	var title: String {
		collection.title
	}
	var wordCount: Int {
		collection.words.count
	}
	var color: UserCollectionColor {
		collection.color
	}

	init(collection: UserCollection, repository: UserCollectionRepositoryProtocol) {
		self.collection = collection
		self.userCollectionRepository = repository
	}

	func viewDidLoad() {
		view?.reloadData()
	}

	func getWord(forCellAt indexPath: IndexPath) -> String {
		guard let word = collection.words[indexPath.row] as? Word else {
			fatalError("Couldn't get word at indexPath \(indexPath)")
		}
		return word.spelling
	}

	func deleteWord(at indexPath: IndexPath) {
		collection.removeFromWords(at: indexPath.item)
		userCollectionRepository.save()
	}

	func moveWord(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let sourceIndex = sourceIndexPath.item
		let destinationIndex = destinationIndexPath.item

		guard let word = collection.words[sourceIndex] as? Word else {
			fatalError("Couldn't get word at indexPath \(sourceIndexPath) when trying to move it")
		}
		collection.removeFromWords(at: sourceIndex)
		collection.insertIntoWords(word, at: destinationIndex)
		userCollectionRepository.save()
	}

	func didSelectWord(at indexPath: IndexPath) {
		guard let word = collection.words[indexPath.row] as? Word else {
			fatalError("Couldn't get selected word at indexPath \(indexPath)")
		}
		coordinator?.showEntry(for: word)
	}

	func deleteCollectionButtonPressed() {
		view?.showDeleteCollectionAlert()
	}

	func deleteCollection() {
		userCollectionRepository.delete(collection: collection)
		coordinator?.popToRootViewController()
	}

	func showSettings() {

	}

	func hideSettings() {
		
	}
}
