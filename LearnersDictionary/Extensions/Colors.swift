//
//  Colors.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 10.03.2021.
//

import UIKit

extension UIColor {
	static var text: UIColor {
		if #available(iOS 13.0, *) {
			return label
		} else {
			return black
		}
	}

	static var background: UIColor {
		if #available(iOS 13.0, *) {
			return systemBackground
		} else {
			return white
		}
	}
}
