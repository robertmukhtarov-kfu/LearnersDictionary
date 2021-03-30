//
//  RecognizedWordsImageView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 27.03.2021.
//

import UIKit

protocol RecognizedWordsImageViewProtocol {
	func deselect()
}

protocol RecognizedWordViewDelegate: AnyObject {
	func recognizedWordsImageView(didSelect word: String)
}

class RecognizedWordsImageView: UIImageView, RecognizedWordsImageViewProtocol {
	private var rectangles: [RecognizedWordLayer] = []
	private var selectedLayer: RecognizedWordLayer?
	weak var delegate: RecognizedWordViewDelegate?

	init() {
		super.init(frame: CGRect())
		isUserInteractionEnabled = true
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func addRectangle(for recognizedWord: RecognizedWord) {
		let frame = recognizedWord.frame
		let text = recognizedWord.text
		let recognizedWordLayer = RecognizedWordLayer(frame: frame, word: text)
		layer.addSublayer(recognizedWordLayer)
	}

	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let point = touches.first?.location(in: self) else { return }
		guard let sublayers = layer.sublayers else { return }
		for sublayer in sublayers {
			guard let recognizedWordLayer = sublayer as? RecognizedWordLayer else { continue }
			guard let path = recognizedWordLayer.path else { continue }
			if path.contains(point) {
				deselect()
				recognizedWordLayer.select()
				delegate?.recognizedWordsImageView(didSelect: recognizedWordLayer.word)
				selectedLayer = recognizedWordLayer
			}
		}
	}

	func deselect() {
		selectedLayer?.deselect()
		selectedLayer = nil
	}
}
