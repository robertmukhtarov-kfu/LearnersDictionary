//
//  EntryViewController.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 08.03.2021.
//

import UIKit
import SnapKit

class EntryViewController: UIViewController, TrackedScrollViewProtocol {
	let entry: EntryModel
	weak var trackedScrollViewDelegate: TrackedScrollViewDelegate?

	private let scrollView: UIScrollView = {
		let scrollView = UIScrollView()
		scrollView.alwaysBounceVertical = true
		scrollView.contentInset = .init(top: 0, left: 20, bottom: 0, right: 20)
		return scrollView
	}()

	private let stackView: UIStackView = {
		let stackView = UIStackView()
		stackView.axis = .vertical
		stackView.spacing = 16
		return stackView
	}()

	init(entry: EntryModel) {
		self.entry = entry
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .background
		setup()
	}

	private func setup() {
		view.addSubview(scrollView)
		scrollView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(48)
			make.left.right.bottom.equalToSuperview()
		}
		scrollView.delegate = self
		scrollView.addSubview(stackView)
		stackView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(16)
			make.bottom.equalToSuperview().offset(-16)
			make.left.right.equalToSuperview()
			make.width.equalToSuperview().offset(-40)
		}
		stackView.addArrangedSubview(
			HeadwordView(
				headword: entry.headword,
				transcription: entry.transcription
			)
		)
		for definition in entry.definitions {
			stackView.addArrangedSubview(DefinitionView(definition: definition))
		}
	}
}

extension EntryViewController: UIScrollViewDelegate {
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let newOffset = scrollView.contentOffset.y
		trackedScrollViewDelegate?.didScroll(scrollView, to: newOffset)
	}
}
