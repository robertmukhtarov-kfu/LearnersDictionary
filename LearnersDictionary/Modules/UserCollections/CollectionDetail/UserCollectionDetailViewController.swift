//
//  UserCollectionDetailViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 25.04.2021.
//

import UIKit

class UserCollectionDetailViewController: UIViewController, UserCollectionDetailViewProtocol {
	var presenter: UserCollectionDetailPresenterProtocol?

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

	private let tableView = UITableView()

	override func viewDidLoad() {
		super.viewDidLoad()
		setupToolbar()
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

	private func setupNavigationBarForAppearance() {
		title = presenter?.title
		navigationItem.largeTitleDisplayMode = .never
		let navigationBar = navigationController?.navigationBar
		navigationBar?.barTintColor = presenter?.color
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
		let deleteBarButton = UIBarButtonItem(title: "Delete Collection", style: .plain, target: self, action: nil)
		deleteBarButton.tintColor = .systemRed
		let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		toolbarItems = [flexibleSpace, deleteBarButton, flexibleSpace]
	}

	@objc private func editButtonPressed() {
		isEditingActive.toggle()
	}

	private func enableEditing() {
		navigationController?.setToolbarHidden(false, animated: true)
		tableView.setEditing(true, animated: true)
		editButton.title = "Done"
		editButton.style = .done
	}

	private func disableEditing() {
		navigationController?.setToolbarHidden(true, animated: true)
		tableView.setEditing(false, animated: true)
		editButton.title = "Edit"
		editButton.style = .plain
	}

	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.edges.equalTo(view)
		}
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CollectionWordCell")
	}

	func reloadData() {
		tableView.reloadData()
	}
}

extension UserCollectionDetailViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter?.wordCount ?? 0
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
