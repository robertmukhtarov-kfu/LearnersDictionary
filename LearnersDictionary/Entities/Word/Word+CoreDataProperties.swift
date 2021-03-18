//
//  Word+CoreDataProperties.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 01.03.2021.
//
//

import Foundation
import CoreData

extension Word {
	@nonobjc
	public class func fetchRequest() -> NSFetchRequest<Word> {
		return NSFetchRequest<Word>(entityName: "Word")
    }

    @NSManaged public var spelling: String
}
