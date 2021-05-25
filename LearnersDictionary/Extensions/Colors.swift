//
//  Colors.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 10.03.2021.
//

import UIKit

extension UIColor {
	static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
		guard #available(iOS 13.0, *) else { return light }
		return UIColor { $0.userInterfaceStyle == .dark ? dark : light }
	}

	static var text: UIColor {
		guard #available(iOS 13.0, *) else { return black }
		return label
	}

	static var xMarkColor: UIColor {
		guard #available(iOS 13.0, *) else { return white }
		return label
	}

	static var background: UIColor {
		guard #available(iOS 13.0, *) else { return white }
		return systemBackground
	}

	static var navigationBarShadow: UIColor {
		dynamicColor(
			light: UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0),
			dark: UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
		)
	}

	static var divider: UIColor {
		dynamicColor(
			light: UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0),
			dark: UIColor(red: 0.20, green: 0.20, blue: 0.21, alpha: 1.0)
		)
	}
}
