//
//  DefinitionView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 09.05.2021.
//

import UIKit

class DefinitionView: UIStackView {
	private let definition: DefinitionModel

	private let numberLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 18, weight: .bold)
		return label
	}()

	private let sensesTextView = EntryTextView()

	init(definition: DefinitionModel) {
		self.definition = definition
		super.init(frame: .zero)
		setup()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		if let number = definition.number {
			numberLabel.text = number
			numberLabel.snp.contentHuggingHorizontalPriority = 1000
			addArrangedSubview(numberLabel)
		}
		sensesTextView.attributedText = senseText(from: definition.senses)
		axis = .horizontal
		alignment = .top
		distribution = .fill
		spacing = 16
		addArrangedSubview(sensesTextView)
	}

	private func senseText(from senses: [SenseModel]) -> NSMutableAttributedString {
		let text = NSMutableAttributedString()
		for (index, sense) in senses.enumerated() {
			if let senseNumber = sense.number {
				text.append(NSAttributedString(string: senseNumber + " ", attributes: .senseNumber))
			}
			text.append(sense.text)
			if index != senses.count - 1 {
				text.append(.newLine)
			}
		}
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.paragraphSpacing = 5
		text.addAttribute(
			.paragraphStyle,
			value: paragraphStyle,
			range: NSRange(location: 0, length: text.length)
		)
		return text
	}
}
