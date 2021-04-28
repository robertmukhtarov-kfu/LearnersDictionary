//
//  CardTransitionManager.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 14.04.2021.
//

import UIKit

enum CardTransitionType {
	case present
	case dismiss
}

class CardTransitionManager: NSObject {
	private let transitionDuration = 0.8
	private var transition: CardTransitionType = .present
	private let shrinkDuration = 0.2

	private let backgroundView: UIView = {
		let backgroundView = UIView()
		backgroundView.backgroundColor = .background
		return backgroundView
	}()

	private let blurredStatusBar = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

	private func addBackgroundViews(to containerView: UIView) {
		backgroundView.frame = containerView.frame
		backgroundView.alpha = transition == .present ? 0 : 1
		containerView.addSubview(backgroundView)
		containerView.addSubview(blurredStatusBar)
		blurredStatusBar.snp.makeConstraints { make in
			make.top.left.right.equalTo(containerView)
			make.height.equalTo(UIApplication.statusBarHeight)
		}
	}
}

extension CardTransitionManager: UIViewControllerAnimatedTransitioning {
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		transitionDuration
	}

	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let containerView = transitionContext.containerView
		containerView.subviews.forEach { $0.removeFromSuperview() }

		guard
			let fromView = transitionContext.viewController(forKey: .from),
			let toView = transitionContext.viewController(forKey: .to)
		else {
			transitionContext.completeTransition(false)
			return
		}

		guard let cardView = transition == .present
			? ((fromView as? MainTabBarController)?
				.selectedViewController as? DiscoverViewController)?
				.selectedCardView
			: ((toView as? MainTabBarController)?
				.selectedViewController as? DiscoverViewController)?
				.selectedCardView
		else {
			transitionContext.completeTransition(false)
			return
		}

		addBackgroundViews(to: containerView)

		performAnimation(fromView: fromView, toView: toView, cardView: cardView, in: containerView, using: transitionContext)
	}

	private func performAnimation(fromView: UIViewController, toView: UIViewController, cardView: CardView, in containerView: UIView, using transitionContext: UIViewControllerContextTransitioning) {
		let cardViewCopy = cardView.viewCopy()
		containerView.addSubview(cardViewCopy)
		cardView.isHidden = true
		let cardFrame = cardView.convert(cardView.frame, to: nil)
		cardViewCopy.frame = cardFrame

		containerView.bringSubviewToFront(blurredStatusBar)

		if transition == .present {
			guard
				let detailView = (toView as? UINavigationController)?
					.viewControllers
					.first as? CardDetailViewController
			else {
				transitionContext.completeTransition(false)
				return
			}

			toView.view.layoutIfNeeded()
			let detailViewCardView = detailView.cardView

			containerView.addSubview(toView.view)
			detailView.view.isHidden = true
			moveAndConvertToCardView(
				cardView: cardViewCopy,
				containerView: containerView,
				yOrigin: detailViewCardView.frame.origin.y,
				height: detailViewCardView.frame.height
			) {
				detailView.view.isHidden = false
				cardView.isHidden = false
				transitionContext.completeTransition(true)
			}
		} else {
			guard
				let detailView = (fromView as? UINavigationController)?
					.viewControllers
					.first as? CardDetailViewController
			else {
				transitionContext.completeTransition(false)
				return
			}

			cardViewCopy.setFullMode()
			cardViewCopy.frame = detailView.cardView.frame

			moveAndConvertToCardView(
				cardView: cardViewCopy,
				containerView: containerView,
				yOrigin: cardFrame.origin.y,
				height: cardFrame.height) {
				cardView.isHidden = false
				transitionContext.completeTransition(true)
			}
		}
	}

	private func makeShrinkAnimator(for cardView: CardView) -> UIViewPropertyAnimator {
		return UIViewPropertyAnimator(duration: shrinkDuration, curve: .easeOut) {
			if self.transition == .present {
				cardView.transform = .init(scaleX: 0.95, y: 0.95)
				self.backgroundView.alpha = 1.0
			}
		}
	}

	private func makeExpandContractAnimator(for cardView: CardView, in containerView: UIView, yOrigin: CGFloat, height: CGFloat) -> UIViewPropertyAnimator {
		let springTiming = UISpringTimingParameters(dampingRatio: 0.75, initialVelocity: CGVector(dx: 0, dy: 4))
		let animator = UIViewPropertyAnimator(duration: transitionDuration - shrinkDuration, timingParameters: springTiming)
		animator.addAnimations {
			cardView.transform = .identity
			self.transition == .present ? cardView.setFullMode() : cardView.setCardMode()
			cardView.frame = self.transition == .present
				? CGRect(x: 0, y: yOrigin, width: UIScreen.main.bounds.width, height: height)
				: CGRect(x: 20, y: yOrigin, width: UIScreen.main.bounds.width - 40, height: height)
			if self.transition == .dismiss {
				self.backgroundView.alpha = 0.0
			}
		}
		return animator
	}

	private func moveAndConvertToCardView(cardView: CardView, containerView: UIView, yOrigin: CGFloat, height: CGFloat, completion: @escaping () -> Void) {
		let shrinkAnimator = makeShrinkAnimator(for: cardView)
		let expandContractAnimator = makeExpandContractAnimator(
			for: cardView,
			in: containerView,
			yOrigin: yOrigin,
			height: height
		)

		shrinkAnimator.addCompletion { _ in
			expandContractAnimator.startAnimation()
		}
		expandContractAnimator.addCompletion { _ in
			completion()
		}

		shrinkAnimator.startAnimation()
	}
}

extension CardTransitionManager: UIViewControllerTransitioningDelegate {
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition = .present
		return self
	}

	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition = .dismiss
		return self
	}
}
