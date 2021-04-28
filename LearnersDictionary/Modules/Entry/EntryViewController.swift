//
//  EntryViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 08.03.2021.
//

import UIKit
import SnapKit

class EntryViewController: UIViewController, TrackedScrollViewProtocol {
	let entry: EntryModel
	let textView = UITextView()
	weak var trackedScrollViewDelegate: TrackedScrollViewDelegate?

	init(entry: EntryModel) {
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
		textView.delegate = self
		textView.alwaysBounceVertical = true
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

	private func definitionsString(from definitions: [DefinitionModel]) -> NSAttributedString {
		let definitionsString = NSMutableAttributedString()
		for definition in definitions {
			for (index, sense) in definition.senses.enumerated() {
				definitionsString.append(NSAttributedString.sense(
					index: index,
					number: sense.number,
					definingText: sense.text)
				)
			}
			definitionsString.append(NSAttributedString(string: "\n"))
		}
		return definitionsString
	}
}

extension EntryViewController: UITextViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let newOffset = scrollView.contentOffset.y
		trackedScrollViewDelegate?.didScroll(scrollView, to: newOffset)
	}
}
