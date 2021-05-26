//
//  ProfilePresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 17.05.2021.
//

import Foundation

class ProfilePresenter: ProfilePresenterProtocol {
	weak var view: ProfileViewProtocol?
	var coordinator: AuthorizationCoordinator?

	private let userAuthenticationService = FirebaseUserAuthenticationService()

	func viewDidLoad() {
		loadData()
	}

	func doneButtonTapped() {
		coordinator?.dismiss()
	}

	func signOut() {
		userAuthenticationService.signOut { result in
			switch result {
			case .success:
				coordinator?.showSignInView()
			case .failure(let error):
				view?.showError(message: error.localizedDescription)
			}
		}
	}

	private func loadData() {
		userAuthenticationService.getUserInfo { [weak self] result in
			guard let self = self else { return }
			DispatchQueue.main.async {
				switch result {
				case .success(let userInfo):
					self.view?.set(email: userInfo.email)
					self.view?.set(name: userInfo.displayName)
				case .failure(let error):
					self.view?.showError(message: error.localizedDescription)
				}
			}
		}
	}
}
