//
//  AddButton.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 18.04.2021.
//

import UIKit

class AddButton: UIButton {
	override open var isHighlighted: Bool {
		didSet {
			UIView.animate(withDuration: 0.3) {
				self.layer.opacity = self.isHighlighted ? 0.7 : 1.0
			}
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		setTitle("ADD", for: .normal)
		setImage(UIImage(named: "addToCollections"), for: .normal)
		imageView?.tintColor = .white
		adjustsImageWhenHighlighted = false
		imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 12)
		titleLabel?.font = .boldSystemFont(ofSize: 15)
		backgroundColor = .systemBlue
		layer.cornerRadius = frame.height / 2
	}
}
