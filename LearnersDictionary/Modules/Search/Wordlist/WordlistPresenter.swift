//
//  WordlistPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 05.03.2021.
//

import UIKit

class WordlistPresenter: WordlistPresenterProtocol {
	weak var view: WordlistViewProtocol?
	weak var coordinator: SearchCoordinator?
	private let wordRepository = WordRepository()

	var numberOfSections: Int {
		indexToSectionMap.count
	}
	var indexTitles: [String] {
		indexToSectionMap.keys.sorted()
	}

	private var wordlist: [[Word]] = []
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
		wordlist[indexPath.section][indexPath.row].spelling
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

	func cameraButtonTapped() {
		view?.showImagePickerAlert()
	}

	func showImagePicker(pickerSourceType: UIImagePickerController.SourceType) {
		coordinator?.showImagePicker(pickerSourceType: pickerSourceType)
	}

	// MARK: - Private methods

	private func eraseWordlist() {
		wordlist = [[Word]](repeating: [], count: numberOfSections)
	}

	private func setupWordlist(predicate: NSPredicate? = nil, indexOffset: Int = 0) {
		eraseWordlist()
		let descriptor = NSSortDescriptor(
			key: "spelling",
			ascending: true,
			selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
		)
		let sortDescriptors = [descriptor]
		wordRepository.fetchWordlist(predicate: predicate, sortDescriptors: sortDescriptors) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let words):
				words.forEach { self.add(word: $0, indexOffset: indexOffset) }
				self.view?.reloadData()
			case .failure:
				self.view?.showError(message: "Failed to load the wordlist.")
			}
		}
	}

	private func add(word: Word, indexOffset: Int) {
		let wordStr = word.spelling
		guard wordStr.count - 1 >= indexOffset else {
			wordlist[0].append(word)
			return
		}

		let firstChar = wordStr[wordStr.index(wordStr.startIndex, offsetBy: indexOffset)]
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
}
