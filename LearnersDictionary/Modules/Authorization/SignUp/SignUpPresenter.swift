//
//  SignUpPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 17.05.2021.
//

import Foundation

class SignUpPresenter {
	weak var view: SignUpViewController?
	var coordinator: AuthorizationCoordinatorProtocol?

	private let userAuthenticationService = UserAuthenticationService()

	func createUser(email: String, password: String, firstName: String, lastName: String) {
		userAuthenticationService.signUp(
			email: email,
			password: password,
			firstName: firstName,
			lastName: lastName
		) { [weak self] result in
			switch result {
			case .success:
				self?.coordinator?.dismiss()
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}

	func signInButtonTapped() {
		coordinator?.goBackToSignIn()
	}

	func cancelButtonTapped() {
		coordinator?.dismiss()
	}
}
