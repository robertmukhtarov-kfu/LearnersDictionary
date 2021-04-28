//
//  WordOfTheDaySectionHeaderView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 11.04.2021.
//

import UIKit

class WordOfTheDaySectionHeaderView: UICollectionReusableView {
	var date: String = "" {
		didSet {
			dateLabel.text = date
		}
	}
	private let titleLabel = UILabel()
	private let dateLabel = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		let stackView = UIStackView()
		addSubview(stackView)
		stackView.axis = .vertical
		stackView.alignment = .leading
		stackView.spacing = 4
		stackView.snp.makeConstraints { make in
			make.centerY.equalTo(self)
			make.left.equalTo(self).offset(20)
			make.right.equalTo(self).offset(-20)
		}

		stackView.addArrangedSubview(titleLabel)
		titleLabel.font = .systemFont(ofSize: 30, weight: .bold)
		titleLabel.text = "Word of the Day"

		stackView.addArrangedSubview(dateLabel)
		dateLabel.textColor = .gray
		dateLabel.font = .systemFont(ofSize: 12, weight: .bold)
		dateLabel.text = "Wednesday 28 April".uppercased()
	}
}
