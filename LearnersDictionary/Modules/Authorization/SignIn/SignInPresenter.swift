//
//  SignInPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 17.05.2021.
//

import Foundation

class SignInPresenter: SignInPresenterProtocol {
	weak var view: SignInViewProtocol?
	var coordinator: AuthorizationCoordinatorProtocol?

	private let userAuthenticationService = FirebaseUserAuthenticationService()
	private let userCollectionRepository = UserCollectionRepository()

	func signIn(email: String, password: String) {
		userAuthenticationService.signIn(email: email, password: password) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success:
				self.userCollectionRepository.loadCollectionsFromNetwork { result in
					DispatchQueue.main.async {
						switch result {
						case .success:
							self.coordinator?.dismiss()
						case .failure(let error):
							self.view?.showError(message: error.localizedDescription)
							self.userAuthenticationService.signOut { _ in
								self.coordinator?.dismiss()
							}
						}
					}
				}
			case .failure(let error):
				DispatchQueue.main.async {
					self.view?.showError(message: error.localizedDescription)
				}
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
