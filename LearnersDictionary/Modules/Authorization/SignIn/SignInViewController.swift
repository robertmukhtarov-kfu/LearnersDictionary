//
//  SignInViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 17.05.2021.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController {
	var presenter: SignInPresenter?

	private let infoStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .fill
		stackView.spacing = 10
		return stackView
	}()

	private let actionStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.alignment = .center
		stackView.spacing = 10
		return stackView
	}()

	private let doNotHaveAccountStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.spacing = 5
		return stackView
	}()

	private let titleLabel = AuthorizationTitleLabelView(text: "Sign In")
	private let emailTextField = AuthorizationTextField(placeholder: "Email", returnKeyType: .next)
	private let passwordTextField = AuthorizationTextField(placeholder: "Password", returnKeyType: .done)

	private let doNotHaveAccountLabel: UILabel = {
		let label = UILabel()
		label.text = "Don't have an account?"
		return label
	}()
	private let signUpButton: UIButton = {
		let button = UIButton(type: .system)
		button.titleLabel?.font = .preferredFont(forTextStyle: .body)
		button.setTitle("Sign Up", for: .normal)
		return button
	}()
	private let signInButton = AuthorizationButton(title: "Sign In")

	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
	}

	private func setup() {
		extendedLayoutIncludesOpaqueBars = true

		view.backgroundColor = .background
		view.addSubview(infoStackView)
		view.addSubview(actionStackView)

		emailTextField.delegate = self
		passwordTextField.delegate = self

		infoStackView.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.width.equalToSuperview().inset(30)
		}
		passwordTextField.isSecureTextEntry = true
		infoStackView.addArrangedSubview(titleLabel)
		infoStackView.addArrangedSubview(emailTextField)
		infoStackView.addArrangedSubview(passwordTextField)

		actionStackView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().inset(40)
			make.width.equalToSuperview().inset(30)
		}
		doNotHaveAccountStackView.addArrangedSubview(doNotHaveAccountLabel)
		doNotHaveAccountStackView.addArrangedSubview(signUpButton)
		actionStackView.addArrangedSubview(signInButton)
		actionStackView.addArrangedSubview(doNotHaveAccountStackView)

		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillShow),
			name: UIResponder.keyboardWillShowNotification,
			object: nil
		)
		NotificationCenter.default.addObserver(
			self,
			selector: #selector(keyboardWillHide),
			name: UIResponder.keyboardWillHideNotification,
			object: nil
		)

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .cancel,
			target: self,
			action: #selector(cancelButtonTapped)
		)

		signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
		signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
	}

	@objc private func signInButtonTapped() {
		guard
			let email = emailTextField.text,
			let password = passwordTextField.text
		else {
			return
		}
		presenter?.signIn(email: email, password: password)
	}

	@objc private func signUpButtonTapped() {
		presenter?.signUpButtonTapped()
	}

	@objc private func cancelButtonTapped() {
		presenter?.cancelButtonTapped()
	}

	@objc private func keyboardWillShow(notification: NSNotification) {
		if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
			let infoStackViewMaxY = infoStackView.frame.maxY
			if infoStackViewMaxY > keyboardSize.minY {
				infoStackView.snp.updateConstraints { make in
					make.centerY.equalToSuperview().offset(keyboardSize.minY - infoStackViewMaxY - 10)
				}
				UIView.animate(withDuration: 0.2) {
					self.view.layoutIfNeeded()
				}
			}
		}
	}

	@objc private func keyboardWillHide(notification: NSNotification) {
		infoStackView.snp.updateConstraints { make in
			make.centerY.equalToSuperview()
		}
		UIView.animate(withDuration: 0.2) {
			self.view.layoutIfNeeded()
		}
	}
}

extension SignInViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if textField == emailTextField {
			passwordTextField.becomeFirstResponder()
		} else {
			textField.resignFirstResponder()
		}
		return true
	}
}
