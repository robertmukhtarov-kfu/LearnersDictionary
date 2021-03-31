//
//  EntryViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 08.03.2021.
//

import UIKit
import SnapKit

class EntryViewController: UIViewController {
	let entry: Entry
	let textView = UITextView()

	init(entry: Entry) {
		self.entry = entry
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .background
		setupTextView()
		setupEntry()
	}

	private func setupTextView() {
		view.addSubview(textView)
		textView.isEditable = false
		textView.snp.makeConstraints { make in
			make.top.equalTo(view).inset(48)
			make.width.bottom.equalTo(view)
		}
		textView.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
	}

	private func setupEntry() {
		let entryText = NSMutableAttributedString()
		entryText.append(NSAttributedString.headword(string: entry.headword))
		if let entryTranscription = entry.transcription {
			entryText.append(NSAttributedString.transcription(string: entryTranscription))
		}
		entryText.append(definitionsString(from: entry.definitions))
		textView.attributedText = entryText
	}

	private func definitionsString(from definitions: [Definition]) -> NSAttributedString {
		let definitionsString = NSMutableAttributedString()
		for definition in definitions {
			for (index, sense) in definition.senses.enumerated() {
				definitionsString.append(NSAttributedString.sense(
					index: index,
					number: sense.number,
					definingText: sense.definingText)
				)
			}
			definitionsString.append(NSAttributedString(string: "\n"))
		}
		return definitionsString
	}
}
