//
//  UserCollectionsProtocols.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 28.04.2021.
//

import Foundation

protocol UserCollectionsViewProtocol: AnyObject {
	func reloadData()
}

protocol UserCollectionsPresenterProtocol {
	var collectionsCount: Int { get }
	func viewDidLoad()
	func getCollection(forCellAt indexPath: IndexPath) -> UserCollectionModel
	func moveCollection(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
	func didSelectCollection(at indexPath: IndexPath)
}
