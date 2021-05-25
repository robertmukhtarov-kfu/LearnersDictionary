//
//  User+CoreDataProperties.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 18.05.2021.
//
//

import Foundation
import CoreData

extension User {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<User> {
		return NSFetchRequest<User>(entityName: "User")
	}

	@NSManaged public var lastModified: Date
	@NSManaged public var collections: NSOrderedSet
}

// MARK: Generated accessors for collections
extension User {
	@objc(insertObject:inCollectionsAtIndex:)
	@NSManaged public func insertIntoCollections(_ value: UserCollection, at idx: Int)

	@objc(removeObjectFromCollectionsAtIndex:)
	@NSManaged public func removeFromCollections(at idx: Int)

	@objc(insertCollections:atIndexes:)
	@NSManaged public func insertIntoCollections(_ values: [UserCollection], at indexes: NSIndexSet)

	@objc(removeCollectionsAtIndexes:)
	@NSManaged public func removeFromCollections(at indexes: NSIndexSet)

	@objc(replaceObjectInCollectionsAtIndex:withObject:)
	@NSManaged public func replaceCollections(at idx: Int, with value: UserCollection)

	@objc(replaceCollectionsAtIndexes:withCollections:)
	@NSManaged public func replaceCollections(at indexes: NSIndexSet, with values: [UserCollection])

	@objc(addCollectionsObject:)
	@NSManaged public func addToCollections(_ value: UserCollection)

	@objc(removeCollectionsObject:)
	@NSManaged public func removeFromCollections(_ value: UserCollection)

	@objc(addCollections:)
	@NSManaged public func addToCollections(_ values: NSOrderedSet)

	@objc(removeCollections:)
	@NSManaged public func removeFromCollections(_ values: NSOrderedSet)
}
