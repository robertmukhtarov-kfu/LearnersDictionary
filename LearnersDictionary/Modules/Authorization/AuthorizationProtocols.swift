//
//  AuthorizationProtocols.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 26.05.2021.
//

import Foundation

protocol SignInPresenterProtocol {
	func signIn(email: String, password: String)
	func signUpButtonTapped()
	func cancelButtonTapped()
}

protocol SignInViewProtocol: AnyObject {
	func showError(message: String)
}

protocol SignUpPresenterProtocol {
	func createUser(email: String, password: String, firstName: String, lastName: String)
	func signInButtonTapped()
	func cancelButtonTapped()
}

protocol SignUpViewProtocol: AnyObject {
	func showError(message: String)
}

protocol ProfilePresenterProtocol {
	func viewDidLoad()
	func doneButtonTapped()
	func signOut()
}

protocol ProfileViewProtocol: AnyObject {
	func set(name: String)
	func set(email: String)
	func showError(message: String)
}
