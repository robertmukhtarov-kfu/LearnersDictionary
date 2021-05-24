//
//  UserCollectionCell.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 23.04.2021.
//

import UIKit

class UserCollectionCell: UICollectionViewCell {
	var color: UIColor = .gray {
		didSet {
			layer.backgroundColor = color.cgColor
		}
	}

	let titleLabel: UILabel = {
		let label = UILabel()
		label.textColor = .white
		label.font = .systemFont(ofSize: 20, weight: .bold)
		label.numberOfLines = 2
		return label
	}()

	let wordCountLabel: UILabel = {
		let label = UILabel()
		label.textColor = UIColor.white.withAlphaComponent(0.8)
		label.font = .systemFont(ofSize: 14)
		return label
	}()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		layer.backgroundColor = UIColor.gray.cgColor
		layer.cornerRadius = 10

		addSubview(titleLabel)
		titleLabel.snp.makeConstraints { make in
			make.top.equalTo(self).offset(10)
			make.left.equalTo(self).offset(12)
			make.right.equalTo(self).offset(-12)
		}

		addSubview(wordCountLabel)
		wordCountLabel.snp.makeConstraints { make in
			make.bottom.equalTo(self).offset(-10)
			make.left.equalTo(self).offset(12)
			make.right.equalTo(self).offset(-12)
		}
	}
}
