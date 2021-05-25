//
//  FirebaseUserCollectionNetworkService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 25.05.2021.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

protocol UserCollectionNetworkServiceProtocol {
	func saveCollections(_ collections: [UserCollection], modificationDate: Date)
}

class FirebaseUserCollectionNetworkService: UserCollectionNetworkServiceProtocol {
	private lazy var usersRef = Database.database().reference().child("users")

	public func saveCollections(_ collections: [UserCollection], modificationDate: Date) {
		guard let user = Auth.auth().currentUser else { return }
		let userRef = usersRef.child(user.uid)
		let collectionsRef = userRef.child("collections")
		let lastModifiedRef = userRef.child("lastModified")

		collectionsRef.setValue(collections.toDictionaryArray())
		lastModifiedRef.setValue(Int(modificationDate.timeIntervalSince1970))
	}
}

extension UserCollection {
	func toDictionary() -> [String: Any] {
		var dictionary: [String: Any] = [:]
		dictionary["color"] = color.rawValue
		dictionary["title"] = title

		guard let wordsArray = words.array as? [Word] else {
			return dictionary
		}
		dictionary["words"] = wordsArray.map(\.spelling)

		return dictionary
	}
}

extension Array where Element == UserCollection {
	func toDictionaryArray() -> [[String: Any]] {
		return map { $0.toDictionary() }
	}
}
