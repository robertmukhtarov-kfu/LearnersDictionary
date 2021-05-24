//
//  Word+CoreDataProperties.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 01.03.2021.
//
//

import CoreData

extension Word {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<Word> {
		return NSFetchRequest<Word>(entityName: "Word")
	}

	@NSManaged public var spelling: String
	@NSManaged public var userCollection: Set<UserCollection>?
}

// MARK: Generated accessors for userCollection
extension Word {
	@objc(addUserCollectionObject:)
	@NSManaged public func addToUserCollection(_ value: UserCollection)

	@objc(removeUserCollectionObject:)
	@NSManaged public func removeFromUserCollection(_ value: UserCollection)

	@objc(addUserCollection:)
	@NSManaged public func addToUserCollection(_ values: Set<UserCollection>)

	@objc(removeUserCollection:)
	@NSManaged public func removeFromUserCollection(_ values: Set<UserCollection>)
}
