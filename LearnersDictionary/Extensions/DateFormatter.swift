//
//  DateFormatter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 04.05.2021.
//

import Foundation

extension DateFormatter {
	static var iso8601compact: DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		return dateFormatter
	}

	static var dMMMMyyyy: DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "d MMMM yyyy"
		return dateFormatter
	}

	static var EEEEdMMMM: DateFormatter {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "EEEE d MMMM"
		return dateFormatter
	}
}
