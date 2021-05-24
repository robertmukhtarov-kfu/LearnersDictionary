//
//  AuthorizationButton.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 16.05.2021.
//

import UIKit

class AuthorizationButton: UIButton {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	override var isHighlighted: Bool {
		didSet {
			UIView.animate(withDuration: 0.2) {
				self.alpha = self.isHighlighted ? 0.5 : 1
			}
		}
	}

	override var intrinsicContentSize: CGSize {
		.init(width: 120, height: 40)
	}

	convenience init(title: String) {
		self.init(frame: .zero)
		setTitle(title, for: .normal)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
		backgroundColor = .systemBlue
		layer.cornerRadius = 8
		adjustsImageWhenHighlighted = true
	}
}
