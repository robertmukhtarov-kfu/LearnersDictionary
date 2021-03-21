//
//  UIViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 19.03.2021.
//

import UIKit

extension UIViewController {
	func showErrorAlert(message: String, completion: (() -> Void)? = nil) {
		let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
		let action = UIAlertAction(title: "OK", style: .default) { _ in
			completion?()
		}
		alertController.addAction(action)
		present(alertController, animated: true)
	}
}
