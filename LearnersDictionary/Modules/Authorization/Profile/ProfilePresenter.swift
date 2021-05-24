//
//  ProfilePresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 17.05.2021.
//

import Foundation

class ProfilePresenter {
	weak var view: ProfileViewController?
	var coordinator: AuthorizationCoordinator?

	private let userAuthenticationService = UserAuthenticationService()

	func viewDidLoad() {
		loadData()
	}

	func doneButtonTapped() {
		coordinator?.dismiss()
	}

	private func loadData() {
		userAuthenticationService.getUserInfo { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let userInfo):
				DispatchQueue.main.async {
					self.view?.set(email: userInfo.email)
					self.view?.set(name: "\(userInfo.firstName) \(userInfo.lastName)")
				}
			case .failure(let error):
				print(error)
			}
		}
	}

	func signOut() {
		userAuthenticationService.signOut { result in
			switch result {
			case .success:
				coordinator?.showSignInView()
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
	}
}
