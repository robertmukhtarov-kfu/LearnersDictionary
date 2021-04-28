//
//  UIApplication.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 18.04.2021.
//

import UIKit

extension UIApplication {
	static var statusBarHeight: CGFloat {
		if #available(iOS 13.0, *) {
			let window = shared.windows.first { $0.isKeyWindow }
			return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
		}
		return shared.statusBarFrame.height
	}
}
