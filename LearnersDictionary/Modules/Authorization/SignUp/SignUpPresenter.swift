//
//  SignUpPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 17.05.2021.
//

import Foundation

class SignUpPresenter: SignUpPresenterProtocol {
	weak var view: SignUpViewProtocol?
	var coordinator: AuthorizationCoordinatorProtocol?

	private let userAuthenticationService = FirebaseUserAuthenticationService()
	private let userCollectionRepository = UserCollectionRepository()

	func createUser(email: String, password: String, firstName: String, lastName: String) {
		userAuthenticationService.signUp(
			email: email,
			password: password,
			firstName: firstName,
			lastName: lastName
		) { [weak self] result in
			DispatchQueue.main.async { [weak self] in
				switch result {
				case .success:
					self?.coordinator?.dismiss()
					self?.userCollectionRepository.save()
				case .failure(let error):
					self?.view?.showError(message: error.localizedDescription)
				}
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
