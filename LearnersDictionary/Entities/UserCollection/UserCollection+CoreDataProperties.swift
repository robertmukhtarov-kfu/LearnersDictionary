//
//  UserCollection+CoreDataProperties.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 18.05.2021.
//
//

import Foundation
import CoreData

extension UserCollection {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<UserCollection> {
		return NSFetchRequest<UserCollection>(entityName: "UserCollection")
	}

	@NSManaged public var color: UserCollectionColor
	@NSManaged public var title: String
	@NSManaged public var words: NSOrderedSet
	@NSManaged public var user: User
}

// MARK: Generated accessors for words
extension UserCollection {
	@objc(insertObject:inWordsAtIndex:)
	@NSManaged public func insertIntoWords(_ value: Word, at idx: Int)

	@objc(removeObjectFromWordsAtIndex:)
	@NSManaged public func removeFromWords(at idx: Int)

	@objc(insertWords:atIndexes:)
	@NSManaged public func insertIntoWords(_ values: [Word], at indexes: NSIndexSet)

	@objc(removeWordsAtIndexes:)
	@NSManaged public func removeFromWords(at indexes: NSIndexSet)

	@objc(replaceObjectInWordsAtIndex:withObject:)
	@NSManaged public func replaceWords(at idx: Int, with value: Word)

	@objc(replaceWordsAtIndexes:withWords:)
	@NSManaged public func replaceWords(at indexes: NSIndexSet, with values: [Word])

	@objc(addWordsObject:)
	@NSManaged public func addToWords(_ value: Word)

	@objc(removeWordsObject:)
	@NSManaged public func removeFromWords(_ value: Word)

	@objc(addWords:)
	@NSManaged public func addToWords(_ values: NSOrderedSet)

	@objc(removeWords:)
	@NSManaged public func removeFromWords(_ values: NSOrderedSet)
}
