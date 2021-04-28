//
//  MockDiscoverCollectionService.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 26.04.2021.
//

import UIKit

protocol DiscoverCollectionServiceProtocol {
	func collections(completion: @escaping (Result<[DiscoverCollectionModel], Error>) -> Void)
}

// swiftlint:disable all
class MockDiscoverCollectionService: DiscoverCollectionServiceProtocol {
	private let discoverCollections: [DiscoverCollectionModel] = [
		DiscoverCollectionModel(
			title: "Happy New Year",
			date: "31 December 2020",
			image: UIImage(named: "firework")!,
			words: [
				(title: "holiday", shortDefinition: "a special day of celebration"),
				(title: "New Year's Eve", shortDefinition: "December 31: the last day of the year"),
				(title: "gathering", shortDefinition: "an occasion when people come together as a group"),
				(title: "celebrate", shortDefinition: "to do something special or enjoyable for an important event, occasion, holiday, etc."),
				(title: "countdown", shortDefinition: "the act of counting down the number of seconds that remain before something happens"),
				(title: "resolution", shortDefinition: "a promise to yourself that you will make a serious effort to do something that you should do"),
				(title: "midnight", shortDefinition: "the middle of the night: 12 o'clock at night"),
				(title: "firework", shortDefinition: "a small device that explodes to make a display of light and noise"),
				(title: "confetti", shortDefinition: "small pieces of brightly colored paper that people often throw at celebrations")
			]
		),
		DiscoverCollectionModel(
			title: "Back to School",
			date: "1 September 2020",
			image: UIImage(named: "back to school")!,
			words: [
				(title: "backpack", shortDefinition: "a bag for carrying things that has two shoulder straps and is carried on the back"),
				(title: "pen", shortDefinition: "a writing instrument that uses ink"),
				(title: "pencil", shortDefinition: "an instrument used for writing and drawing that has a hard outer part and a black or colored center part"),
				(title: "eraser", shortDefinition: "a small piece of rubber or other material that is used to erase something you have written or drawn"),
				(title: "ruler", shortDefinition: "a straight piece of plastic, wood, or metal that has marks on it to show units of length and that is used to measure things"),
				(title: "notebook", shortDefinition: "a book with blank pages that is used for writing notes"),
				(title: "highlighter", shortDefinition: "a special pen with brightly colored ink that you can see through"),
				(title: "blackboard", shortDefinition: "a smooth, dark surface that is used for writing on with chalk in a classroom"),
				(title: "quiz", shortDefinition: "a short spoken or written test that is often taken without preparation")
			]
		)
	]

	func collections(completion: @escaping (Result<[DiscoverCollectionModel], Error>) -> Void) {
		completion(.success(discoverCollections))
	}
}
