//
//  CollectionCardView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 11.04.2021.
//

import UIKit
import Kingfisher

class CollectionCardView: CardView {
	private let discoverCollection: DiscoverCollectionModel
	private let dateLabel = UILabel()
	private let titleLabel = UILabel()
	private let addButton = AddButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))

	init(presentationType: CardViewPresentationType, discoverCollection: DiscoverCollectionModel) {
		self.discoverCollection = discoverCollection
		super.init(presentationType: presentationType)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func setup() {
		super.setup()
		if let imageURL = URL(string: discoverCollection.imageURL) {
			imageView.kf.setImage(with: imageURL)
		}
		blurView.effect = UIBlurEffect(style: .extraLight)
		blurView.snp.makeConstraints { make in
			make.right.left.equalToSuperview()
			make.bottom.equalToSuperview().offset(10)
			make.height.equalTo(80)
		}
		setupLabels()
		setupAddButton()
	}

	private func setupLabels() {
		blurView.contentView.addSubview(dateLabel)
		blurView.contentView.addSubview(titleLabel)

		dateLabel.text = DateFormatter.dMMMMyyyy.string(from: discoverCollection.date)
		dateLabel.font = .systemFont(ofSize: 12, weight: .bold)
		dateLabel.textColor = .darkGray
		dateLabel.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(16)
			make.right.equalToSuperview().offset(-16)
			make.top.equalToSuperview().offset(10)
		}

		titleLabel.text = discoverCollection.title
		titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
		titleLabel.textColor = .black
		titleLabel.snp.makeConstraints { make in
			make.left.equalToSuperview().offset(16)
			make.right.equalToSuperview().offset(-16)
			make.top.equalTo(dateLabel.snp.bottom).offset(4)
		}
	}

	private func setupAddButton() {
		blurView.contentView.addSubview(addButton)
		addButton.snp.makeConstraints { make in
			make.centerY.equalTo(blurView).offset(-5)
			make.width.equalTo(addButton.frame.width)
			make.height.equalTo(addButton.frame.height)
			make.right.equalTo(blurView).offset(-20)
		}
		addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
	}

	@objc private func addButtonTapped() {
		delegate?.addButtonTapped()
	}

	override func setCardMode() {
		super.setCardMode()
		addButton.isUserInteractionEnabled = false
		addButton.layer.opacity = 0.0
	}

	override func setFullMode() {
		super.setFullMode()
		addButton.isUserInteractionEnabled = true
		addButton.layer.opacity = 1.0
	}

	override func viewCopy() -> CardView {
		return CollectionCardView(
			presentationType: presentationType,
			discoverCollection: discoverCollection
		)
	}
}
