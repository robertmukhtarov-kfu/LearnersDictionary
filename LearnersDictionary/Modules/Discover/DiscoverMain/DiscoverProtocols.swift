//
//  DiscoverProtocols.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 28.04.2021.
//

import UIKit

protocol DiscoverViewProtocol: AnyObject {
	func reloadData()
	func hideActivityIndicator()
	func showError(message: String)
}

protocol DiscoverPresenterProtocol {
	var collectionCount: Int { get }
	func viewDidLoad()
	func getWordOfTheDay() -> WordOfTheDayModel
	func getCollection(forCellAt indexPath: IndexPath) -> DiscoverCollectionModel
	func showWordOfTheDay(cardView: CardView)
	func showDiscoverCollection(at index: Int, cardView: CardView)
}
