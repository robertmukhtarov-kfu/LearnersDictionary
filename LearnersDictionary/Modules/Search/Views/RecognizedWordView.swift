//
//  RecognizedWordView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 22.03.2021.
//

import UIKit

class RecognizedWordView: UIControl {
	let word: String

	override var isSelected: Bool {
		didSet {
			isSelected ? setSelected() : setDeselected()
		}
	}

	init(frame: CGRect, word: String) {
		self.word = word
		super.init(frame: frame)
		setupView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		layer.borderWidth = 2
		layer.cornerRadius = 5
		setDeselected()
	}

	private func setSelected() {
		layer.borderColor = UIColor.systemBlue.cgColor
		layer.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.4).cgColor
	}

	private func setDeselected() {
		layer.borderColor = UIColor.systemGray.cgColor
		layer.backgroundColor = UIColor.systemGray.withAlphaComponent(0.4).cgColor
	}
}
