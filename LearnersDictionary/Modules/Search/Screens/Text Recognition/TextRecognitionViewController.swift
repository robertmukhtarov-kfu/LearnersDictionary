//
//  TextRecognitionViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 21.03.2021.
//

import UIKit

class TextRecognitionViewController: UIViewController {
	var presenter: TextRecognitionPresenter?
	let imageView = UIImageView()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
		setupImageView()
		presenter?.viewDidLoad()
	}

	private func setupView() {
		view.backgroundColor = .black
		edgesForExtendedLayout = []
		navigationController?.isNavigationBarHidden = false
		navigationController?.navigationBar.barStyle = .blackTranslucent
		navigationController?.navigationBar.barTintColor = .black
		navigationItem.rightBarButtonItem = .init(
			barButtonSystemItem: .done,
			target: self,
			action: #selector(doneButtonTapped(_:))
		)
		navigationItem.hidesBackButton = true
	}

	private func setupImageView() {
		view.addSubview(imageView)
		let safeArea = view.safeAreaLayoutGuide
		imageView.snp.makeConstraints { make in
			make.top.equalTo(safeArea.snp.topMargin)
			make.bottom.equalTo(safeArea.snp.bottomMargin)
			make.left.right.equalTo(view)
		}
		imageView.contentMode = .scaleAspectFit
	}

	@objc func doneButtonTapped(_ sender: UIBarButtonItem) {
		presenter?.doneButtonTapped()
	}
}

extension TextRecognitionViewController: TextRecognitionView {
	func setImage(_ image: UIImage) {
		imageView.image = image
	}

	func showRecognizedWords(_ words: [RecognizedWord]) {
		for word in words {
			let transformedFrame = word.frame.applying(transformMatrix())
			let recognizedWordView = RecognizedWordView(frame: transformedFrame, word: word.text)
			recognizedWordView.addTarget(self, action: #selector(tappedOnWord(_:)), for: .touchUpInside)
			view.addSubview(recognizedWordView)
		}
	}

	@objc private func tappedOnWord(_ sender: RecognizedWordView) {
		presenter?.lookUp(word: sender.word)
//		sender.isSelected = true
	}

	private func transformMatrix() -> CGAffineTransform {
		guard let image = imageView.image else { return CGAffineTransform() }
		let imageViewWidth = imageView.frame.size.width
		let imageViewHeight = imageView.frame.size.height
		let imageWidth = image.size.width
		let imageHeight = image.size.height

		let imageViewAspectRatio = imageViewWidth / imageViewHeight
		let imageAspectRatio = imageWidth / imageHeight
		let scale =
			imageViewAspectRatio > imageAspectRatio
			? imageViewHeight / imageHeight : imageViewWidth / imageWidth

		let scaledImageWidth = imageWidth * scale
		let scaledImageHeight = imageHeight * scale
		let xValue = (imageViewWidth - scaledImageWidth) / CGFloat(2.0)
		let yValue = (imageViewHeight - scaledImageHeight) / CGFloat(2.0)

		var transform = CGAffineTransform.identity
		transform = transform.translatedBy(x: xValue, y: yValue)
		transform = transform.scaledBy(x: scale, y: scale)
		return transform
	}
}
