//
//  ProfileViewController.swift
//  tableviewexperiments
//
//  Created by Robert Mukhtarov on 16.05.2021.
//

import UIKit

class ProfileViewController: UIViewController {
	var presenter: ProfilePresenter?

	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.alignment = .center
		stackView.axis = .vertical
		stackView.spacing = 8
		return stackView
	}()

	private let nameLabel: UILabel = {
		let label = UILabel()
		label.font = .systemFont(ofSize: 28, weight: .bold)
		label.text = "Loading…"
		return label
	}()

	private let emailLabel: UILabel = {
		let label = UILabel()
		label.text = "Loading…"
		label.textColor = .systemGray
		return label
	}()

	private let signOutButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Sign Out", for: .normal)
		return button
	}()

	func set(name: String) {
		nameLabel.text = name
	}

	func set(email: String) {
		emailLabel.text = email
	}

    override func viewDidLoad() {
		super.viewDidLoad()

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			barButtonSystemItem: .done,
			target: self,
			action: #selector(doneButtonTapped)
		)
		signOutButton.addTarget(self, action: #selector(signOutButtonTapped), for: .touchUpInside)

		extendedLayoutIncludesOpaqueBars = true
		view.backgroundColor = .background
		view.addSubview(stackView)

		stackView.addArrangedSubview(nameLabel)
		stackView.addArrangedSubview(emailLabel)
		stackView.addArrangedSubview(signOutButton)

		stackView.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.width.equalToSuperview().inset(20)
		}

		presenter?.viewDidLoad()
    }

	@objc private func doneButtonTapped() {
		presenter?.doneButtonTapped()
	}

	@objc private func signOutButtonTapped() {
		presenter?.signOut()
	}
}
