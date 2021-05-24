//
//  ColorSwatchView.swift
//  tableviewexperiments
//
//  Created by Robert Mukhtarov on 15.05.2021.
//

import UIKit

class ColorSwatchView: UIView {
	private let fillLayer = CAShapeLayer()
	private let cutoutLayer = CAShapeLayer()
	private let borderLayer = CAShapeLayer()

	init() {
		super.init(frame: .init(x: 0, y: 0, width: 40, height: 40))
		setup()
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func select() {
		cutoutLayer.opacity = 0
	}

	func deselect() {
		cutoutLayer.opacity = 1
	}

	func set(color: UserCollectionColor) {
		let cgColor = color.toUIColor().cgColor
		fillLayer.fillColor = cgColor
		borderLayer.strokeColor = cgColor
		cutoutLayer.strokeColor = cgColor
	}

	private func setup() {
		let fillPath = UIBezierPath(ovalIn: .init(x: 4, y: 4, width: 32, height: 32))
		fillLayer.fillColor = UIColor.systemBlue.cgColor
		fillLayer.path = fillPath.cgPath
		layer.addSublayer(fillLayer)

		let borderPath = UIBezierPath(ovalIn: .init(x: 0, y: 0, width: bounds.width, height: bounds.height))
		borderLayer.fillColor = .none
		borderLayer.lineWidth = 2
		borderLayer.strokeColor = UIColor.systemBlue.cgColor
		borderLayer.path = borderPath.cgPath
		layer.addSublayer(borderLayer)

		let cutoutPath = UIBezierPath(ovalIn: .init(x: 2, y: 2, width: 36, height: 36))
		cutoutLayer.lineWidth = 5
		cutoutLayer.fillColor = .none
		cutoutLayer.strokeColor = UIColor.systemBlue.cgColor
		cutoutLayer.path = cutoutPath.cgPath
		layer.addSublayer(cutoutLayer)
	}
}
