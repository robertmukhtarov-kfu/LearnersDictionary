//
//  FirebaseUserAuthenticationService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 19.05.2021.
//

import Foundation
import FirebaseAuth

protocol UserAuthenticationServiceProtocol {
	func isAuthenticated() -> Bool
	func signIn(email: String, password: String, completion: @escaping (Result<(), Error>) -> Void)
	func signUp(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Result<(), Error>) -> Void)
	func getUserInfo(completion: @escaping (Result<(displayName: String, email: String), Error>) -> Void)
	func signOut(completion: (Result<(), Error>) -> Void)
}

class FirebaseUserAuthenticationService: UserAuthenticationServiceProtocol {
	func isAuthenticated() -> Bool {
		Auth.auth().currentUser != nil
	}

	func signIn(email: String, password: String, completion: @escaping (Result<(), Error>) -> Void) {
		Auth.auth().signIn(withEmail: email, password: password) { _, error in
			if let error = error {
				completion(.failure(error))
				return
			}
			completion(.success(()))
			return
		}
	}

	func signUp(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Result<(), Error>) -> Void) {
		Auth.auth().createUser(withEmail: email, password: password) { result, error in
			if let error = error {
				return completion(.failure(error))
			}
			guard let user = result?.user else {
				return completion(.failure(UserAuthenticationError.signUpFailure))
			}

			let profileChangeRequest = user.createProfileChangeRequest()
			profileChangeRequest.displayName = "\(firstName) \(lastName)"
			profileChangeRequest.commitChanges { error in
				if let error = error {
					return completion(.failure(error))
				}
			}

			return completion(.success(()))
		}
	}

	func getUserInfo(completion: @escaping (Result<(displayName: String, email: String), Error>) -> Void) {
		guard let user = Auth.auth().currentUser else {
			return completion(.failure(UserAuthenticationError.noUser))
		}
		guard let email = user.email else {
			return completion(.failure(UserAuthenticationError.noEmail))
		}
		guard let displayName = user.displayName else {
			return completion(.failure(UserAuthenticationError.noDisplayName))
		}
		completion(.success((displayName: displayName, email: email)))
	}

	func signOut(completion: (Result<(), Error>) -> Void) {
		do {
			try Auth.auth().signOut()
			completion(.success(()))
		} catch let error {
			completion(.failure(error))
		}
	}
}
