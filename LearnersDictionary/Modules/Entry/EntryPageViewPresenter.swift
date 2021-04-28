//
//  EntryPageViewPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 16.03.2021.
//

import Foundation

class EntryPageViewPresenter: EntryPageViewPresenterProtocol {
	weak var coordinator: SearchCoordinator?
	weak var view: EntryPageView?
	var word: String

	let entryRepository = EntryRepository()

	init(word: String) {
		self.word = word
	}

	func viewDidLoad() {
		set(word: word)
	}

	func set(word: String) {
		self.word = word
		view?.reset()
		view?.set(title: word)
		showEntries()
	}

	func errorOccurred() {
		coordinator?.closeEntry()
	}

	private func showEntries() {
		entryRepository.entries(for: word) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let parsedEntries):
				self.view?.configure(with: parsedEntries)
			case .failure(let error):
				self.view?.showError(message: error.localizedDescription)
			}
		}
	}
}
