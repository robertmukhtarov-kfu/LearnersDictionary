//
//  TextRecognitionPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 21.03.2021.
//

import UIKit

protocol TextRecognitionView: AnyObject {
	func setImage(_ image: UIImage)
	func showRecognizedWords(_ words: [RecognizedWord])
}

protocol TextRecognitionPresenterProtocol {
	func viewDidLoad()
	func doneButtonTapped()
	func lookUp(word: String)
	func recognizeText(on image: UIImage)
}

class TextRecognitionPresenter: TextRecognitionPresenterProtocol {
	weak var view: TextRecognitionView?
	var coordinator: TextRecognitionCoordinator?
	let textRecognizer = TextRecognitionService()

	let image: UIImage

	init(image: UIImage) {
		self.image = image
	}

	func viewDidLoad() {
		view?.setImage(image)
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
		coordinator?.showEntrySheet(for: word)
	}

	func doneButtonTapped() {
		coordinator?.dismissImagePicker()
	}
}
