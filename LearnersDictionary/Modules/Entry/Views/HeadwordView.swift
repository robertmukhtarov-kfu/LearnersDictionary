//
//  HeadwordView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 09.05.2021.
//

import UIKit

protocol HeadwordViewDelegate: AnyObject {
	func pronounceButtonTapped(for audioFileName: String)
}

class HeadwordView: UIStackView {
	weak var delegate: HeadwordViewDelegate?

	private let headword: String
	private let transcription: String?
	private let audioFileName: String?

	private let headwordTextView = EntryTextView()

	private let pronunciationStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.spacing = 6
		return stackView
	}()

	private let transcriptionTextView = EntryTextView()
	private let pronounceButton: UIButton = {
		let button = UIButton(type: .system)
		button.setImage(UIImage(named: "pronounce"), for: .normal)
		button.addTarget(nil, action: #selector(pronounceButtonTapped), for: .touchUpInside)
		return button
	}()

	init(headword: String, transcription: String?, audioFileName: String?) {
		self.headword = headword
		self.transcription = transcription
		self.audioFileName = audioFileName
		super.init(frame: .zero)
		setup()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		axis = .vertical
		alignment = .leading
		spacing = 8

		transcriptionTextView.snp.contentCompressionResistanceHorizontalPriority = 1000
		pronounceButton.snp.contentHuggingHorizontalPriority = 1000

		headwordTextView.attributedText = NSAttributedString(string: headword, attributes: .headword)
		addArrangedSubview(headwordTextView)
		addArrangedSubview(pronunciationStackView)

		if let transcription = transcription {
			transcriptionTextView.attributedText = NSAttributedString(string: "/\(transcription)/", attributes: .body)
			pronunciationStackView.addArrangedSubview(transcriptionTextView)
		}

		if audioFileName != nil {
			pronunciationStackView.addArrangedSubview(pronounceButton)
		}
	}

	@objc private func pronounceButtonTapped() {
		guard let audioFileName = audioFileName else { return }
		delegate?.pronounceButtonTapped(for: audioFileName)
	}
}
