//
//  WordlistPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 05.03.2021.
//

import Foundation

protocol WordlistView: AnyObject {
	func reloadData()
	func showError(message: String)
}

protocol WordlistPresenterProtocol {
	var numberOfSections: Int { get }
	var indexTitles: [String] { get }
	func viewDidLoad()
	func getTitle(forCellAt indexPath: IndexPath) -> String
	func getNumberOfRows(in section: Int) -> Int
	func searchBarTextDidChange(text: String)
	func searchBarCancelTapped()
	func didSelectWord(at indexPath: IndexPath)
}

class WordlistPresenter: WordlistPresenterProtocol {
	weak var view: WordlistView?
	var coordinator: SearchCoordinator?
	let coreDataService = CoreDataService()

	var numberOfSections: Int {
		indexToSectionMap.count
	}
	var indexTitles: [String] {
		indexToSectionMap.keys.sorted()
	}

	private var wordlist: [[String]] = []
	private let indexToSectionMap = Dictionary(
		uniqueKeysWithValues: "#ABCDEFGHIJKLMNOPQRSTUVWXYZ".enumerated().map {
			(String($1), $0)
		}
	)

	init() {
		eraseWordlist()
	}

	func viewDidLoad() {
		setupWordlist()
		view?.reloadData()
	}

	func getNumberOfRows(in section: Int) -> Int {
		wordlist[section].count
	}

	func getTitle(forCellAt indexPath: IndexPath) -> String {
		wordlist[indexPath.section][indexPath.row]
	}

	private func eraseWordlist() {
		wordlist = [[String]](repeating: [], count: numberOfSections)
	}

	private func setupWordlist(predicate: NSPredicate? = nil, indexOffset: Int = 0) {
		eraseWordlist()
		let descriptor = NSSortDescriptor(
			key: "spelling",
			ascending: true,
			selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
		)
		let sortDescriptors = [descriptor]
		coreDataService.fetchWordlist(predicate: predicate, sortDescriptors: sortDescriptors) { result in
			switch result {
			case .success(let words):
				let wordsStr = words.map { $0.spelling }
				wordsStr.forEach { self.add(word: $0, indexOffset: indexOffset) }
				self.view?.reloadData()
			case .failure:
				self.view?.showError(message: "Failed to load the wordlist.")
			}
		}
	}

	private func add(word: String, indexOffset: Int) {
		guard word.count - 1 >= indexOffset else {
			wordlist[0].append(word)
			return
		}

		let firstChar = word[word.index(word.startIndex, offsetBy: indexOffset)]
		guard firstChar.isLetter else {
			wordlist[0].append(word)
			return
		}

		let firstLetter = String(firstChar)
			.folding(options: [.diacriticInsensitive], locale: .init(identifier: "en"))
			.uppercased()
		guard let firstLetterIndex = indexToSectionMap[firstLetter] else { return }
		wordlist[firstLetterIndex].append(word)
	}

	func didSelectWord(at indexPath: IndexPath) {
		let word = wordlist[indexPath.section][indexPath.row]
		coordinator?.showEntry(for: word)
	}

	func searchBarTextDidChange(text: String) {
		let prefix = text
		guard !prefix.isEmpty else {
			setupWordlist()
			return
		}
		let predicate = NSPredicate(format: "spelling BEGINSWITH[cd] %@", prefix)
		setupWordlist(predicate: predicate, indexOffset: text.count)
	}

	func searchBarCancelTapped() {
		setupWordlist()
	}
}
