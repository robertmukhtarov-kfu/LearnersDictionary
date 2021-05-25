//
//  AuthorizationCoordinator.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 17.05.2021.
//

import UIKit

protocol AuthorizationCoordinatorProtocol {
	func showSignInView()
	func showSignUpView()
	func goBackToSignIn()
	func showProfileView()
	func dismiss()
}

class AuthorizationCoordinator: AuthorizationCoordinatorProtocol {
	let navigationController: UINavigationController
	private let userAuthenticationService = FirebaseUserAuthenticationService()

	init(navigationController: UINavigationController = UINavigationController()) {
		self.navigationController = navigationController
		setupNavigationBar()
		if userAuthenticationService.isAuthenticated() {
			showProfileView()
		} else {
			showSignInView()
		}
	}

	func showSignInView() {
		let signInPresenter = SignInPresenter()
		let signInVC = SignInViewController()
		signInPresenter.coordinator = self
		signInPresenter.view = signInVC
		signInVC.presenter = signInPresenter
		navigationController.setViewControllers([signInVC], animated: true)
	}

	func showSignUpView() {
		let signUpPresenter = SignUpPresenter()
		let signUpVC = SignUpViewController()
		signUpPresenter.coordinator = self
		signUpPresenter.view = signUpVC
		signUpVC.presenter = signUpPresenter
		navigationController.pushViewController(signUpVC, animated: true)
	}

	func showProfileView() {
		let profilePresenter = ProfilePresenter()
		let profileVC = ProfileViewController()
		profilePresenter.coordinator = self
		profilePresenter.view = profileVC
		profileVC.presenter = profilePresenter
		navigationController.setViewControllers([profileVC], animated: true)
	}

	func goBackToSignIn() {
		navigationController.popViewController(animated: true)
	}

	func dismiss() {
		navigationController.dismiss(animated: true)
	}

	private func setupNavigationBar() {
		navigationController.navigationBar.isTranslucent = false
		navigationController.navigationBar.prefersLargeTitles = false
		navigationController.navigationBar.shadowImage = UIImage()
	}
}
