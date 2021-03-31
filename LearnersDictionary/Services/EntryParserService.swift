//
//  EntryParserService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 16.03.2021.
//

import Foundation
import SwiftyJSON

protocol EntryParserServiceProtocol {
	func parse(_ jsonData: Data, for word: String, _ completion: @escaping (Result<[EntryModel], EntryParserError>) -> Void)
}

class EntryParserService: EntryParserServiceProtocol {
	func parse(_ jsonData: Data, for word: String, _ completion: @escaping (Result<[EntryModel], EntryParserError>) -> Void) {
		guard let allEntries = try? JSON(data: jsonData) else {
			return completion(.failure(.notJSON))
		}

		let entries: [JSON]
		switch(getEntries(from: allEntries, for: word)) {
		case .success(let jsonEntries):
			entries = jsonEntries
		case .failure(let error):
			return completion(.failure(error))
		}

		switch parseEntries(from: entries, for: word) {
		case .success(let parsedEntries):
			return completion(.success(parsedEntries))
		case .failure(let error):
			return completion(.failure(error))
		}
	}

	private func getEntries(from json: JSON, for word: String) -> Result<[JSON], EntryParserError> {
		var entries: [JSON] = []

		guard let allEntriesArray = json.array else {
			return .failure(.invalidEntries)
		}

		for entry in allEntriesArray {
			guard var headword = entry["hwi"]["hw"].string else {
				return .failure(.invalidHeadword)
			}
			headword.removeAll { $0 == "*" }
			guard headword == word else { break }
			entries.append(entry)
		}
		return .success(entries)
	}

	private func parseEntries(from jsonEntries: [JSON], for word: String) -> Result<[EntryModel], EntryParserError> {
		let functions = getFunctionalLabels(from: jsonEntries)
		let transcriptions = getTranscriptions(from: jsonEntries)
		let definitions: [[DefinitionModel]]
		var result: [EntryModel] = []

		switch getDefinitions(from: jsonEntries) {
		case .success(let parsedDefinitions):
			definitions = parsedDefinitions
		case .failure(let error):
			return .failure(error)
		}

		for i in 0..<jsonEntries.count {
			result.append(
				EntryModel(
					headword: word,
					functionalLabel: functions[i],
					transcription: transcriptions[i],
					definitions: definitions[i]
				)
			)
		}
		return .success(result)
	}

	private func getFunctionalLabels(from jsonEntries: [JSON]) -> [String] {
		var functionalLabels: [String] = []
		for entry in jsonEntries {
			guard let functionalLabel = entry["fl"].string else {
				functionalLabels.append("More")
				continue
			}
			functionalLabels.append(functionalLabel)
		}
		return functionalLabels
	}

	private func getTranscriptions(from jsonEntries: [JSON]) -> [String?] {
		var pronunciations: [String?] = []
		for entry in jsonEntries {
			guard let pronunciation = entry["hwi"]["prs"][0]["ipa"].string else {
				pronunciations.append(nil)
				continue
			}
			pronunciations.append(pronunciation)
		}
		return pronunciations
	}

	private func getDefinitions(from jsonEntries: [JSON]) -> Result<[[DefinitionModel]], EntryParserError> {
		var allDefinitions: [[DefinitionModel]] = []
		for entry in jsonEntries {
			guard let sseq = entry["def"][0]["sseq"].array else {
				return .failure(.invalidSenseSequence)
			}
			var definitions: [DefinitionModel] = []
			for ssubseq in sseq {
				guard let ssubseq = ssubseq.array else {
					return .failure(.invalidSenseSubsequence)
				}
				let senses: [SenseModel]
				switch getSenses(from: ssubseq) {
				case .success(let parsedSenses):
					senses = parsedSenses
				case .failure(let error):
					return .failure(error)
				}
				definitions.append(DefinitionModel(senses: senses))
			}
			allDefinitions.append(definitions)
		}
		return .success(allDefinitions)
	}

	private func getSenses(from jsonSenseSubsequence: [JSON]) -> Result<[SenseModel], EntryParserError> {
		var senses: [SenseModel] = []
		for sense in jsonSenseSubsequence {
			guard sense[0].string == "sense" else { continue }
			guard let senseContent = sense[1].dictionary else {
				return .failure(.invalidSense)
			}
			let senseNumber = senseContent["sn"]?.string
			guard let definingText = senseContent["dt"]?.array else {
				return .failure(.invalidDefiningText)
			}
			guard let type = definingText[0][0].string else { continue }
			guard type == "text" else { continue }
			guard let text = definingText[0][1].string else { continue }
			senses.append(SenseModel(number: senseNumber, definingText: text.replacingOccurrences(of: "{bc}", with: "")))
		}
		return .success(senses)
	}
}
