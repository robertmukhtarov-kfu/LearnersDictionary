//
//  Entry.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 07.03.2021.
//

import Foundation

struct Entry {
	let headword: String
	let functionalLabel: String
	let transcription: String?
	let definitions: [Definition]
}