//
//  ColorSwatchCell.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 24.05.2021.
//

import UIKit

class ColorSwatchCell: UICollectionViewCell {
	private let colorSwatchView = ColorSwatchView()

	override init(frame: CGRect) {
		super.init(frame: frame)
		contentView.addSubview(colorSwatchView)
		colorSwatchView.center = contentView.center
	}

	override func prepareForReuse() {
		super.prepareForReuse()
		deselect()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func set(color: UserCollectionColor) {
		colorSwatchView.set(color: color)
	}

	func select() {
		colorSwatchView.select()
	}

	func deselect() {
		colorSwatchView.deselect()
	}
}
