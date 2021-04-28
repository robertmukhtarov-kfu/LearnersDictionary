//
//  EntryPageViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 08.03.2021.
//

import UIKit

class EntryPageViewController: UIPageViewController, TrackedScrollViewProtocol {
	var presenter: EntryPageViewPresenterProtocol?
	private var toolbar = EntryToolbar()
	private var selectedIndex = 0
	private var pages: [EntryViewController] = []
	weak var trackedScrollViewDelegate: TrackedScrollViewDelegate?

	init() {
		super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .background
		navigationItem.largeTitleDisplayMode = .never
		navigationItem.rightBarButtonItem = UIBarButtonItem(
			image: UIImage(named: "addCollectionNavBar"),
			style: .plain,
			target: nil,
			action: nil
		)
		dataSource = self
		delegate = self
		setupToolbar()
		presenter?.viewDidLoad()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		hideNavbarShadow()
	}

	private func setupToolbar() {
		view.addSubview(toolbar)
		toolbar.snp.makeConstraints { make in
			make.top.left.right.equalToSuperview()
			make.height.equalTo(48)
		}
		hideNavbarShadow()
		toolbar.segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
	}

	@objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
		let newIndex = sender.selectedSegmentIndex
		let direction: UIPageViewController.NavigationDirection = newIndex > selectedIndex ? .forward : .reverse
		selectedIndex = newIndex
		setViewControllers([pages[selectedIndex]], direction: direction, animated: true)
	}

	private func hideNavbarShadow() {
		navigationController?.navigationBar.shadowImage = UIImage()
	}
}

extension EntryPageViewController: EntryPageView {
	func set(title: String) {
		self.title = title
	}

	func configure(with entries: [EntryModel]) {
		var functionalLabels: [String] = []
		entries.forEach { entry in
			let entryViewController = EntryViewController(entry: entry)
			entryViewController.trackedScrollViewDelegate = self
			pages.append(entryViewController)
			functionalLabels.append(entry.functionalLabel.capitalized)
		}
		toolbar.configureSegmentedControl(with: functionalLabels)
		if let firstViewController = pages.first {
			setViewControllers([firstViewController], direction: .forward, animated: false)
		}
	}

	func reset() {
		toolbar.segmentedControl.removeAllSegments()
		pages = []
		setViewControllers([UIViewController()], direction: .forward, animated: false)
	}

	func showError(message: String) {
		showErrorAlert(message: message) {
			self.presenter?.errorOccurred()
		}
	}
}

extension EntryPageViewController: UIPageViewControllerDelegate {
	func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
		guard let viewController = pageViewController.viewControllers?.first as? EntryViewController else { return }
		guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return }
		selectedIndex = viewControllerIndex
		toolbar.segmentedControl.selectedSegmentIndex = selectedIndex
	}
}

extension EntryPageViewController: UIPageViewControllerDataSource {
	func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
		guard let viewController = viewController as? EntryViewController else { return nil }
		guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

		let previousIndex = viewControllerIndex - 1

		guard previousIndex >= 0 else {
			return nil
		}
		guard pages.count > previousIndex else {
			return nil
		}

		return pages[previousIndex]
	}

	func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
		guard let viewController = viewController as? EntryViewController else { return nil }
		guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }

		let nextIndex = viewControllerIndex + 1
		let viewControllersCount = pages.count

		guard viewControllersCount != nextIndex else {
			return nil
		}
		guard viewControllersCount > nextIndex else {
			return nil
		}

		return pages[nextIndex]
	}
}

extension EntryPageViewController: TrackedScrollViewDelegate {
	func didScroll(_ scrollView: UIScrollView, to newPointY: CGFloat) {
		trackedScrollViewDelegate?.didScroll(scrollView, to: newPointY)
	}
}
