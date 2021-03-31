//
//  TextRecognitionProtocols.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 31.03.2021.
//

import UIKit

protocol TextRecognitionCoordinatorProtocol {
	func start()
	func startTextRecognition(image: UIImage)
	func dismissImagePicker()
}

protocol TextRecognitionView: AnyObject {
	var isEntrySheetShown: Bool { get }
	func set(image: UIImage)
	func set(entryPageView: EntryPageView)
	func showRecognizedWords(_ words: [RecognizedWordModel])
	func showEntrySheet()
}

protocol TextRecognitionPresenterProtocol {
	func viewDidLoad()
	func doneButtonTapped()
	func lookUp(word: String)
	func recognizeText(on image: UIImage)
}

protocol RecognizedWordsImageViewProtocol {
	func deselect()
}

protocol RecognizedWordViewDelegate: AnyObject {
	func recognizedWordsImageView(didSelect word: String)
}

protocol RecognizedWordLayerProtocol {
	func select()
	func deselect()
}
