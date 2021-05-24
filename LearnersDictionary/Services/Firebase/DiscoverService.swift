//
//  DiscoverService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 04.05.2021.
//

import Foundation
import FirebaseDatabase

protocol DiscoverServiceProtocol {
	func wordOfTheDay(completion: @escaping (Result<WordOfTheDayModel, Error>) -> Void)
	func collections(completion: @escaping (Result<[DiscoverCollectionModel], Error>) -> Void)
}

class DiscoverService: DiscoverServiceProtocol {
	private enum Paths {
		static let wordOfTheDay = "wordOfTheDay"
		static let discoverCollections = "discoverCollections"
	}

	private lazy var dbReference = Database.database().reference()

	private let jsonDecoder: JSONDecoder = {
		let decoder = JSONDecoder()
		decoder.dateDecodingStrategy = .formatted(.iso8601compact)
		return decoder
	}()

	func wordOfTheDay(completion: @escaping (Result<WordOfTheDayModel, Error>) -> Void) {
		dbReference.child(Paths.wordOfTheDay).getData { error, snapshot in
			if let error = error {
				completion(.failure(error))
				return
			}
			do {
				let jsonData = try JSONSerialization.data(withJSONObject: snapshot.value as Any)
				let wordOfTheDay = try self.jsonDecoder.decode(WordOfTheDayModel.self, from: jsonData)
				completion(.success(wordOfTheDay))
			} catch let error {
				completion(.failure(error))
			}
		}
	}

	func collections(completion: @escaping (Result<[DiscoverCollectionModel], Error>) -> Void) {
		dbReference.child(Paths.discoverCollections).getData { error, snapshot in
			if let error = error {
				completion(.failure(error))
				return
			}
			do {
				let jsonData = try JSONSerialization.data(withJSONObject: snapshot.value as Any)
				let discoverCollections = try self.jsonDecoder.decode([DiscoverCollectionModel].self, from: jsonData)
				completion(.success(discoverCollections))
			} catch let error {
				completion(.failure(error))
			}
		}
	}
}
