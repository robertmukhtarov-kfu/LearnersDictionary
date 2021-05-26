//
//  TextRecognitionPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 21.03.2021.
//

import UIKit

class TextRecognitionPresenter: TextRecognitionPresenterProtocol {
	weak var view: TextRecognitionViewProtocol?
	weak var coordinator: TextRecognitionCoordinator?

	private let wordRepository = WordRepository()
	private let textRecognizer = TextRecognitionService()

	let image: UIImage

	init(image: UIImage) {
		self.image = image
	}

	func viewDidLoad() {
		view?.set(image: image)
		recognizeText(on: image)
	}

	func recognizeText(on image: UIImage) {
		DispatchQueue.global(qos: .userInitiated).async {
			self.textRecognizer.recognizeText(in: image) { [weak self] result in
				guard let self = self else { return }
				DispatchQueue.main.async {
					switch result {
					case .success(let recognizedWords):
						if recognizedWords.isEmpty {
							self.view?.showError(message: "Couldn't detect words in this image")
						} else {
							self.view?.showRecognizedWords(recognizedWords)
						}
					case .failure(let error):
						self.view?.showError(message: error.localizedDescription)
					}
				}
			}
		}
	}

	func lookUp(word: String) {
		guard let view = view else { return }
		guard let wordToLookUp = wordRepository.getWord(by: word) else {
			view.showError(message: "No entries found for “\(word)”.")
			return
		}
		let entryPageViewPresenter = EntryPageViewPresenter(word: wordToLookUp)
		let entryPageViewController = EntryPageViewController()
		entryPageViewPresenter.view = entryPageViewController
		entryPageViewController.presenter = entryPageViewPresenter
		view.showEntry(with: entryPageViewController)
	}

	func doneButtonTapped() {
		coordinator?.dismissImagePicker()
	}
}
