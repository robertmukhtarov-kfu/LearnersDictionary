//
//  NSAttributedString.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 16.03.2021.
//

import UIKit

extension NSAttributedString {
	static var newLine: NSAttributedString {
		NSAttributedString(string: "\n")
	}

	static func headword(string: String) -> NSAttributedString {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.paragraphSpacing = 8
		let headword = NSMutableAttributedString(string: string, attributes: [
			.font: UIFont.boldSystemFont(ofSize: 20),
			.foregroundColor: UIColor.text,
			.paragraphStyle: paragraphStyle
		])
		headword.append(.newLine)
		return headword
	}

	static func transcription(string: String) -> NSAttributedString {
		let paragraphStyle = NSMutableParagraphStyle()
		paragraphStyle.paragraphSpacing = 8
		let transcription = NSMutableAttributedString(string: "/\(string)/", attributes: [
			.font: UIFont.preferredFont(forTextStyle: .body),
			.foregroundColor: UIColor.text,
			.paragraphStyle: paragraphStyle
		])
		transcription.append(.newLine)
		return transcription
	}

	// TODO: Rewrite the method, fix indentation
	static func sense(index: Int, number: String?, definingText: String) -> NSAttributedString {
		let senseString = NSMutableAttributedString()
		let senseNumber = number ?? "1"
		let attributedNumber = NSAttributedString(
			string: senseNumber,
			attributes: [.font: UIFont.boldSystemFont(ofSize: 18)])

		let attributedDefiningText = NSAttributedString(
			string: definingText,
			attributes: [.font: UIFont.preferredFont(forTextStyle: .body)])

		senseString.append(attributedNumber)
		senseString.append(NSAttributedString(string: "  "))
		senseString.append(attributedDefiningText)
		senseString.append(.newLine)

		let paragraphStyle = NSMutableParagraphStyle()
		if index > 0 {
			paragraphStyle.firstLineHeadIndent = 12
		}
		paragraphStyle.headIndent = 29

		senseString.addAttribute(
			.paragraphStyle,
			value: paragraphStyle,
			range: NSRange(location: 0, length: senseString.length)
		)
		return senseString
	}
}
