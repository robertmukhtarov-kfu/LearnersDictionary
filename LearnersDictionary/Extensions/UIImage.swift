//
//  UIImage.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 23.03.2021.
//

import UIKit

// MARK: - Text recognition preparation

extension UIImage {
	public func redrawnWithCorrectOrientation() -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(size, false, scale)
		defer { UIGraphicsEndImageContext() }
		draw(in: CGRect(origin: .zero, size: size))
		return UIGraphicsGetImageFromCurrentImageContext()?.data.flatMap(UIImage.init)
	}

	private var data: Data? {
		return pngData() ?? jpegData(compressionQuality: 0.85)
	}
}

// MARK: - Static variables

extension UIImage {
	static var discover: UIImage? {
		UIImage(named: "discover")
	}

	static var collections: UIImage? {
		UIImage(named: "collections")
	}

	static var cameraFill: UIImage? {
		UIImage(named: "camera.fill")
	}

	static var addCollectionNavBar: UIImage? {
		UIImage(named: "addCollectionNavBar")
	}

	static var pronounce: UIImage? {
		UIImage(named: "pronounce")
	}

	static var addToCollections: UIImage? {
		UIImage(named: "addToCollections")
	}

	static var xMark: UIImage? {
		UIImage(named: "xmark")
	}

	static var accountNavBar: UIImage? {
		UIImage(named: "accountNavBar")
	}
}
