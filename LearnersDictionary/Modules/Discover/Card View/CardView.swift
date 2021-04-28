//
//  CardView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 11.04.2021.
//

import UIKit

enum CardViewPresentationType {
	case card
	case full
}

protocol CardViewDelegate: AnyObject {
	func cardViewCloseButtonTapped()
}

class CardView: UIView {
	let imageView = UIImageView()
	let contentView = UIView(frame: .zero)
	let closeButton = CloseButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
	let presentationType: CardViewPresentationType
	let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
	weak var delegate: CardViewDelegate?

	init(presentationType: CardViewPresentationType) {
		self.presentationType = presentationType
		super.init(frame: .zero)
		setup()
		presentationType == .card ? setCardMode() : setFullMode()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setup() {
		layer.masksToBounds = false
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = .init(width: 0, height: 10)
		layer.shadowRadius = 16

		addSubview(contentView)
		contentView.snp.makeConstraints { make in
			make.edges.equalToSuperview()
		}
		contentView.layer.masksToBounds = true

		setupImageView()
		setupBlurView()
		setupCloseButton()
	}

	private func setupImageView() {
		contentView.addSubview(imageView)
		imageView.contentMode = .scaleAspectFill
		imageView.snp.makeConstraints { make in
			make.edges.equalTo(self)
		}
	}

	private func setupBlurView() {
		contentView.addSubview(blurView)
		blurView.alpha = 0.95
	}

	private func setupCloseButton() {
		contentView.addSubview(closeButton)

		closeButton.snp.makeConstraints { make in
			make.top.equalTo(contentView).offset(UIApplication.statusBarHeight + 10)
			make.right.equalTo(contentView).offset(-20)
			make.width.equalTo(closeButton.frame.width)
			make.height.equalTo(closeButton.frame.height)
		}

		closeButton.addTarget(self, action: #selector(closeButtonTapped(_:)), for: .touchUpInside)
	}

	@objc private func closeButtonTapped(_ sender: UIButton) {
		delegate?.cardViewCloseButtonTapped()
	}

	func setFullMode() {
		contentView.layer.cornerRadius = 0
		layer.shadowOpacity = 0
		closeButton.isUserInteractionEnabled = true
		closeButton.layer.opacity = 1.0
	}

	func setCardMode() {
		contentView.layer.cornerRadius = 16
		layer.shadowOpacity = 0.1
		closeButton.isUserInteractionEnabled = false
		closeButton.layer.opacity = 0.0
	}

	func distanceToBlurView() -> CGFloat {
		blurView.frame.minY
	}

	func viewCopy() -> CardView {
		CardView(presentationType: presentationType)
	}
}
