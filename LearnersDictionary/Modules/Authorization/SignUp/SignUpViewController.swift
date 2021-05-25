//
//  SignUpViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 17.05.2021.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {
	var presenter: SignUpPresenter?

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

	private let alreadyHaveAccountStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .horizontal
		stackView.alignment = .center
		stackView.spacing = 5
		return stackView
	}()

	private let titleLabel = AuthorizationTitleLabelView(text: "Sign Up")
	private let emailTextField = AuthorizationTextField(placeholder: "Email", returnKeyType: .next)
	private let passwordTextField = AuthorizationTextField(placeholder: "Password", returnKeyType: .next)
	private let firstNameTextField = AuthorizationTextField(placeholder: "First Name", returnKeyType: .next)
	private let lastNameTextField = AuthorizationTextField(placeholder: "Last Name", returnKeyType: .done)

	private let alreadyHaveAccountLabel: UILabel = {
		let label = UILabel()
		label.text = "Already have account?"
		return label
	}()
	private let signInButton: UIButton = {
		let button = UIButton(type: .system)
		button.titleLabel?.font = .preferredFont(forTextStyle: .body)
		button.setTitle("Sign In", for: .normal)
		return button
	}()
	private let signUpButton = AuthorizationButton(title: "Sign Up")

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
		firstNameTextField.delegate = self
		firstNameTextField.autocapitalizationType = .sentences
		lastNameTextField.delegate = self
		lastNameTextField.autocapitalizationType = .sentences

		infoStackView.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.width.equalToSuperview().inset(30)
		}
		passwordTextField.isSecureTextEntry = true
		infoStackView.addArrangedSubview(titleLabel)
		infoStackView.addArrangedSubview(emailTextField)
		infoStackView.addArrangedSubview(passwordTextField)
		infoStackView.addArrangedSubview(firstNameTextField)
		infoStackView.addArrangedSubview(lastNameTextField)

		actionStackView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().inset(40)
			make.width.equalToSuperview().inset(30)
		}
		alreadyHaveAccountStackView.addArrangedSubview(alreadyHaveAccountLabel)
		alreadyHaveAccountStackView.addArrangedSubview(signInButton)
		actionStackView.addArrangedSubview(signUpButton)
		actionStackView.addArrangedSubview(alreadyHaveAccountStackView)

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

		signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
		signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
	}

	@objc private func signUpButtonTapped() {
		guard
			let email = emailTextField.text,
			let password = passwordTextField.text,
			let firstName = firstNameTextField.text,
			let lastName = lastNameTextField.text
		else {
			return
		}
		presenter?.createUser(email: email, password: password, firstName: firstName, lastName: lastName)
	}

	@objc private func signInButtonTapped() {
		presenter?.signInButtonTapped()
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

extension SignUpViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case emailTextField:
			passwordTextField.becomeFirstResponder()
		case passwordTextField:
			firstNameTextField.becomeFirstResponder()
		case firstNameTextField:
			lastNameTextField.becomeFirstResponder()
		default:
			textField.resignFirstResponder()
		}
		return true
	}
}
