//
//  EntryNetworkError.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 6.04.2021.
//

import Foundation

enum EntryNetworkError: Error {
	case entryLoadFailure
	case noData
	case invalidAudioFile
}

extension EntryNetworkError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .entryLoadFailure:
			return "Failed to load the entries. Please check your internet connection."
		case .noData:
			return "Couldn't obtain the data."
		case .invalidAudioFile:
			return "Couldn't obtain the pronunciation."
		}
	}
}
