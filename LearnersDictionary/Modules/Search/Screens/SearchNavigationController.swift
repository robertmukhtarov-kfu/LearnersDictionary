//
//  SearchNavigationController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 12.03.2021.
//

import UIKit

class SearchNavigationController: UINavigationController {
	init() {
		super.init(navigationBarClass: nil, toolbarClass: nil)
		setup()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setup()
	}

	// For iOS 11
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}

	private func setup() {
		navigationBar.isTranslucent = false
		navigationBar.prefersLargeTitles = true
		tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
	}
}
