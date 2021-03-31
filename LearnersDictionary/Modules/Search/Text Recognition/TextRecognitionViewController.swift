//
//  TextRecognitionViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 21.03.2021.
//

import UIKit
import FittedSheets

class TextRecognitionViewController: UIViewController {
	var presenter: TextRecognitionPresenter?
	var isEntrySheetShown = false

	private let imageView = RecognizedWordsImageView()
	private var entryPageView: EntryPageView?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupView()
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
		imageView.delegate = self
	}

	@objc func doneButtonTapped(_ sender: UIBarButtonItem) {
		presenter?.doneButtonTapped()
	}
}

extension TextRecognitionViewController: TextRecognitionView {
	func set(image: UIImage) {
		imageView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: image.size)
		imageView.image = image
		let imageScrollViewFrame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
		let imageScrollView = ImageScrollView(frame: imageScrollViewFrame, imageView: imageView)
		view.addSubview(imageScrollView)
		imageScrollView.snp.makeConstraints { make in
			make.edges.equalTo(view)
		}
	}

	func set(entryPageView: EntryPageView) {
		self.entryPageView = entryPageView
	}

	func showRecognizedWords(_ words: [RecognizedWord]) {
		words.forEach { imageView.addRectangle(for: $0) }
	}

	func showEntrySheet() {
		guard let entryPageVC = entryPageView as? EntryPageViewController else { return }
		let entryNavigationController = UINavigationController(rootViewController: entryPageVC)
		entryNavigationController.navigationBar.isTranslucent = false

		let sheetOptions = SheetOptions(
			shrinkPresentingViewController: false,
			useInlineMode: true
		)

		let sheetController = SheetViewController(
			controller: entryNavigationController,
			sizes: [.fixed(200), .fullscreen],
			options: sheetOptions
		)

		sheetController.overlayColor = .clear
		sheetController.allowGestureThroughOverlay = true
		sheetController.didDismiss = { _ in
			self.imageView.deselect()
			self.isEntrySheetShown = false
		}

		sheetController.animateIn(to: view, in: self)
		isEntrySheetShown = true
	}
}

extension TextRecognitionViewController: RecognizedWordViewDelegate {
	func recognizedWordsImageView(didSelect word: String) {
		presenter?.lookUp(word: word)
	}
}
