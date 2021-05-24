//
//  EntryPageViewPresenter.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 16.03.2021.
//

import UIKit
import AVFoundation

class EntryPageViewPresenter: EntryPageViewPresenterProtocol {
	weak var coordinator: SearchCoordinator?
	weak var view: EntryPageView?
	var word: Word

	private let entryRepository = EntryRepository()
	private let entryNetworkService = EntryNetworkService()

	private var player: AVAudioPlayer?

	init(word: Word) {
		self.word = word
	}

	func viewDidLoad() {
		set(word: word)
	}

	func set(word: Word) {
		self.word = word
		view?.reset()
		view?.set(title: word.spelling)
		showEntries()
	}

	func errorOccurred() {
		coordinator?.closeEntry()
	}

	func addToCollectionButtonTapped() {
		let navigationController = UINavigationController()
		let userCollectionPresenter = UserCollectionsPresenter(mode: .add(word))
		let userCollectionVC = UserCollectionsViewController()
		userCollectionPresenter.view = userCollectionVC
		userCollectionVC.presenter = userCollectionPresenter
		navigationController.setViewControllers([userCollectionVC], animated: false)
		view?.showAddToCollectionScreen(viewController: navigationController)
	}

	func pronounce(audioFileName: String) {
		entryNetworkService.loadPronunciationAudio(for: audioFileName) { result in
			switch result {
			case .success(let audioData):
				guard let pronunciationPlayer = try? AVAudioPlayer(data: audioData) else { return }
				self.player = pronunciationPlayer
				self.player?.play()
			case .failure(let error):
				print(error)
			}
		}
	}

	// MARK: - Private Methods

	private func showEntries() {
		entryRepository.entries(for: word.spelling) { [weak self] result in
			guard let self = self else { return }
			switch result {
			case .success(let parsedEntries):
				self.view?.configure(with: parsedEntries)
			case .failure(let error):
				self.view?.showError(message: error.localizedDescription)
			}
		}
	}
}
