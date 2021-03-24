//
//  TextRecognitionService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 22.03.2021.
//

import MLKit

protocol TextRecognitionServiceProtocol {
	func recognizeText(in image: UIImage, completion: @escaping (Result<[RecognizedWord], Error>) -> Void)
}

class TextRecognitionService: TextRecognitionServiceProtocol {
	func recognizeText(in image: UIImage, completion: @escaping (Result<[RecognizedWord], Error>) -> Void) {
		guard let rotatedImage = image.redrawnWithCorrectOrientation() else {
			return completion(.success([]))
		}
		let visionImage = VisionImage(image: rotatedImage)
		let textRecognizer = TextRecognizer.textRecognizer()
		textRecognizer.process(visionImage) { result, error in
			if let error = error {
				return completion(.failure(error))
			}
			guard let result = result else {
				return completion(.success([]))
			}
			let words = self.extractWords(from: result)
			return completion(.success(words))
		}
	}

	private func extractWords(from text: Text) -> [RecognizedWord] {
		var words: [RecognizedWord] = []
		for block in text.blocks {
			for line in block.lines {
				for element in line.elements {
					let recognizedWord = RecognizedWord(
						text: element.text.lowercased(),
						frame: element.frame
					)
					words.append(recognizedWord)
				}
			}
		}
		return words
	}
}
