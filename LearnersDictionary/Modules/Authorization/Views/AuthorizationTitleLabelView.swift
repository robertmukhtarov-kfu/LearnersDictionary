//
//  AuthorizationTitleLabelView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 16.05.2021.
//

import UIKit

class AuthorizationTitleLabelView: UILabel {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	convenience init(text: String) {
		self.init(frame: .zero)
		self.text = text
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		font = .systemFont(ofSize: 36, weight: .bold)
		textAlignment = .center
	}
}
