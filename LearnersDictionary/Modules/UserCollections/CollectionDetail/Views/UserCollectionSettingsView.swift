//
//  UserCollectionSettingsView.swift
//  LearnersDictionary
//
//  Created by Robert Mukhtarov on 24.05.2021.
//

import UIKit

protocol UserCollectionSettingsViewDelegate: AnyObject {
	func didChangeTitle(to newTitle: String)
	func didSelectColor(_ color: UserCollectionColor)
}

class UserCollectionSettingsView: UIView {
	private let titleTextField = UITextField()
	private let colors = UserCollectionColor.allCases
	private let colorsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

	var delegate: UserCollectionSettingsViewDelegate?

	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setup() {
		backgroundColor = .background

		titleTextField.placeholder = "Title"
		titleTextField.delegate = self
		titleTextField.addTarget(self, action: #selector(textFieldTextChanged), for: .editingChanged)
		titleTextField.returnKeyType = .done

		let divider = UIView(frame: .zero)
		divider.backgroundColor = .divider
		let border = UIView(frame: .zero)
		border.backgroundColor = .divider

		setupCollectionView()

		addSubview(titleTextField)
		addSubview(divider)
		addSubview(colorsCollectionView)
		addSubview(border)

		titleTextField.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(10)
			make.right.equalToSuperview()
			make.left.equalToSuperview().offset(16)
		}
		divider.snp.makeConstraints { make in
			make.top.equalTo(titleTextField.snp.bottom).offset(10)
			make.right.equalToSuperview()
			make.left.equalToSuperview().offset(16)
			make.height.equalTo(0.5)
		}
		colorsCollectionView.snp.makeConstraints { make in
			make.top.equalTo(divider.snp.bottom).offset(10)
			make.right.equalToSuperview()
			make.left.equalToSuperview()
			make.height.equalTo(42)
		}
		border.snp.makeConstraints { make in
			make.top.equalTo(colorsCollectionView.snp.bottom).offset(10)
			make.left.right.equalToSuperview()
			make.height.equalTo(0.5)
		}
	}

	@objc private func textFieldTextChanged() {
		guard let text = titleTextField.text else { return }
		delegate?.didChangeTitle(to: text)
	}

	private func setupCollectionView() {
		colorsCollectionView.dataSource = self
		colorsCollectionView.delegate = self
		colorsCollectionView.backgroundColor = .clear
		colorsCollectionView.layer.masksToBounds = false
		colorsCollectionView.showsHorizontalScrollIndicator = false
		colorsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
		if let layout = colorsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
			layout.scrollDirection = .horizontal
			layout.itemSize = CGSize(width: 42, height: 42)
			layout.minimumLineSpacing = 20
		}
		colorsCollectionView.register(ColorSwatchCell.self, forCellWithReuseIdentifier: "ColorSwatchCell")
	}
}

extension UserCollectionSettingsView: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		colors.count
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorSwatchCell", for: indexPath) as? ColorSwatchCell else {
			fatalError("Could not dequeue cell")
		}
		cell.set(color: colors[indexPath.item])
		return cell
	}
}

extension UserCollectionSettingsView: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		guard
			let colorSwatchCell = cell as? ColorSwatchCell,
			let selectedItemIndex = collectionView.indexPathsForSelectedItems?.first?.item,
			indexPath.item == selectedItemIndex
		else {
			return
		}
		colorSwatchCell.select()
	}

	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		if let cell = collectionView.cellForItem(at: indexPath) as? ColorSwatchCell {
			cell.select()
			delegate?.didSelectColor(colors[indexPath.item])
		}
	}

	func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
		if let cell = collectionView.cellForItem(at: indexPath) as? ColorSwatchCell {
			cell.deselect()
		}
	}
}

extension UserCollectionSettingsView: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
