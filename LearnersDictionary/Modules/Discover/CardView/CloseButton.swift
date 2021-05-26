//
//  CloseButton.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 18.04.2021.
//

import UIKit

class CloseButton: UIButton {
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		layer.cornerRadius = frame.height / 2
		layer.opacity = 1.0
		clipsToBounds = true

		setImage(.xMark, for: .normal)
		imageView?.tintColor = .xMarkColor
		adjustsImageWhenHighlighted = false

		let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
		blurView.frame = bounds
		blurView.isUserInteractionEnabled = false
		insertSubview(blurView, at: 0)
		if let imageView = imageView { bringSubviewToFront(imageView) }
	}
}
