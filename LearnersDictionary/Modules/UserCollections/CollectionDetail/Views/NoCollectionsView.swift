//
//  NoCollectionsView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 25.05.2021.
//

import UIKit

class NoCollectionsView: UIStackView {
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.text = "No Collections"
		label.font = .systemFont(ofSize: 22, weight: .bold)
		return label
	}()

	private let hintLabel: UILabel = {
		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = .systemFont(ofSize: 16, weight: .regular)
		label.text = "Tap the button on the top right to add a new collection"
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		axis = .vertical
		alignment = .center
		distribution = .fillEqually

		addArrangedSubview(titleLabel)
		addArrangedSubview(hintLabel)
	}
}
