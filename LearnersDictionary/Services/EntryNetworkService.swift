//
//  EntryNetworkService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 15.03.2021.
//

import Alamofire

protocol EntryNetworkServiceProtocol {
	func loadEntries(for word: String, completion: @escaping (Result<Data, EntryNetworkError>) -> Void)
}

class EntryNetworkService: EntryNetworkServiceProtocol {
	let baseURL: URL = {
		let apiURL = "https://dictionaryapi.com/api/v3/references/learners/json"
		guard let url = URL(string: apiURL) else {
			fatalError("Invalid base URL.")
		}
		return url
	}()

	let key = PrivateStrings.apiKey

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
}
