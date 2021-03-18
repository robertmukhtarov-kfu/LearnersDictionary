//
//  MainTabBarController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 01.03.2021.
//

import UIKit

class MainTabBarController: UITabBarController {
	let searchCoordinator = SearchCoordinator()

	override func viewDidLoad() {
		super.viewDidLoad()
		viewControllers = [searchCoordinator.navigationController]
    }
}
