//
//  SearchViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 01.03.2021.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController, SearchView {
	var presenter: SearchPresenter?
	private var tableView = UITableView()
	private var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
		super.viewDidLoad()
		title = "Search"
		setupTableView()
		setupSearchController()
		presenter?.viewDidLoad()
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
	private func setupTableView() {
		view.addSubview(tableView)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.snp.makeConstraints { make in
			make.edges.equalTo(view)
		}
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.getNumberOfRows(in: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = presenter?.getTitle(forCellAt: indexPath)
		return cell
    }

	func reloadData() {
		tableView.reloadData()
	}

    func numberOfSections(in tableView: UITableView) -> Int {
		presenter?.numberOfSections ?? 0
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		presenter?.indexTitles ?? []
    }
}

extension SearchViewController: UISearchBarDelegate {
	private func setupSearchController() {
		searchController.obscuresBackgroundDuringPresentation = false
		let searchBar = searchController.searchBar
		searchBar.delegate = self
		searchBar.placeholder = "Type a word"
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
	}

	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		presenter?.searchBarTextDidChange(text: searchText)
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text else { return }
		if !text.isEmpty { presenter?.searchBarCancelTapped() }
	}
}
