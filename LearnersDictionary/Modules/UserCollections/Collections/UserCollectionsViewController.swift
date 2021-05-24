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
		title = presenter?.title
		setupCollectionView()
		setupNavigationBar()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		navigationController?.setToolbarHidden(true, animated: true)
		presenter?.viewWillAppear()
	}

	private func setupNavigationBar() {
		switch presenter?.mode {
		case .add:
			navigationItem.leftBarButtonItem = UIBarButtonItem(
				barButtonSystemItem: .cancel,
				target: self,
				action: #selector(cancelButtonPressed)
			)
		default:
			navigationItem.leftBarButtonItem = UIBarButtonItem(
				image: UIImage(named: "accountNavBar"),
				style: .plain,
				target: self,
				action: #selector(userProfileButtonTapped)
			)
		}

		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "addCollectionNavBar"),
			style: .plain,
			target: self,
			action: #selector(addNewCollectionButtonPressed)
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

	@objc private func cancelButtonPressed() {
		presenter?.cancelButtonPressed()
	}

	@objc private func addNewCollectionButtonPressed() {
		presenter?.addNewCollectionButtonPressed()
	}

	func finish() {
		dismiss(animated: true)
	}

	func showNewCollectionAlert() {
		let alert = UIAlertController(title: "New Collection", message: "Name your new collection", preferredStyle: .alert)
		alert.addTextField { textField in
			textField.placeholder = "Name"
		}
		alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
			guard let text = alert.textFields?[0].text else {
				fatalError("Failed to extract text field from alert")
			}
			self?.presenter?.addNewCollection(named: text)
		})
		alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
		present(alert, animated: true)
	}

	@objc private func userProfileButtonTapped() {
		presenter?.userProfileButtonTapped()
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

		userCollectionCell.color = userCollection.color.toUIColor()
		userCollectionCell.titleLabel.text = userCollection.title
		let wordCount = userCollection.words.count
		userCollectionCell.wordCountLabel.text = "\(wordCount) " + (wordCount != 1 ? "words" : "word")
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
