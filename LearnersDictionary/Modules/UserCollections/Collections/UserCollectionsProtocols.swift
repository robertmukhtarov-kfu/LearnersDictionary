//
//  UserCollectionsProtocols.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 28.04.2021.
//

import Foundation

protocol UserCollectionsViewProtocol: AnyObject {
	func reloadData()
	func showNewCollectionAlert()
	func finish()
	func showNoCollectionsView()
	func hideNoCollectionsView()
}

protocol UserCollectionsPresenterProtocol {
	var mode: UserCollectionsMode { get }
	var title: String { get }
	var collectionsCount: Int { get }
	func viewWillAppear()
	func getCollection(forCellAt indexPath: IndexPath) -> UserCollection
	func moveCollection(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
	func didSelectCollection(at indexPath: IndexPath)
	func addNewCollectionButtonPressed()
	func cancelButtonPressed()
	func addNewCollection(named name: String)
	func userProfileButtonTapped()
}
