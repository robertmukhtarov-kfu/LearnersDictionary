//
//  EntryNetworkService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 15.03.2021.
//

import Alamofire

protocol EntryNetworkServiceProtocol {
	func loadEntries(for word: String, _ completion: @escaping (Result<Data?, Error>) -> Void)
}

class EntryNetworkService: EntryNetworkServiceProtocol {
	let baseURL: URL = {
		let apiURL = "https://dictionaryapi.com/api/v3/references/learners/json"
		guard let url = URL(string: apiURL) else {
			fatalError("Invalid base URL.")
		}
		return url
	}()

	let key = PrivateStrings.apiKey.rawValue

	func loadEntries(for word: String, _ completion: @escaping (Result<Data?, Error>) -> Void) {
		let entryURL = baseURL.appendingPathComponent(word)
		AF.request(entryURL, parameters: ["key": key]).validate().responseJSON { response in
			switch response.result {
			case .success:
				return completion(.success(response.data))
			case .failure(let error):
				return completion(.failure(error))
			}
		}
	}
}
