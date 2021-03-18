//
//  EntryParserError.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 16.03.2021.
//

import Foundation

enum EntryParserError: Error {
	case notJSON
	case invalidEntries
	case invalidHeadword
	case invalidFunctionalLabels
	case invalidSenseSequence
	case invalidSenseSubsequence
	case invalidSense
	case invalidDefiningText
}

extension EntryParserError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .notJSON:
			return "The file is not a valid JSON."
		case .invalidEntries:
			return "Failed to parse the entries."
		case .invalidHeadword:
			return "Failed to parse the headword."
		case .invalidFunctionalLabels:
			return "Failed to parse the functional labels."
		case .invalidSenseSequence:
			return "Failed to parse the sense sequence."
		case .invalidSenseSubsequence:
			return "Failed to parse the sense subsequence."
		case .invalidSense:
			return "Failed to parse the senses."
		case .invalidDefiningText:
			return "Failed to parse the defining text."
		}
	}
}
