//
//  MockUserCollectionService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 23.04.2021.
//

import Foundation

protocol UserCollectionServiceProtocol {
	func collections(completion: @escaping (Result<[UserCollectionModel], Error>) -> Void)
}

// swiftlint:disable all
class MockUserCollectionService: UserCollectionServiceProtocol {
	private let userCollections = [
		UserCollectionModel(title: "Weather", words: ["sunny", "cloudy", "rainy"], color: .systemRed),
		UserCollectionModel(title: "Technology", words: ["computer", "monitor", "keyboard", "connect", "network", "boot", "download", "upgrade", "innovation", "development", "breakthrough", "state-of-the-art", "software", "hardware"], color: .systemBlue),
		UserCollectionModel(title: "Clothes", words: [], color: .systemGreen),
		UserCollectionModel(title: "School", words: [], color: .systemPurple),
		UserCollectionModel(title: "Holidays", words: [], color: .systemOrange),
		UserCollectionModel(title: "Food", words: [], color: .systemYellow),
		UserCollectionModel(title: "Animals", words: [], color: .systemPink)
	]

	func collections(completion: @escaping (Result<[UserCollectionModel], Error>) -> Void) {
		completion(.success(userCollections))
	}
}
