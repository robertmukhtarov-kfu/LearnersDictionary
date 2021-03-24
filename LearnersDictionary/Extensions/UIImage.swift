//
//  UIImage.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 23.03.2021.
//

import UIKit

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
