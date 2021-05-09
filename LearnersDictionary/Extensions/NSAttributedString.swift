//
//  NSAttributedString.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 16.03.2021.
//

import UIKit

extension Dictionary where Key == NSAttributedString.Key, Value == Any {
	static let headword: Self = [
		.font: UIFont.boldSystemFont(ofSize: 20),
		.foregroundColor: UIColor.text
	]
	static let senseNumber: Self = [
		.font: UIFont.boldSystemFont(ofSize: 18),
		.foregroundColor: UIColor.text
	]
	static let body: Self = [
		.font: UIFont.preferredFont(forTextStyle: .body),
		.foregroundColor: UIColor.text
	]
	static let statusLabel: Self = [
		.font: UIFont.italicSystemFont(ofSize: 16),
		.foregroundColor: UIColor.darkGray
	]
	static let grammaticalLabel: Self = [
		.font: UIFont.preferredFont(forTextStyle: .body),
		.foregroundColor: UIColor.systemGray
	]
}

extension NSAttributedString {
	static var newLine: NSAttributedString {
		NSAttributedString(string: "\n")
	}
}
