//
//  SearchViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 01.03.2021.
//

import UIKit
import SnapKit
import CoreData

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
	var coordinator: SearchCoordinator?
	let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
		super.viewDidLoad()
		title = "Search"
		setupTableView()
		setupSearchController()
		setWordlistFull()
    }

    // MARK: - UITableView

    private var tableView = UITableView()
	// swiftlint:disable:next line_length
    private let indexToSectionMap = ["#": 0, "A": 1, "B": 2, "C": 3, "D": 4, "E": 5, "F": 6, "G": 7, "H": 8, "I": 9, "J": 10, "K": 11, "L": 12, "M": 13, "N": 14, "O": 15, "P": 16, "Q": 17, "R": 18, "S": 19, "T": 20, "U": 21, "V": 22, "W": 23, "X": 24, "Y": 25, "Z": 26]
    private var wordlist: [[String]] = []

    private func setupTableView() {
		view.addSubview(tableView)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.snp.makeConstraints { make in
			make.edges.equalTo(view)
		}
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    private func eraseWordlist() {
		wordlist = [[String]](repeating: [], count: indexToSectionMap.count)
    }

    private func setWordlistFull() {
		setWordlist(fetchRequest: Word.fetchRequest(), indexOffset: 0)
    }

    private func setWordlist(fetchRequest: NSFetchRequest<Word>, indexOffset: Int) {
		eraseWordlist()
		let descriptor = NSSortDescriptor(key: "spelling", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
		fetchRequest.sortDescriptors = [descriptor]
		do {
			let words = try context.fetch(fetchRequest)
			let wordsStr = words.map { $0.spelling }
			wordsStr.forEach { addWord(word: $0, indexOffset: indexOffset) }
		} catch {
			print(error)
		}
		tableView.reloadData()
    }

    private func addWord(word: String, indexOffset: Int) {
		guard word.count - 1 >= indexOffset else {
			wordlist[0].append(word)
			return
        }

		let firstChar = word[word.index(word.startIndex, offsetBy: indexOffset)]
		guard firstChar.isLetter else {
			wordlist[0].append(word)
			return
        }

		let firstLetter = String(firstChar).folding(options: [.diacriticInsensitive], locale: .init(identifier: "en")).uppercased()
		guard let firstLetterIndex = indexToSectionMap[firstLetter] else { return }
		wordlist[firstLetterIndex].append(word)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		wordlist[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = wordlist[indexPath.section][indexPath.row]
		return cell
    }

    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		indexToSectionMap.first { $0.value == section }?.key
	}
	*/

    func numberOfSections(in tableView: UITableView) -> Int {
		indexToSectionMap.count
    }

    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		indexToSectionMap.keys.sorted()
    }

    // MARK: - UISearchController

    private var searchController = UISearchController(searchResultsController: nil)

    private func setupSearchController() {
		searchController.obscuresBackgroundDuringPresentation = false
		let searchBar = searchController.searchBar
		searchBar.delegate = self
		searchBar.placeholder = "Type a word"
		searchBar.setImage(UIImage(named: "mic.fill"), for: .bookmark, state: .normal)
		searchBar.showsBookmarkButton = true
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		let prefix = searchText
		guard !prefix.isEmpty else {
			setWordlistFull()
			return
        }
        let predicate = NSPredicate(format: "spelling BEGINSWITH[cd] %@", prefix)
        let fetchRequest = Word.fetchRequest() as NSFetchRequest<Word>
        fetchRequest.predicate = predicate
        setWordlist(fetchRequest: fetchRequest, indexOffset: searchText.count)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text else { return }
		if !text.isEmpty { setWordlistFull() }
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
		// TODO: Voice Recognition
    }
}
