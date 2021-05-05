//
//  DiscoverCollectionModel.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 23.04.2021.
//

import UIKit

struct DiscoverCollectionModel: Codable {
	let title: String
	let date: Date
	let imageURL: String
	let words: [DiscoverWordModel]
}
