//
//  ImageScrollView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 25.03.2021.
//

import UIKit

class ImageScrollView: UIScrollView {
	private let imageView: UIImageView

	init(frame: CGRect, imageView: UIImageView) {
		self.imageView = imageView
		super.init(frame: frame)
		setupView()
		setupImageView()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupView() {
		delegate = self
		showsVerticalScrollIndicator = false
		showsHorizontalScrollIndicator = false
		decelerationRate = .fast
	}

	private func setupImageView() {
		addSubview(imageView)
		contentSize = imageView.image?.size ?? CGSize()
		setZoomScale()
		centerImage()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		centerImage()
	}

	private func setZoomScale() {
		let boundsSize = bounds.size
		let imageSize = imageView.bounds.size

		let xScale = boundsSize.width / imageSize.width
		let yScale = boundsSize.height / imageSize.height
		let minScale = min(xScale, yScale)

		let maxScale: CGFloat
		switch minScale {
		case ..<0.1:
			maxScale = 0.3
		case 0.1..<0.5:
			maxScale = 0.7
		case 0.5...:
			maxScale = max(1.0, minScale)
		default:
			maxScale = 1.0
		}

		minimumZoomScale = minScale
		zoomScale = minimumZoomScale
		maximumZoomScale = maxScale
	}

	private func centerImage() {
		imageView.frame.origin.x = imageView.frame.size.width < bounds.size.width ?
			(bounds.size.width - imageView.frame.size.width) / 2 : 0
		imageView.frame.origin.y = imageView.frame.size.height < bounds.size.height ?
			(bounds.size.height - imageView.frame.size.height) / 2 : 0
	}
}

extension ImageScrollView: UIScrollViewDelegate {
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		imageView
	}

	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		centerImage()
	}
}
