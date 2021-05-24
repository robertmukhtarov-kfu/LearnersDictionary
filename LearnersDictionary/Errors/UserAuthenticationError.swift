//
//  UserAuthenticationError.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 19.05.2021.
//

import Foundation

enum UserAuthenticationError: Error {
	case noUser
	case noUID
	case noEmail
	case invalidData
	case invalidUserInfo
}

extension UserAuthenticationError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .noUser:
			return "Unauthorized request"
		case .noUID:
			return "Failed to load UID"
		case .noEmail:
			return "Failed to load the email information"
		case .invalidData:
			return "Invalid data"
		case .invalidUserInfo:
			return "Failed to parse the user data"
		}
	}
}
