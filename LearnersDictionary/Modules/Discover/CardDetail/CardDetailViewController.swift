//
//  CardDetailViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 13.04.2021.
//

import UIKit

class CardDetailViewController: UIViewController, UIGestureRecognizerDelegate {
	var coordinator: DiscoverCoordinatorProtocol?

	let cardView: CardView
	let childViewController: TrackedScrollViewProtocol
	let childView: UIView
	let distanceFromChildToCard: CGFloat
	var cardViewTopConstraintConstant: CGFloat = 0.0 {
		didSet {
			cardView.snp.updateConstraints { make in
				make.top.equalTo(view.snp.top).offset(cardViewTopConstraintConstant)
			}
		}
	}
	let blurredStatusBar = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

	init(cardView: CardView, childViewController: TrackedScrollViewProtocol, distanceFromChildToCard: CGFloat = 0) {
		self.cardView = cardView
		self.childViewController = childViewController
		self.childView = childViewController.view
		self.distanceFromChildToCard = distanceFromChildToCard
		super.init(nibName: nil, bundle: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setup()

		view.addSubview(blurredStatusBar)
		blurredStatusBar.snp.makeConstraints { make in
			make.top.left.right.equalTo(view)
			make.height.equalTo(UIApplication.statusBarHeight)
		}
		setupChildVC()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		navigationController?.setNavigationBarHidden(true, animated: true)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(true)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}

	private func setup() {
		cardView.delegate = self
		view.backgroundColor = .background
		view.addSubview(cardView)
		cardView.snp.makeConstraints { make in
			make.top.left.right.equalTo(view)
			make.height.equalTo(260)
		}
		cardView.setFullMode()
	}

	private func setupChildVC() {
		childViewController.trackedScrollViewDelegate = self
		addChild(childViewController)
		view.addSubview(childView)
		childView.snp.makeConstraints { make in
			make.top.equalTo(cardView.snp.bottom).offset(distanceFromChildToCard)
			make.left.right.bottom.equalTo(view)
		}
		childViewController.didMove(toParent: self)
		childView.layoutIfNeeded()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension CardDetailViewController: TrackedScrollViewDelegate {
	func didScroll(_ scrollView: UIScrollView, to newPointY: CGFloat) {
		let lowerBound: CGFloat = -(cardView.distanceToBlurView() - blurredStatusBar.frame.height)
		let upperBound: CGFloat = 0.0
		let y: CGFloat = scrollView.contentOffset.y

		let newCardViewTopConstraintConstant = cardViewTopConstraintConstant - y
		if newCardViewTopConstraintConstant > upperBound {
			cardViewTopConstraintConstant = upperBound
		} else if newCardViewTopConstraintConstant < lowerBound {
			cardViewTopConstraintConstant = lowerBound
		} else {
			cardViewTopConstraintConstant = newCardViewTopConstraintConstant
			scrollView.contentOffset.y = 0
		}
	}
}

extension CardDetailViewController: CardViewDelegate {
	func cardViewCloseButtonTapped() {
		coordinator?.dismissCardDetail()
	}
}
