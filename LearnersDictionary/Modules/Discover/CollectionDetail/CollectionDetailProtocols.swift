//
//  CollectionDetailProtocols.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 26.05.2021.
//

import Foundation

protocol CollectionDetailViewProtocol: AnyObject {
	func showError(message: String)
	func reloadData()
}

protocol CollectionDetailPresenterProtocol {
	var wordCount: Int { get }
	var title: String { get }
	func viewDidLoad()
	func getWord(forCellAt indexPath: IndexPath) -> DiscoverWordModel
	func didSelectWord(at indexPath: IndexPath)
}
