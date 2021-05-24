//
//  UserAuthenticationService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 19.05.2021.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

protocol UserAuthenticationServiceProtocol {
	func isAuthenticated() -> Bool
	func signIn(email: String, password: String, completion: @escaping (Result<(), Error>) -> Void)
	func signUp(email: String, password: String, firstName: String, lastName: String, completion: @escaping (Result<(), Error>) -> Void)
}

class UserAuthenticationService: UserAuthenticationServiceProtocol {
	private let usersRef = Database.database().reference().child("users")

	func isAuthenticated() -> Bool {
		return Auth.auth().currentUser != nil
	}

	func getUserInfo(completion: @escaping (Result<(firstName: String, lastName: String, email: String), Error>) -> Void) {
		guard let user = Auth.auth().currentUser else {
			return completion(.failure(UserAuthenticationError.noUser))
		}
		guard let email = user.email else {
			return completion(.failure(UserAuthenticationError.noEmail))
		}
		let userRef = usersRef.child(user.uid)
		userRef.getData { error, snapshot in
			if let error = error {
				return completion(.failure(error))
			}
			guard let userInfo = snapshot.value as? [String: String] else {
				return completion(.failure(UserAuthenticationError.invalidData))
			}
			guard
				let firstName = userInfo["firstName"],
				let lastName = userInfo["lastName"]
			else {
				return completion(.failure(UserAuthenticationError.invalidUserInfo))
			}
			completion(.success((firstName: firstName, lastName: lastName, email: email)))
		}
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
				completion(.failure(error))
			}
			guard let uid = result?.user.uid else {
				return completion(.failure(UserAuthenticationError.noUID))
			}
			self.usersRef.child(uid).setValue(["firstName": firstName, "lastName": lastName])
			completion(.success(()))
			return
		}
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
