//
//  StudentListViewController.swift
//  QRSignInSignOut
//
//  Created by Kun Lu on 9/26/18.
//  Copyright © 2018 Kun Lu. All rights reserved.
//

import Foundation
import URLNavigator
import UIKit

class StudentListViewController: UITableViewController {

	var viewModel = ViewModel()

//	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//		NotificationCenter.default.addObserver(self, selector: #selector(reloadStudents(_:)), name: .StudentDidAddNotification, object: nil)
//	}
//
//	required init?(coder aDecoder: NSCoder) {
//		super.init(coder: aDecoder)
//		NotificationCenter.default.addObserver(self, selector: #selector(reloadStudents(_:)), name: .StudentDidAddNotification, object: nil)
//	}
//
//	deinit {
//		NotificationCenter.default.removeObserver(self)
//	}
//
//	private func reloadViewModel() {
//		let students = DataManager.shared.student?.allItems() ?? [Student]()
//		viewModel = ViewModel(students: students)
//	}

//	@objc private func reloadStudents(_ notification: Notification) {
//		reloadViewModel()
//	}

	override func viewDidLoad() {
		/// Selector syntax sugar is cool 👍
		self.navigationItem.rightBarButtonItem?.action = .addButtonPressed
		self.navigationItem.rightBarButtonItem?.target = self

		let students = DataManager.shared.student?.allItems() ?? [Student]()
		viewModel = ViewModel(students: students)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

	// MARK: - actions
	@objc fileprivate func addButtonPressed(_ sender: UIBarButtonItem) {
		let urlString = NavigationMap.urlString(withPatter: "student/create")
		navigator.push(urlString)
	}
}
extension Selector {
	fileprivate static let addButtonPressed =
		#selector(StudentListViewController.addButtonPressed(_:))
}

// MARK: - UITableViewDataSource
extension StudentListViewController {

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewModel.numberOfStudents
	}

	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 60.0
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
	
		let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell",
												 for: indexPath)
		cell.textLabel?.text = viewModel.title(at: indexPath.row)
		cell.detailTextLabel?.text = viewModel.level(at: indexPath.row)
		cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
		return cell
	}
}

// MARK: - UITableViewDelegate
extension StudentListViewController {

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

		let urlString = viewModel.urlString(at: indexPath.row)
		let isPushed = navigator.push(urlString) != nil
		if isPushed {
			print("[Navigator] push: \(urlString)")
		} else {
			print("[Navigator] open: \(urlString)")
			navigator.open(urlString)
		}
	}
}
