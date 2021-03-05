//
//  SearchPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 05.03.2021.
//

import CoreData

protocol SearchView: AnyObject {
	func reloadData()
}

protocol SearchPresenter {
	var numberOfSections: Int { get }
	var indexTitles: [String] { get }
	func viewDidLoad()
	func getTitle(forCellAt indexPath: IndexPath) -> String
	func getNumberOfRows(in section: Int) -> Int
	func searchBarTextDidChange(text: String)
	func searchBarCancelTapped()
}

class SearchPresenterImplementation: SearchPresenter {
	weak var view: SearchView?
	var coordinator: SearchCoordinator?
	let context = CoreDataService().persistentContainer.viewContext

	var numberOfSections: Int
	var indexTitles: [String]

	private var wordlist: [[String]] = []
	private let indexToSectionMap =
		[
		"#": 0, "A": 1, "B": 2, "C": 3, "D": 4, "E": 5, "F": 6, "G": 7, "H": 8,
		"I": 9, "J": 10, "K": 11, "L": 12, "M": 13, "N": 14, "O": 15, "P": 16, "Q": 17,
		"R": 18, "S": 19, "T": 20, "U": 21, "V": 22, "W": 23, "X": 24, "Y": 25, "Z": 26
		]

	init() {
		numberOfSections = indexToSectionMap.count
		indexTitles = indexToSectionMap.keys.sorted()
		eraseWordlist()
	}

	func viewDidLoad() {
		setWordlistFull()
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

	private func setWordlist(fetchRequest: NSFetchRequest<Word>, indexOffset: Int) {
		eraseWordlist()
		let descriptor = NSSortDescriptor(
			key: "spelling",
			ascending: true,
			selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
		)
		fetchRequest.sortDescriptors = [descriptor]
		do {
			let words = try context.fetch(fetchRequest)
			let wordsStr = words.map { $0.spelling }
			wordsStr.forEach { addWord(word: $0, indexOffset: indexOffset) }
		} catch {
			print(error)
		}
		view?.reloadData()
	}

	private func setWordlistFull() {
		setWordlist(fetchRequest: Word.fetchRequest(), indexOffset: 0)
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

		let firstLetter = String(firstChar)
			.folding(options: [.diacriticInsensitive], locale: .init(identifier: "en"))
			.uppercased()
		guard let firstLetterIndex = indexToSectionMap[firstLetter] else { return }
		wordlist[firstLetterIndex].append(word)
	}

	func searchBarTextDidChange(text: String) {
		let prefix = text
		guard !prefix.isEmpty else {
			setWordlistFull()
			return
		}
		let predicate = NSPredicate(format: "spelling BEGINSWITH[cd] %@", prefix)
		let fetchRequest = Word.fetchRequest() as NSFetchRequest<Word>
		fetchRequest.predicate = predicate
		setWordlist(fetchRequest: fetchRequest, indexOffset: text.count)
	}

	func searchBarCancelTapped() {
		setWordlistFull()
	}
}
