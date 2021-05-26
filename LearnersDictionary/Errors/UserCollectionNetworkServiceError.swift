//
//  UserCollectionNetworkServiceError.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 26.05.2021.
//

import Foundation

enum UserCollectionNetworkServiceError: Error {
	case modificationDateLoadFailure
	case collectionsLoadFailure
	case collectionsParsingFailure
}

extension UserCollectionNetworkServiceError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .modificationDateLoadFailure:
			return "Failed to load modification date"
		case .collectionsLoadFailure:
			return "Failed to load collections"
		case .collectionsParsingFailure:
			return "Collection data is invalid"
		}
	}
}
