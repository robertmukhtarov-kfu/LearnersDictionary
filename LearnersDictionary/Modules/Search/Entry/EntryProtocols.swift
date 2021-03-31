//
//  EntryProtocols.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 31.03.2021.
//

import UIKit

protocol EntryPageView: AnyObject {
	func set(title: String)
	func configure(with entries: [Entry])
	func showError(message: String)
	func reset()
}

protocol EntryPageViewPresenterProtocol {
	func viewDidLoad()
	func set(word: String)
	func errorOccurred()
}

protocol EntryToolbarView {
	func configureSegmentedControl(with items: [String])
}
