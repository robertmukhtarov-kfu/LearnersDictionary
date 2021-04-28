//
//  SearchCoordinator.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 01.03.2021.
//

import UIKit

protocol SearchCoordinatorProtocol {
	func showWordlist()
	func showEntry(for word: String)
	func showCamera()
	func closeEntry()
}

class SearchCoordinator: SearchCoordinatorProtocol {
	let navigationController: UINavigationController
	let textRecognitionCoordinator = TextRecognitionCoordinator()

	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
		navigationController.navigationBar.isTranslucent = false
		navigationController.navigationBar.prefersLargeTitles = true
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

	func showCamera() {
		textRecognitionCoordinator.start()
		let imagePickerVC = textRecognitionCoordinator.imagePickerController
		navigationController.present(imagePickerVC, animated: true)
	}

	func closeEntry() {
		navigationController.popToRootViewController(animated: true)
	}
}
