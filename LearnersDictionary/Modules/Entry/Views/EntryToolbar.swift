//
//  EntryToolbar.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 12.03.2021.
//

import UIKit

class EntryToolbar: UIView, EntryToolbarView {
	let segmentedControl = UISegmentedControl(items: [])

	override init(frame: CGRect) {
		super.init(frame: frame)
		setupToolbar()
		setupFakeNavbarShadow()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configureSegmentedControl(with items: [String]) {
		for (index, title) in items.enumerated() {
			segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
		}
		segmentedControl.selectedSegmentIndex = 0
	}

	// MARK: - Private Methods

	private func setupToolbar() {
		backgroundColor = .background
		addSubview(segmentedControl)
		segmentedControl.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.centerX.equalToSuperview()
			make.height.equalTo(32)
			make.width.equalToSuperview().offset(-32)
		}
	}

	private func setupFakeNavbarShadow() {
		let fakeNavbarShadow = UIView(frame: .zero)
		fakeNavbarShadow.backgroundColor = .navigationBarShadow
		addSubview(fakeNavbarShadow)
		fakeNavbarShadow.snp.makeConstraints { make in
			make.top.equalTo(snp.bottom)
			make.left.right.equalToSuperview()
			make.height.equalTo(0.25)
		}
	}
}
