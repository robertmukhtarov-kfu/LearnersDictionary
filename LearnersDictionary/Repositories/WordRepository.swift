//
//  WordRepository.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 11.05.2021.
//

import CoreData

protocol WordRepositoryProtocol {
	func getWord(by spelling: String) -> Word?

	func fetchWordlist(
		predicate: NSPredicate?,
		sortDescriptors: [NSSortDescriptor]?,
		completion: (Result<[Word], Error>) -> Void
	)
}

class WordRepository: WordRepositoryProtocol {
	private let context = CoreDataService.shared.persistentContainer.viewContext

	func getWord(by spelling: String) -> Word? {
		let predicate = NSPredicate(format: "spelling == %@", spelling)
		let fetchRequest = Word.fetchRequest() as NSFetchRequest<Word>
		fetchRequest.predicate = predicate
		do {
			let words = try context.fetch(fetchRequest)
			guard let word = words.first else { return nil }
			return word
		} catch {
			return nil
		}
	}

	func fetchWordlist(
		predicate: NSPredicate?,
		sortDescriptors: [NSSortDescriptor]?,
		completion: (Result<[Word], Error>) -> Void
	) {
		let fetchRequest = Word.fetchRequest() as NSFetchRequest<Word>
		fetchRequest.predicate = predicate
		fetchRequest.sortDescriptors = sortDescriptors
		do {
			let words = try context.fetch(fetchRequest)
			completion(.success(words))
		} catch {
			completion(.failure(error))
		}
	}
}
