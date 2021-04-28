//
//  CardViewCell.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 13.04.2021.
//

import UIKit

class CardViewCell: UICollectionViewCell {
	var cardView: CardView? {
		didSet {
			setupCardView()
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupCardView() {
		guard let cardView = cardView else { return }
		subviews.forEach { $0.removeFromSuperview() }
		addSubview(cardView)
		cardView.snp.makeConstraints { make in
			make.edges.equalTo(self)
		}
	}
}
