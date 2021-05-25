//
//  UserCollectionDetailViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 25.04.2021.
//

import UIKit

class UserCollectionDetailViewController: UIViewController, UserCollectionDetailViewProtocol {
	var presenter: UserCollectionDetailPresenterProtocol?
	private let settingsView = UserCollectionSettingsView()
	private let tableView = UITableView()

	lazy private var editButton = UIBarButtonItem(
		title: "Edit",
		style: .plain,
		target: self,
		action: #selector(editButtonPressed)
	)

	var isEditingActive: Bool = false {
		didSet {
			isEditingActive ? enableEditing() : disableEditing()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupToolbar()
		setupSettingsView()
		setupTableView()
		presenter?.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		setupNavigationBarForAppearance()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		setupNavigationBarForDisappearance()
	}

	func reloadData() {
		tableView.reloadData()
	}

	func showDeleteCollectionAlert() {
		let alert = UIAlertController(
			title: "Delete Collection",
			message: "Are you sure you want to delete this collection?",
			preferredStyle: .alert
		)
		alert.addAction(.init(title: "Yes", style: .default) { [weak self] _ in
			self?.presenter?.deleteCollection()
		})
		alert.addAction(.init(title: "No", style: .cancel))
		present(alert, animated: true)
	}

	private func setupNavigationBarForAppearance() {
		title = presenter?.title
		navigationItem.largeTitleDisplayMode = .never
		let navigationBar = navigationController?.navigationBar
		navigationBar?.barTintColor = presenter?.color.toUIColor()
		navigationBar?.tintColor = .white
		navigationBar?.titleTextAttributes = [
			.foregroundColor: UIColor.white,
			.font: UIFont.systemFont(ofSize: 18, weight: .bold)
		]
		navigationBar?.barStyle = .black
		navigationBar?.shadowImage = UIImage()
		navigationItem.rightBarButtonItem = editButton
	}

	private func setupNavigationBarForDisappearance() {
		let navigationBar = navigationController?.navigationBar
		navigationBar?.barTintColor = nil
		navigationBar?.tintColor = nil
		navigationBar?.titleTextAttributes = nil
		navigationBar?.barStyle = .default
		navigationBar?.shadowImage = nil
	}

	private func setupToolbar() {
		let deleteBarButton = UIBarButtonItem(
			title: "Delete Collection",
			style: .plain,
			target: self,
			action: #selector(deleteCollectionButtonPressed)
		)
		deleteBarButton.tintColor = .systemRed
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		toolbarItems = [flexibleSpace, deleteBarButton, flexibleSpace]
	}

	@objc private func editButtonPressed() {
		isEditingActive.toggle()
	}

	@objc private func deleteCollectionButtonPressed() {
		presenter?.deleteCollectionButtonPressed()
	}

	private func enableEditing() {
		navigationController?.setToolbarHidden(false, animated: true)
		tableView.setEditing(true, animated: true)
		editButton.title = "Done"
		editButton.style = .done
		showSettings()
	}

	private func disableEditing() {
		navigationController?.setToolbarHidden(true, animated: true)
		tableView.setEditing(false, animated: true)
		editButton.title = "Edit"
		editButton.style = .plain
		navigationItem.leftBarButtonItem = nil
		hideSettings()
	}

	private func showSettings() {
		settingsView.snp.updateConstraints { make in
			make.top.equalToSuperview()
		}
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}

	private func hideSettings() {
		settingsView.snp.updateConstraints { make in
			make.top.equalToSuperview().offset(-105)
		}
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}

	private func setupSettingsView() {
		settingsView.delegate = self
		view.addSubview(settingsView)
		settingsView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(-105)
			make.left.right.equalToSuperview()
			make.height.equalTo(105)
		}
		guard
			let title = presenter?.title,
			let color = presenter?.color
		else { return }
		settingsView.configure(title: title, color: color)
	}

	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.top.equalTo(settingsView.snp.bottom)
			make.left.right.bottom.equalTo(view)
		}
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CollectionWordCell")
	}
}

extension UserCollectionDetailViewController: UserCollectionSettingsViewDelegate {
	func didChangeTitle(to newTitle: String) {
		title = newTitle
		presenter?.changeTitle(to: newTitle)
	}

	func didSelectColor(_ color: UserCollectionColor) {
		self.navigationController?.navigationBar.barTintColor = color.toUIColor()
		UIView.animate(withDuration: 0.3) {
			self.navigationController?.navigationBar.layoutIfNeeded()
		}
		presenter?.changeColor(to: color)
	}
}

extension UserCollectionDetailViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.wordCount ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionWordCell", for: indexPath)
		cell.textLabel?.text = presenter?.getWord(forCellAt: indexPath)
		return cell
	}
}

extension UserCollectionDetailViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			presenter?.deleteWord(at: indexPath)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}

	func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		presenter?.moveWord(from: sourceIndexPath, to: destinationIndexPath)
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter?.didSelectWord(at: indexPath)
	}
}
