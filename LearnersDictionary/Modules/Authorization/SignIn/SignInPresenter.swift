//
//  SignInPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 17.05.2021.
//

import Foundation

class SignInPresenter {
	weak var view: SignInViewController?
	var coordinator: AuthorizationCoordinatorProtocol?

	private let userAuthenticationService = UserAuthenticationService()

	func signIn(email: String, password: String) {
		userAuthenticationService.signIn(email: email, password: password) { [weak self] result in
			switch result {
			case .success:
				self?.coordinator?.dismiss()
			case .failure(let error):
				print(error)
			}
		}
	}

	func signUpButtonTapped() {
		coordinator?.showSignUpView()
	}

	func cancelButtonTapped() {
		coordinator?.dismiss()
	}
}
