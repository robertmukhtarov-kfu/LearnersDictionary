//
//  MyCollectionsPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 23.04.2021.
//

import Foundation

class UserCollectionsPresenter: UserCollectionsPresenterProtocol {
	weak var view: UserCollectionsViewProtocol?
	var coordinator: UserCollectionsCoordinator?

	var collectionsCount: Int {
		collections.count
	}

	private var collections: [UserCollectionModel] = []

	private let userCollectionService = MockUserCollectionService()

	func viewDidLoad() {
		setupCollections()
		view?.reloadData()
	}

	private func setupCollections() {
		userCollectionService.collections { result in
			switch result {
			case .success(let userCollections):
				self.collections = userCollections
			case .failure(let error):
				print(error)
			}
		}
	}

	func getCollection(forCellAt indexPath: IndexPath) -> UserCollectionModel {
		collections[indexPath.item]
	}

	func moveCollection(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		let sourceIndex = sourceIndexPath.item
		let destinationIndex = destinationIndexPath.item

		let collection = collections[sourceIndex]
		collections.remove(at: sourceIndex)
		collections.insert(collection, at: destinationIndex)
	}

	func didSelectCollection(at indexPath: IndexPath) {
		let collection = collections[indexPath.row]
		coordinator?.showUserCollectionDetails(collection: collection)
	}
}
