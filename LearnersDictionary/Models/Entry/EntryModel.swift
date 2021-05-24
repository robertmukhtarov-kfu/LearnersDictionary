//
//  EntryModel.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 07.03.2021.
//

import Foundation

struct EntryModel {
	let headword: String
	let functionalLabel: String
	let transcription: String?
	let audioFileName: String?
	let definitions: [DefinitionModel]
}
