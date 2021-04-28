//
//  UserCollectionDetailProtocol.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 28.04.2021.
//

import UIKit

protocol UserCollectionDetailViewProtocol: AnyObject {
	func reloadData()
}

protocol UserCollectionDetailPresenterProtocol {
	var wordCount: Int { get }
	var color: UIColor { get }
	var title: String { get }
	func viewDidLoad()
	func getWord(forCellAt indexPath: IndexPath) -> String
	func deleteWord(at indexPath: IndexPath)
	func moveWord(from sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
	func didSelectWord(at indexPath: IndexPath)
}
