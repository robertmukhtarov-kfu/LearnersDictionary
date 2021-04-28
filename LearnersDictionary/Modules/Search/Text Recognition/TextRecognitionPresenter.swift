//
//  TextRecognitionPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 21.03.2021.
//

import UIKit

class TextRecognitionPresenter: TextRecognitionPresenterProtocol {
	weak var view: TextRecognitionViewProtocol?
	var coordinator: TextRecognitionCoordinator?

	private let entryRepository = EntryRepository()
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
		view.prepareEntrySheet(for: word)
		entryRepository.entries(for: word) { result in
			switch result {
			case .success(let parsedEntries):
				view.showEntries(parsedEntries)
			case .failure(let error):
				view.showError(message: error.localizedDescription)
			}
		}
	}

	func doneButtonTapped() {
		coordinator?.dismissImagePicker()
	}
}
