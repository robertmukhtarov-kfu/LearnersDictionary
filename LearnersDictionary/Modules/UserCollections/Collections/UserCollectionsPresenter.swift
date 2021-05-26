//
//  MyCollectionsPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 23.04.2021.
//

import Foundation

enum UserCollectionsMode {
	case main
	case add(Word)
}

class UserCollectionsPresenter: UserCollectionsPresenterProtocol {
	weak var view: UserCollectionsViewProtocol?
	weak var coordinator: UserCollectionsCoordinator?
	let mode: UserCollectionsMode

	var title: String {
		switch mode {
		case .add:
			return "Choose Collection"
		default:
			return "My Collections"
		}
	}
	var collectionsCount: Int {
		let collectionsCount = user.collections.count
		collectionsCount == 0 ? view?.showNoCollectionsView() : view?.hideNoCollectionsView()
		return collectionsCount
	}

	private let userCollectionRepository = UserCollectionRepository()
	private let user: User

	init(mode: UserCollectionsMode) {
		self.mode = mode
		user = userCollectionRepository.getUser()
		userCollectionRepository.syncCollections { [weak self] in
			DispatchQueue.main.async {
				self?.view?.reloadData()
			}
		}
	}

	func viewWillAppear() {
		view?.reloadData()
	}

	func getCollection(forCellAt indexPath: IndexPath) -> UserCollection {
		guard let collection = user.collections[indexPath.item] as? UserCollection else {
			fatalError("Couldn't get collection for \(indexPath)")
		}
		return collection
	}

	func moveCollection(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let sourceIndex = sourceIndexPath.item
		let destinationIndex = destinationIndexPath.item

		guard let collection = user.collections[sourceIndex] as? UserCollection else {
			fatalError("Couldn't get collection at indexPath \(sourceIndexPath) when trying to move it")
		}
		user.removeFromCollections(at: sourceIndex)
		user.insertIntoCollections(collection, at: destinationIndex)
		userCollectionRepository.save()
	}

	func didSelectCollection(at indexPath: IndexPath) {
		guard let collection = user.collections[indexPath.item] as? UserCollection else {
			fatalError("Couldn't get selected collection at indexPath \(indexPath)")
		}
		switch mode {
		case .main:
			coordinator?.showUserCollectionDetails(collection: collection, repository: userCollectionRepository)
		case .add(let word):
			collection.addToWords(word)
			userCollectionRepository.save()
			view?.finish()
		}
	}

	func addNewCollectionButtonPressed() {
		view?.showNewCollectionAlert()
	}

	func cancelButtonPressed() {
		view?.finish()
	}

	func addNewCollection(named title: String) {
		let title = title.isEmpty ? "Untitled" : title
		let collection = userCollectionRepository.createCollection(named: title)
		user.addToCollections(collection)
		userCollectionRepository.save()
		view?.reloadData()
	}

	func userProfileButtonTapped() {
		coordinator?.showAuthorization()
	}
}
