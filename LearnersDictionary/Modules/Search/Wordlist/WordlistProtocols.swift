//
//  WordlistProtocols.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 31.03.2021.
//

import UIKit

protocol WordlistViewProtocol: AnyObject {
	func reloadData()
	func showError(message: String)
}

protocol WordlistPresenterProtocol {
	var numberOfSections: Int { get }
	var indexTitles: [String] { get }
	func viewDidLoad()
	func getTitle(forCellAt indexPath: IndexPath) -> String
	func getNumberOfRows(in section: Int) -> Int
	func searchBarTextDidChange(text: String)
	func searchBarCancelTapped()
	func didSelectWord(at indexPath: IndexPath)
	func cameraButtonTapped()
}
