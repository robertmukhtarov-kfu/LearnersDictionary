//
//  EntryTextView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 09.05.2021.
//

import UIKit

class EntryTextView: UITextView {
	init() {
		super.init(frame: .zero, textContainer: nil)
		isEditable = false
		textContainerInset = .zero
		isScrollEnabled = false
		textContainer.lineFragmentPadding = 0
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
