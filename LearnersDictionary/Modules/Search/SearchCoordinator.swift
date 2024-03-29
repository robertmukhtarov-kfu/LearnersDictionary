//
//  SearchCoordinator.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 01.03.2021.
//

import UIKit

protocol SearchCoordinatorProtocol {
	func showWordlist()
	func showEntry(for word: Word)
	func showImagePicker(pickerSourceType: UIImagePickerController.SourceType)
	func closeEntry()
}

class SearchCoordinator: SearchCoordinatorProtocol {
	let navigationController: UINavigationController
	let textRecognitionCoordinator = TextRecognitionCoordinator()

	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
		setupNavigationController()
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

	func showEntry(for word: Word) {
		let entryPageViewPresenter = EntryPageViewPresenter(word: word)
		let entryPageViewController = EntryPageViewController()
		entryPageViewPresenter.coordinator = self
		entryPageViewPresenter.view = entryPageViewController
		entryPageViewController.presenter = entryPageViewPresenter
		navigationController.pushViewController(entryPageViewController, animated: true)
	}

	func showImagePicker(pickerSourceType: UIImagePickerController.SourceType) {
		textRecognitionCoordinator.start(pickerSourceType: pickerSourceType)
		let imagePickerVC = textRecognitionCoordinator.imagePickerController
		navigationController.present(imagePickerVC, animated: true)
	}

	func closeEntry() {
		navigationController.popToRootViewController(animated: true)
	}

	// MARK: - Private Methods

	func setupNavigationController() {
		navigationController.navigationBar.isTranslucent = false
		navigationController.navigationBar.prefersLargeTitles = true
	}
}
