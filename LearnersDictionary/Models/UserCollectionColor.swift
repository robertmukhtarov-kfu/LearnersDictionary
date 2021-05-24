//
//  UserCollectionColor.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 11.05.2021.
//

import UIKit

@objc public enum UserCollectionColor: Int16, CaseIterable {
	case red
	case blue
	case green
	case yellow
	case orange
	case purple
	case pink

	func toUIColor() -> UIColor {
		switch self {
		case .red:
			return .systemRed
		case .blue:
			return .systemBlue
		case .green:
			return .systemGreen
		case .orange:
			return .systemOrange
		case .yellow:
			return .systemYellow
		case .purple:
			return .systemPurple
		case .pink:
			return .systemPink
		}
	}
}
