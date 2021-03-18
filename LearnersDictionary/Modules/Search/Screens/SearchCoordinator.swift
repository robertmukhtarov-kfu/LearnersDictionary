//
//  SearchCoordinator.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 01.03.2021.
//

import UIKit

class SearchCoordinator {
	var navigationController: SearchNavigationController

    init(navigationController: SearchNavigationController = SearchNavigationController()) {
		self.navigationController = navigationController
		showWordlist()
    }

	func showWordlist() {
		let wordlistPresenter = WordlistPresenter()
		let wordlistVC = WordlistViewController()
		wordlistPresenter.coordinator = self
		wordlistPresenter.view = wordlistVC
		wordlistVC.presenter = wordlistPresenter
		navigationController.pushViewController(wordlistVC, animated: false)
	}

	func showEntry(for word: String) {
		let entryPageViewPresenter = EntryPageViewPresenter(word: word)
		let entryPageViewController = EntryPageViewController()
		entryPageViewPresenter.coordinator = self
		entryPageViewPresenter.view = entryPageViewController
		entryPageViewController.presenter = entryPageViewPresenter
		navigationController.pushViewController(entryPageViewController, animated: true)
	}

	func closeEntry() {
		navigationController.popToRootViewController(animated: true)
	}
}
