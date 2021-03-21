//
//  EntryPageViewPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 16.03.2021.
//

import Foundation

protocol EntryPageView: AnyObject {
	func setTitle(_ title: String)
	func configure(with entries: [Entry])
	func showError(message: String)
}

protocol EntryPageViewPresenterProtocol {
	func viewDidLoad()
	func errorOccurred()
}

class EntryPageViewPresenter: EntryPageViewPresenterProtocol {
	var coordinator: SearchCoordinator?
	weak var view: EntryPageView?
	let word: String

	let entryDownloader = EntryNetworkService()
	let entryParser = EntryParserService()

	init(word: String) {
		self.word = word
	}

	func viewDidLoad() {
		view?.setTitle(word)
		downloadEntries()
	}

	func errorOccurred() {
		coordinator?.closeEntry()
	}

	private func downloadEntries() {
		EntryNetworkService().loadEntries(for: word) { result in
			switch result {
			case .success(let entriesData):
				self.parseEntries(from: entriesData)
			case .failure(let error):
				self.view?.showError(message: error.localizedDescription)
			}
		}
	}

	private func parseEntries(from data: Data?) {
		guard let data = data else { return }
		entryParser.parse(data, for: word) { result in
			switch result {
			case .success(let parsedEntries):
				self.view?.configure(with: parsedEntries)
			case .failure(let error):
				self.view?.showError(message: error.localizedDescription)
			}
		}
	}
}
