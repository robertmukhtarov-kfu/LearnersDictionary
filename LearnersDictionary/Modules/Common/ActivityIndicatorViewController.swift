//
//  ActivityIndicatorViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 09.05.2021.
//

import UIKit

class ActivityIndicatorViewController: UIViewController {
	private let activityIndicator = UIActivityIndicatorView(style: .gray)

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .background
		activityIndicator.startAnimating()
		view.addSubview(activityIndicator)
		activityIndicator.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
	}
}
