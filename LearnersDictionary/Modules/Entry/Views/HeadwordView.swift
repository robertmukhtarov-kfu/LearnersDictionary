//
//  HeadwordView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 09.05.2021.
//

import UIKit

class HeadwordView: UIStackView {
	private let headword: String
	private let transcription: String?

	init(headword: String, transcription: String?) {
		self.headword = headword
		self.transcription = transcription
		super.init(frame: .zero)
		setup()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let headwordTextView = EntryTextView()
	private let transcriptionTextView = EntryTextView()

	private func setup() {
		axis = .vertical
		alignment = .leading
		spacing = 8

		headwordTextView.attributedText = NSAttributedString(string: headword, attributes: .headword)
		addArrangedSubview(headwordTextView)

		if let transcription = transcription {
			transcriptionTextView.attributedText = NSAttributedString(string: "/\(transcription)/", attributes: .body)
			addArrangedSubview(transcriptionTextView)
		}
	}
}
