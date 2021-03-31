//
//  EntryToolbar.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 12.03.2021.
//

import UIKit

class EntryToolbar: UIToolbar, EntryToolbarView {
	let segmentedControl = UISegmentedControl(items: [])

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupToolbar()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupToolbar() {
		barTintColor = .background
		isTranslucent = false
		let container = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
		container.addSubview(segmentedControl)
		container.snp.makeConstraints { make in
			make.height.equalTo(container.frame.height)
		}
		segmentedControl.snp.makeConstraints { make in
			make.left.right.equalToSuperview()
			make.top.equalTo(container.snp.top)
		}
		setItems([UIBarButtonItem(customView: container)], animated: true)
	}

	func configureSegmentedControl(with items: [String]) {
		for (index, title) in items.enumerated() {
			segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
		}
		segmentedControl.selectedSegmentIndex = 0
	}
}
