//
//  CollectionDetailViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 26.04.2021.
//

import UIKit

class CollectionDetailViewController: UIViewController, CollectionDetailViewProtocol, TrackedScrollViewProtocol {
	var presenter: CollectionDetailPresenterProtocol?
	weak var trackedScrollViewDelegate: TrackedScrollViewDelegate?

	private let tableView = UITableView()

	private enum ReuseIdentifier {
		static let collectionCell = "CollectionCell"
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
	}

	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(CollectionDetailTableViewCell.self, forCellReuseIdentifier: ReuseIdentifier.collectionCell)

		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.edges.equalTo(view)
		}
	}

	func showError(message: String) {
		showErrorAlert(message: message)
	}

	func reloadData() {
		tableView.reloadData()
	}
}

extension CollectionDetailViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter?.wordCount ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifier.collectionCell) else {
			fatalError("Couldn't dequeue cell")
		}
		guard let word = presenter?.getWord(forCellAt: indexPath) else { fatalError("Couldn't get the word at \(indexPath)") }
		cell.textLabel?.text = word.title
		cell.detailTextLabel?.text = word.shortDefinition
		return cell
	}
}

extension CollectionDetailViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter?.didSelectWord(at: indexPath)
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let newOffset = scrollView.contentOffset.y
		trackedScrollViewDelegate?.didScroll(scrollView, to: newOffset)
	}
}
