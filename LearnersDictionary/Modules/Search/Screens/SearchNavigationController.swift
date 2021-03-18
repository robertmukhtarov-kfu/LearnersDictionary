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
		commonInit()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		commonInit()
	}

	// For iOS 11
	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		commonInit()
	}

	private func commonInit() {
		navigationBar.isTranslucent = false
		navigationBar.prefersLargeTitles = true
		tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
	}
}
