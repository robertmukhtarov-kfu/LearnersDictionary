//
//  EntryProtocols.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 31.03.2021.
//

import UIKit

protocol EntryPageView: AnyObject {
	func set(title: String)
	func configure(with entries: [EntryModel])
	func showError(message: String)
	func reset()
	func showAddToCollectionScreen(viewController: UIViewController)
}

protocol EntryPageViewPresenterProtocol {
	func viewDidLoad()
	func set(word: Word)
	func errorOccurred()
	func addToCollectionButtonTapped()
	func pronounce(audioFileName: String)
}

protocol EntryToolbarView {
	func configureSegmentedControl(with items: [String])
}
