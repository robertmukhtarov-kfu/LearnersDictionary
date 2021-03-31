//
//  TextRecognitionPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 21.03.2021.
//

import UIKit

class TextRecognitionPresenter: TextRecognitionPresenterProtocol {
	weak var view: TextRecognitionView?
	var coordinator: TextRecognitionCoordinator?

	private let entryPageViewPresenter = EntryPageViewPresenter()
	private let textRecognizer = TextRecognitionService()

	let image: UIImage

	init(image: UIImage) {
		self.image = image
	}

	func viewDidLoad() {
		view?.set(image: image)
		setupEntryPage()
		recognizeText(on: image)
	}

	private func setupEntryPage() {
		let entryPageViewController = EntryPageViewController()
		entryPageViewPresenter.view = entryPageViewController
		view?.set(entryPageView: entryPageViewController)
	}

	func recognizeText(on image: UIImage) {
		DispatchQueue.global(qos: .userInitiated).async {
			self.textRecognizer.recognizeText(in: image) { result in
				DispatchQueue.main.async {
					switch result {
					case .success(let recognizedWords):
						self.view?.showRecognizedWords(recognizedWords)
					case .failure(let error):
						print(error.localizedDescription)
					}
				}
			}
		}
	}

	func lookUp(word: String) {
		guard let view = view else { return }
		entryPageViewPresenter.set(word: word)
		if !view.isEntrySheetShown { view.showEntrySheet() }
	}

	func doneButtonTapped() {
		coordinator?.dismissImagePicker()
	}

	func assignEntryPageViewToPresenter(_ entryPageView: EntryPageView) {
		entryPageViewPresenter.view = entryPageView
	}
}
