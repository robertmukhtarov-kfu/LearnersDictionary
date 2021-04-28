//
//  CollectionDetailViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 26.04.2021.
//

import UIKit

class CollectionDetailViewController: UIViewController, TrackedScrollViewProtocol {
	var presenter: CollectionDetailPresenter?
	let tableView = UITableView()
	weak var trackedScrollViewDelegate: TrackedScrollViewDelegate?

	override func viewDidLoad() {
		super.viewDidLoad()
		setupTableView()
	}

	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(CollectionDetailTableViewCell.self, forCellReuseIdentifier: "CollectionCell")

		view.addSubview(tableView)
		tableView.snp.makeConstraints { make in
			make.edges.equalTo(view)
		}
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
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell") else {
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
