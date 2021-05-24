//
//  EntryParserService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 16.03.2021.
//

import Foundation
import SwiftyJSON

protocol EntryParserServiceProtocol {
	func parse(_ jsonData: Data, for word: String, completion: @escaping (Result<[EntryModel], EntryParserError>) -> Void)
}

class EntryParserService: EntryParserServiceProtocol {
	func parse(_ jsonData: Data, for word: String, completion: @escaping (Result<[EntryModel], EntryParserError>) -> Void) {
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

	// MARK: - Private methods

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
			guard entry["def"][0]["sseq"] != JSON.null else { continue }
			entries.append(entry)
		}
		return .success(entries)
	}

	private func parseEntries(from jsonEntries: [JSON], for word: String) -> Result<[EntryModel], EntryParserError> {
		let functions = getFunctionalLabels(from: jsonEntries)
		let pronunciations = getPronunciations(from: jsonEntries)
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
					transcription: pronunciations[i].transcription,
					audioFileName: pronunciations[i].audioFileName,
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

	private func getPronunciations(from jsonEntries: [JSON]) -> [(transcription: String?, audioFileName: String?)] {
		var pronunciations: [(transcription: String?, audioFileName: String?)] = []
		for entry in jsonEntries {
			guard
				let pronunciation = entry["hwi"]["prs"][0].dictionary,
				let transcription = pronunciation["ipa"]?.string
			else {
				pronunciations.append((transcription: nil, audioFileName: nil))
				continue
			}
			guard let audioFileName = pronunciation["sound"]?["audio"].string else {
				pronunciations.append((transcription: transcription, audioFileName: nil))
				continue
			}
			pronunciations.append((transcription: transcription, audioFileName: audioFileName))
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
				var senses: [SenseModel]
				switch getSenses(from: ssubseq) {
				case .success(let parsedSenses):
					senses = parsedSenses
				case .failure(let error):
					return .failure(error)
				}
				var definitionNumber: String?
				if let firstSense = senses.first, let senseNumber = firstSense.number {
					if let spaceIndex = senseNumber.firstIndex(of: " ") {
						definitionNumber = String(senseNumber[..<spaceIndex])
						let newSenseNumber = String(senseNumber[spaceIndex...]).trimmingCharacters(in: .whitespaces)
						senses[0] = SenseModel(number: newSenseNumber, text: firstSense.text)
					} else {
						definitionNumber = senseNumber
						senses[0] = SenseModel(number: nil, text: firstSense.text)
					}
				}
				definitions.append(DefinitionModel(number: definitionNumber, senses: senses))
			}
			allDefinitions.append(definitions)
		}
		return .success(allDefinitions)
	}

	private func getSenses(from jsonSenseSubsequence: [JSON]) -> Result<[SenseModel], EntryParserError> {
		var senses: [SenseModel] = []
		for sense in jsonSenseSubsequence {
			let resultText = NSMutableAttributedString(string: "")
			let senseContent: [String: JSON]
			switch sense[0].string {
			case "sense", "sen":
				guard let content = sense[1].dictionary else {
					return .failure(.invalidSense)
				}
				senseContent = content
			case "bs":
				guard let content = sense[1]["sense"].dictionary else {
					return .failure(.invalidSense)
				}
				senseContent = content
			default:
				continue
			}

			let senseNumber = senseContent["sn"]?.string

			if let grammaticalLabel = senseContent["sgram"]?.string {
				let formattedGrammaticalLabel = NSAttributedString(
					string: "[\(grammaticalLabel)] ",
					attributes: .grammaticalLabel
				)
				resultText.append(formattedGrammaticalLabel)
			}

			let generalLabels = getLabels("lbs", from: senseContent)
			resultText.append(generalLabels)
			let statusLabels = getLabels("sls", from: senseContent)
			if generalLabels.length > 0 && statusLabels.length > 0 {
				resultText.append(NSAttributedString(string: "; ", attributes: .statusLabel))
			}
			resultText.append(statusLabels)

			if let definingText = getDefiningText(from: senseContent) {
				let formattedDefiningText = NSAttributedString(
					string: definingText,
					attributes: .body
				)
				resultText.append(formattedDefiningText)
			}

			senses.append(SenseModel(number: senseNumber, text: resultText))
		}
		return .success(senses)
	}

	private func getLabels(_ type: String, from senseContentJson: [String: JSON]) -> NSAttributedString {
		let resultText = NSMutableAttributedString()
		if let labels = senseContentJson[type]?.array {
			var result = ""
			for (index, label) in labels.enumerated() {
				guard let labelString = label.string else { continue }
				result += labelString
				if index != labels.endIndex - 1 {
					result += ","
				}
				result += " "
			}
			let formattedResult = NSAttributedString(
				string: result,
				attributes: .statusLabel
			)
			resultText.append(formattedResult)
		}
		return resultText
	}

	private func getDefiningText(from senseContentJson: [String: JSON]) -> String? {
		var result = ""
		guard let definingText = senseContentJson["dt"]?.array else {
			return nil
		}
		guard let type = definingText[0][0].string else { return nil }
		switch type {
		case "text":
			guard let text = definingText[0][1].string else { return nil }
			result += text
		case "uns":
			guard let usageNote = definingText[0][1][0][0].array else { return nil }
			guard usageNote[0].string == "text" else { return nil }
			guard let text = usageNote[1].string else { return nil }
			result += text
		default:
			return nil
		}
		return result.replacingOccurrences(of: "{bc}", with: "")
	}
}
