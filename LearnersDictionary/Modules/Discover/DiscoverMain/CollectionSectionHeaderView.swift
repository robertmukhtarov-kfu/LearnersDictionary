//
//  CollectionSectionHeaderView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 11.04.2021.
//

import UIKit

class CollectionSectionHeaderView: UICollectionReusableView {
	var title: String = "" {
		didSet {
			label.text = title
		}
	}
	private let label = UILabel()

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		addSubview(label)
		label.font = .systemFont(ofSize: 30, weight: .bold)
		label.text = title
		label.snp.makeConstraints { make in
			make.left.equalTo(self).offset(20)
			make.right.equalTo(self).offset(-20)
			make.centerY.equalTo(self)
		}
	}
}
