//
//  AuthorizationTextField.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 16.05.2021.
//

import UIKit

class AuthorizationTextField: UITextField {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	override var intrinsicContentSize: CGSize {
		var size = super.intrinsicContentSize
		size.height = 44
		return size
	}

	convenience init(placeholder: String, returnKeyType: UIReturnKeyType) {
		self.init(frame: .zero)
		self.placeholder = placeholder
		self.returnKeyType = returnKeyType
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		borderStyle = .roundedRect
		autocapitalizationType = .none
		spellCheckingType = .no
		autocorrectionType = .no
	}
}
