//
//  WordOfTheDayCardView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 11.04.2021.
//

import UIKit

class WordOfTheDayCardView: CardView {
	private let wordOfTheDay: WordOfTheDayModel

	private let titleLabel = UILabel()
	private let definitionLabel = UILabel()
	private let addButton = AddButton(frame: CGRect(x: 0, y: 0, width: 80, height: 30))

	init(presentationType: CardViewPresentationType, wordOfTheDay: WordOfTheDayModel) {
		self.wordOfTheDay = wordOfTheDay
		super.init(presentationType: presentationType)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func setup() {
		super.setup()
		if let imageURL = URL(string: wordOfTheDay.imageURL) {
			imageView.kf.setImage(with: imageURL)
		}
		blurView.effect = UIBlurEffect(style: .dark)
		setupLabels()
		setupAddButton()
	}

	private func setupLabels() {
		blurView.contentView.addSubview(titleLabel)
		blurView.contentView.addSubview(definitionLabel)
		titleLabel.text = wordOfTheDay.title
		titleLabel.textColor = .white
		titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
		definitionLabel.numberOfLines = 0
		definitionLabel.text = wordOfTheDay.shortDefinition
		definitionLabel.font = .systemFont(ofSize: 12, weight: .regular)
		definitionLabel.textColor = .white
	}

	private func setupAddButton() {
		blurView.contentView.addSubview(addButton)
		addButton.snp.makeConstraints { make in
			make.centerY.equalTo(titleLabel)
			make.width.equalTo(addButton.frame.width)
			make.height.equalTo(addButton.frame.height)
			make.right.equalTo(blurView).offset(-20)
		}
		addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
	}

	@objc private func addButtonTapped() {
		delegate?.addButtonTapped()
	}

	override func setFullMode() {
		super.setFullMode()

		addButton.isUserInteractionEnabled = true
		addButton.layer.opacity = 1.0

		definitionLabel.layer.opacity = 0.0

		titleLabel.snp.remakeConstraints { make in
			make.left.equalToSuperview().offset(20)
			make.right.equalTo(addButton).offset(-20)
			make.centerY.equalToSuperview().offset(-5)
		}

		blurView.snp.remakeConstraints { make in
			make.right.left.equalToSuperview()
			make.bottom.equalToSuperview().offset(10)
			make.height.equalToSuperview().multipliedBy(0.25)
		}
	}

	override func setCardMode() {
		super.setCardMode()

		addButton.isUserInteractionEnabled = false
		addButton.layer.opacity = 0.0

		blurView.snp.remakeConstraints { make in
			make.right.left.equalToSuperview()
			make.bottom.equalToSuperview().offset(10)
			make.height.equalToSuperview().multipliedBy(0.45)
		}

		titleLabel.snp.remakeConstraints { make in
			make.left.equalToSuperview().offset(16)
			make.right.equalToSuperview().offset(-16)
			make.top.equalToSuperview().offset(16)
		}

		definitionLabel.layer.opacity = 1
		definitionLabel.snp.remakeConstraints { make in
			make.left.equalToSuperview().offset(16)
			make.right.equalToSuperview().offset(-16)
			make.top.equalTo(titleLabel.snp.bottom).offset(8)
		}
	}

	override func viewCopy() -> CardView {
		return WordOfTheDayCardView(
			presentationType: presentationType,
			wordOfTheDay: wordOfTheDay
		)
	}
}
