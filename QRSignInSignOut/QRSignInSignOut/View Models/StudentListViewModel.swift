//
//  StudentListViewModel.swift
//  QRSignInSignOut
//
//  Created by Kun Lu on 9/26/18.
//  Copyright © 2018 Kun Lu. All rights reserved.
//

import Foundation

extension StudentListViewController {
	class ViewModel {
		private var students: [Student]
		var numberOfStudents: Int {
			return students.count
		}



		init(students: [Student] = []) {
			self.students = students

			NotificationCenter
				.default
				.addObserver(self,
							 selector: .removeStudent,
							 name: .deleteStudentNotification,
							 object: nil)

			NotificationCenter
				.default
				.addObserver(self,
							 selector: .reloadStudents,
							 name: .StudentDidAddNotification,
							 object: nil)
		}

		deinit {
			NotificationCenter.default.removeObserver(self)
		}

		@objc fileprivate func reloadStudents(_ notfication: Notification) {
			students = DataManager.shared.student?.allItems() ?? [Student]()
		}

		private func student(at index: Int) -> Student? {
			let range = students.startIndex...students.endIndex
			guard range.contains(index) else { return nil }
			return students[index]
		}

		func urlString(at index: Int) -> String {
			guard let student = student(at: index) else { return "" }
			return NavigationMap.urlString(withPatter: "student/\(student.hashValue)")
		}

		func title(at index: Int) -> String {
			guard let student = student(at: index) else { return "" }

			return student.firstName + " " + student.lastName
		}

		func level(at index: Int) -> String {
			guard let student = student(at: index) else { return "" }

			return student.level.rawValue
		}

		// MARK: - Actions
		@objc fileprivate func removeStudent(_ notification: Notification) {
			guard let userInfo = notification.userInfo,
				let student = userInfo[Notification.Name.deleteStudentNotification] as? Student,
				let index = students.firstIndex(where: { $0 == student }) else {
					return
			}
			students.remove(at: index)
		}
	}

}

// MARK: - Selectors
extension Selector {
	fileprivate static let removeStudent = #selector(StudentListViewController.ViewModel.removeStudent(_:))
	fileprivate static let reloadStudents = #selector(StudentListViewController.ViewModel.reloadStudents(_:))
}
