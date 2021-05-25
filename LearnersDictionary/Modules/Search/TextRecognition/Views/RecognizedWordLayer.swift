//
//  RecognizedWordLayer.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 27.03.2021.
//

import UIKit

class RecognizedWordLayer: CAShapeLayer, RecognizedWordLayerProtocol {
	let word: String

	init(frame: CGRect, word: String) {
		self.word = word
		super.init()
		path = UIBezierPath(roundedRect: frame, cornerRadius: 16).cgPath
		lineWidth = 4
		deselect()
	}

	override init(layer: Any) {
		if let layer = layer as? RecognizedWordLayer {
			word = layer.word
		} else {
			word = ""
		}
		super.init(layer: layer)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func select() {
		fillColor = UIColor.systemBlue.withAlphaComponent(0.3).cgColor
		strokeColor = UIColor.systemBlue.cgColor
	}

	func deselect() {
		fillColor = UIColor.gray.withAlphaComponent(0.3).cgColor
		strokeColor = UIColor.gray.cgColor
	}
}
