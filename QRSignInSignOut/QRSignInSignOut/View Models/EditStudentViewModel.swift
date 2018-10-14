//
//  EditStudentViewModel.swift
//  QRSignInSignOut
//
//  Created by Kun Lu on 10/6/18.
//  Copyright © 2018 Kun Lu. All rights reserved.
//

import Foundation
import UIKit
extension EditStudentViewController {
	class ViewModel {
		private var student: Student


		var first: String? {
			get {
				return student.firstName
			}
			set {
				student.firstName = newValue ?? ""
			}
		}

		var last: String? {
			get {
				return student.lastName
			}
			set {
				student.lastName = newValue ?? ""
			}
		}

		var gender: Sex {
			get { return student.sex }
			set { student.sex = newValue }
		}

		var level: String {
			get {
				return student.level.rawValue
			}
			set {
				student.level = Student.GradeLevel(rawValue: newValue) ?? .junior
			}
		}

		let levelOptions: [String] = [Student.GradeLevel.junior.rawValue,
									  Student.GradeLevel.first.rawValue,
									  Student.GradeLevel.second.rawValue,
									  Student.GradeLevel.third.rawValue,
									  Student.GradeLevel.fourth.rawValue,
									  Student.GradeLevel.fifth.rawValue,
									  Student.GradeLevel.sixth.rawValue,
									  Student.GradeLevel.seventh.rawValue,
									  Student.GradeLevel.eighth.rawValue,
									  Student.GradeLevel.advanced.rawValue]
		/// Photo
		var image: UIImage? {
			get {
				return student.image
			}
			set {
				student.image = newValue
			}
		}
		/// parent contacts
		var contactName: String {
			get {
				return student.contact.name
			}
			set {
				student.contact.name = newValue
			}
		}

		var contactRelation: ParentContact.Relationship {
			get {
				return student.contact.relation
			}
			set {
				student.contact.relation = newValue
			}
		}

		var contactEmail: String {
			get {
				return student.contact.email
			}
			set {
				student.contact.email = newValue
			}
		}

		var contactPhone: String {
			get {
				guard let phone = student.contact.phones.first else { return "" }

				return phone
			}
			set {
				if student.contact.phones.count <= 1 {
					student.contact.phones = [newValue]
				} else {
					let array = student.contact.phones[1...(student.contact.phones.count-1)]
					student.contact.phones = [newValue] + array
				}
			}
		}

		init(student: Student) {
			self.student =  student
		}

	}
}
