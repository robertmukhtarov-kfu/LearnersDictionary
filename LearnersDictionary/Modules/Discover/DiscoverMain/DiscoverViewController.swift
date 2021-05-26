//
//  DiscoverViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 11.04.2021.
//

import UIKit

class DiscoverViewController: UIViewController, DiscoverViewProtocol {
	var presenter: DiscoverPresenterProtocol?

	private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
	private(set) var selectedCardView: CardView?
	let blurredStatusBar = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

	private let activityIndicatorViewController = ActivityIndicatorViewController()

	let cellWidth: CGFloat = UIScreen.main.bounds.width - 40
	let cellSpacing: CGFloat = 30.0

	private enum ReuseIdentifier {
		static let wordOfTheDaySectionHeaderView = "WordOfTheDaySectionHeaderView"
		static let collectionSectionHeaderView = "CollectionSectionHeaderView"
		static let cardViewCell = "CardViewCell"
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setup()
		presenter?.viewDidLoad()
		showActivityIndicator()
	}

	func reloadData() {
		collectionView.reloadData()
	}

	func showActivityIndicator() {
		addChild(activityIndicatorViewController)
		activityIndicatorViewController.view.frame = view.frame
		view.addSubview(activityIndicatorViewController.view)
		activityIndicatorViewController.didMove(toParent: self)
	}

	func showError(message: String) {
		showErrorAlert(message: message)
	}

	func hideActivityIndicator() {
		UIView.animate(withDuration: 0.5) {
			self.activityIndicatorViewController.view.layer.opacity = 0
		} completion: { _ in
			self.activityIndicatorViewController.willMove(toParent: nil)
			self.activityIndicatorViewController.view.removeFromSuperview()
			self.activityIndicatorViewController.removeFromParent()
		}
	}

	private func setup() {
		collectionView.backgroundColor = .background
		collectionView.layer.masksToBounds = false

		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { make in
			make.edges.equalTo(view)
		}
		collectionView.register(
			WordOfTheDaySectionHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: ReuseIdentifier.wordOfTheDaySectionHeaderView
		)
		collectionView.register(
			CollectionSectionHeaderView.self,
			forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
			withReuseIdentifier: ReuseIdentifier.collectionSectionHeaderView
		)
		collectionView.register(CardViewCell.self, forCellWithReuseIdentifier: ReuseIdentifier.cardViewCell)
		collectionView.dataSource = self
		collectionView.delegate = self

		view.addSubview(blurredStatusBar)
		blurredStatusBar.snp.makeConstraints { make in
			make.top.left.right.equalTo(view)
			make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
		}
	}
}

extension DiscoverViewController: UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		2
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		switch section {
		case 0:
			return 1
		default:
			return presenter?.collectionCount ?? 0
		}
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cardView: CardView
		switch indexPath.section {
		case 0:
			guard let wordOfTheDay = presenter?.getWordOfTheDay() else { fatalError("Couldn't get word of the day") }
			cardView = WordOfTheDayCardView(presentationType: .card, wordOfTheDay: wordOfTheDay)
		default:
			guard let collection = presenter?.getCollection(forCellAt: indexPath) else { fatalError("Couldn't get collection") }
			cardView = CollectionCardView(presentationType: .card, discoverCollection: collection)
		}
		guard let cardCell = collectionView.dequeueReusableCell(
			withReuseIdentifier: ReuseIdentifier.cardViewCell,
			for: indexPath
		) as? CardViewCell else {
			fatalError("Couldn't dequeue cell")
		}
		cardCell.cardView = cardView
		return cardCell
	}

	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionView.elementKindSectionHeader {
			switch indexPath.section {
			case 0:
				guard let wordOfTheDaySectionHeaderView = collectionView.dequeueReusableSupplementaryView(
					ofKind: kind,
					withReuseIdentifier: ReuseIdentifier.wordOfTheDaySectionHeaderView,
					for: indexPath
				) as? WordOfTheDaySectionHeaderView else { fatalError("Couldn't dequeue Word of the Day header") }
				return wordOfTheDaySectionHeaderView
			default:
				guard let collectionSectionHeaderView = collectionView.dequeueReusableSupplementaryView(
					ofKind: kind,
					withReuseIdentifier: ReuseIdentifier.collectionSectionHeaderView,
					for: indexPath
				) as? CollectionSectionHeaderView else { fatalError("Couldn't dequeue Collections header") }
				collectionSectionHeaderView.title = "Collections"
				return collectionSectionHeaderView
			}
		}
		fatalError("Couldn't dequeue headers")
	}
}

extension DiscoverViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		guard
			let cell = collectionView.cellForItem(at: indexPath) as? CardViewCell,
			let cardView = cell.cardView
		else { return }
		switch indexPath.section {
		case 0:
			presenter?.showWordOfTheDay(cardView: cardView)
		default:
			presenter?.showDiscoverCollection(at: indexPath.item, cardView: cardView)
		}
		selectedCardView = cardView
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		switch section {
		case 0:
			return CGSize(width: cellWidth, height: 90)
		default:
			return CGSize(width: cellWidth, height: 70)
		}
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		switch indexPath.section {
		case 0:
			return CGSize(width: cellWidth, height: 240)
		default:
			return CGSize(width: cellWidth, height: 200)
		}
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		cellSpacing
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		UIEdgeInsets(top: 0, left: 0, bottom: section == 1 ? 20 : 0, right: 0)
	}
}
