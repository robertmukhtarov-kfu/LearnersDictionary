//
//  TextRecognitionProtocols.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 31.03.2021.
//

import UIKit

protocol TextRecognitionCoordinatorProtocol {
	func start(pickerSourceType: UIImagePickerController.SourceType)
	func startTextRecognition(image: UIImage)
	func dismissImagePicker()
}

protocol TextRecognitionViewProtocol: AnyObject {
	func set(image: UIImage)
	func showRecognizedWords(_ words: [RecognizedWordModel])
	func showError(message: String)
	func showEntry(with viewController: UIViewController)
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
