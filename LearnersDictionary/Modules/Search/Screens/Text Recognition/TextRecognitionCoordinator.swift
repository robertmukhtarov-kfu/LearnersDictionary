//
//  TextRecognitionCoordinator.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 21.03.2021.
//

import UIKit

protocol TextRecognitionCoordinatorProtocol {
	func start()
	func startTextRecognition(image: UIImage)
	func dismissImagePicker()
}

class TextRecognitionCoordinator: NSObject, TextRecognitionCoordinatorProtocol {
	let imagePickerController = UIImagePickerController()

	func start() {
		imagePickerController.delegate = self
		imagePickerController.modalPresentationStyle = .fullScreen
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			imagePickerController.sourceType = .camera
		} else {
			imagePickerController.sourceType = .photoLibrary
		}
	}

	func startTextRecognition(image: UIImage) {
		let textRecognitionVC = TextRecognitionViewController()
		let textRecognitionPresenter = TextRecognitionPresenter(image: image)
		textRecognitionPresenter.coordinator = self
		textRecognitionPresenter.view = textRecognitionVC
		textRecognitionVC.presenter = textRecognitionPresenter
		imagePickerController.pushViewController(textRecognitionVC, animated: false)
	}

	func dismissImagePicker() {
		imagePickerController.dismiss(animated: true)
	}
}

extension TextRecognitionCoordinator: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		guard let image = info[.originalImage] as? UIImage else {
			return
		}
		startTextRecognition(image: image)
	}
}
