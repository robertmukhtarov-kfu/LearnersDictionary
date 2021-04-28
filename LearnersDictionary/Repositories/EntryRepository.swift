//
//  EntryRepository.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 06.04.2021.
//

import Foundation

protocol EntryRepositoryProtocol {
	func entries(for word: String, completion: @escaping (Result<[EntryModel], Error>) -> Void)
}

class EntryRepository: EntryRepositoryProtocol {
	private let entryDownloader = EntryNetworkService()
	private let entryParser = EntryParserService()

	func entries(for word: String, completion: @escaping (Result<[EntryModel], Error>) -> Void) {
		entryDownloader.loadEntries(for: word) { [weak self] result in
			switch result {
			case .success(let entriesData):
				self?.entryParser.parse(entriesData, for: word) { result in
					switch result {
					case .success(let parsedEntries):
						return completion(.success(parsedEntries))
					case .failure(let error):
						return completion(.failure(error))
					}
				}
			case .failure(let error):
				return completion(.failure(error))
			}
		}
	}
}
