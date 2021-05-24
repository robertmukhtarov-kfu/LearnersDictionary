//
//  EntryNetworkService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 15.03.2021.
//

import Alamofire

protocol EntryNetworkServiceProtocol {
	func loadEntries(for word: String, completion: @escaping (Result<Data, EntryNetworkError>) -> Void)
	func loadPronunciationAudio(for fileName: String, completion: @escaping (Result<Data, EntryNetworkError>) -> Void)
}

class EntryNetworkService: EntryNetworkServiceProtocol {
	private enum URLs {
		static let api = "https://dictionaryapi.com/api/v3/references/learners/json"
		static let media = "https://media.merriam-webster.com/audio/prons/en/us/mp3"
	}

	private let baseURL: URL = {
		guard let url = URL(string: URLs.api) else {
			fatalError("Invalid base URL.")
		}
		return url
	}()
	private let mediaURL: URL = {
		guard let url = URL(string: URLs.media) else {
			fatalError("Invalid media URL.")
		}
		return url
	}()

	private let key = PrivateStrings.apiKey

	func loadEntries(for word: String, completion: @escaping (Result<Data, EntryNetworkError>) -> Void) {
		let entryURL = baseURL.appendingPathComponent(word)
		AF.request(entryURL, parameters: ["key": key]).validate().responseJSON { response in
			switch response.result {
			case .success:
				guard let data = response.data else {
					return completion(.failure(.noData))
				}
				return completion(.success(data))
			case .failure:
				return completion(.failure(.entryLoadFailure))
			}
		}
	}

	func loadPronunciationAudio(for fileName: String, completion: @escaping (Result<Data, EntryNetworkError>) -> Void) {
		guard let firstLetter = fileName.first else {
			return completion(.failure(.invalidAudioFile))
		}
		let audioURL = mediaURL.appendingPathComponent("\(firstLetter)/\(fileName).mp3")
		AF.request(audioURL).validate().response { response in
			switch response.result {
			case .success:
				guard let data = response.data else {
					return completion(.failure(.invalidAudioFile))
				}
				return completion(.success(data))
			case .failure:
				return completion(.failure(.invalidAudioFile))
			}
		}
	}
}
