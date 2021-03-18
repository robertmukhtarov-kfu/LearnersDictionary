//
//  WordlistPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 05.03.2021.
//

import CoreData

protocol WordlistView: AnyObject {
	func reloadData()
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
	let context = CoreDataService().persistentContainer.viewContext

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
			wordsStr.forEach { add(word: $0, indexOffset: indexOffset) }
		} catch {
			print(error)
		}
		view?.reloadData()
	}

	private func setWordlistFull() {
		setWordlist(fetchRequest: Word.fetchRequest(), indexOffset: 0)
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
