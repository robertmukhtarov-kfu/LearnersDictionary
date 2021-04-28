//
//  TrackedScrollViewProtocol.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 26.04.2021.
//

import UIKit

protocol TrackedScrollViewProtocol: UIViewController {
	var trackedScrollViewDelegate: TrackedScrollViewDelegate? { get set }
}

protocol TrackedScrollViewDelegate: AnyObject {
	func didScroll(_ scrollView: UIScrollView, to newPointY: CGFloat)
}
