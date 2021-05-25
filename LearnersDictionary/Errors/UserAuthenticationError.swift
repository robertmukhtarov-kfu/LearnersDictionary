//
//  UserAuthenticationError.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 19.05.2021.
//

import Foundation

enum UserAuthenticationError: Error {
	case noUser
	case signUpFailure
	case noEmail
	case noDisplayName
	case invalidData
	case invalidUserInfo
}

extension UserAuthenticationError: LocalizedError {
	var errorDescription: String? {
		switch self {
		case .noUser:
			return "Unauthorized request"
		case .signUpFailure:
			return "Failed to load sign up the user"
		case .noEmail:
			return "Failed to load the email information"
		case .noDisplayName:
			return "Failed to load the name"
		case .invalidData:
			return "Invalid data"
		case .invalidUserInfo:
			return "Failed to parse the user data"
		}
	}
}
