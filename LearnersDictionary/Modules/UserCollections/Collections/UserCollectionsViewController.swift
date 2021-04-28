//
//  UserCollectionsViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 23.04.2021.
//

import UIKit

class UserCollectionsViewController: UIViewController, UserCollectionsViewProtocol {
	var presenter: UserCollectionsPresenterProtocol?

	let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .background
		extendedLayoutIncludesOpaqueBars = true
		title = "My Collections"
		setupCollectionView()
		setupNavigationBar()
		presenter?.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		navigationController?.setToolbarHidden(true, animated: true)
	}

	private func setupNavigationBar() {
		navigationItem.leftBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "accountNavBar"),
			style: .plain,
			target: self,
			action: #selector(showAccountScreen)
		)
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "addCollectionNavBar"),
			style: .plain,
			target: self,
			action: #selector(addNewCollection)
		)
		navigationItem.largeTitleDisplayMode = .always
		if #available(iOS 14.0, *) {
			navigationItem.backButtonDisplayMode = .generic
		} else {
			navigationItem.backButtonTitle = "Back"
		}
	}

	func reloadData() {
		collectionView.reloadData()
	}

	// MARK: - Private Methods

	private func setupCollectionView() {
		collectionView.backgroundColor = .background
		collectionView.delegate = self
		collectionView.dataSource = self
		collectionView.alwaysBounceVertical = true
		view.addSubview(collectionView)
		collectionView.snp.makeConstraints { make in
			make.edges.equalTo(view)
		}
		collectionView.register(UserCollectionCell.self, forCellWithReuseIdentifier: "UserCollectionCell")

		let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
		collectionView.addGestureRecognizer(longPressGesture)
	}

	@objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
		guard let gestureView = gesture.view else { return }
		switch gesture.state {
		case .began:
			let location = gesture.location(in: collectionView)
			guard let selectedIndexPath = collectionView.indexPathForItem(at: location) else { break }
			collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
		case .changed:
			collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gestureView))
		case .ended:
			collectionView.endInteractiveMovement()
		default:
			collectionView.cancelInteractiveMovement()
		}
	}

	@objc private func addNewCollection() {
		// TODO

	}

	@objc private func showAccountScreen() {
		// TODO
	}
}

extension UserCollectionsViewController: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		presenter?.collectionsCount ?? 0
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard
			let userCollection = presenter?.getCollection(forCellAt: indexPath),
			let userCollectionCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: "UserCollectionCell",
				for: indexPath
			) as? UserCollectionCell
		else { fatalError("Couldn't dequeue cell") }

		userCollectionCell.color = userCollection.color
		userCollectionCell.titleLabel.text = userCollection.title
		userCollectionCell.wordCountLabel.text = "\(userCollection.words.count) words"
		return userCollectionCell
	}
}

extension UserCollectionsViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let padding: CGFloat = 55
		let width = (collectionView.frame.size.width - padding) / 2
		let height = width / 1.7
		return CGSize(width: width, height: height)
	}

	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presenter?.didSelectCollection(at: indexPath)
	}

	func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
		true
	}

	func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
		presenter?.moveCollection(from: sourceIndexPath, to: destinationIndexPath)
	}
}
