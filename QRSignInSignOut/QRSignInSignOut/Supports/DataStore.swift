//
//  DataStore.swift
//  QRSignInSignOut
//
//  Created by Kun Lu on 10/4/18.
//  Copyright © 2018 Kun Lu. All rights reserved.
//

import Foundation

class DataManager {
	static let shared = DataManager()

	fileprivate var stores = [String: Any]()

	private func initializeStores() {
		initializeStudentStore()
	}

	init() {
		initializeStores()
	}
}

/// Student Data Store
extension DataManager {
	fileprivate func initializeStudentStore() {
		stores["Student"] = DataStore<Student> { student in
			student.save(Student(firstName: "Leo", lastName: "Lu"), completion: { (res: Result<Student>) in
				if let student = res.value {
					student.createPin()
				}
			})
			student.save(Student(firstName: "Lillian", lastName: "Lu"), completion: { (res: Result<Student>) in
				if let student = res.value {
					student.createPin()
				}
			})
		}
	}

	var student: DataStore<Student>? {
		guard let ret = stores["Student"] as? DataStore<Student> else { return nil }
		return ret
	}
}


class DataStore <T: ModelType> {
	private var allData = [T]()

	init(_ initializer: (DataStore<T>) -> Void = {_ in }) {
		initializer(self)
	}

	typealias RecordFilter = (T) throws -> Bool

	func fetchRecord(by filter: RecordFilter,
				completion handler: ((Result<T>) -> Void)? = nil) rethrows  {
		guard let ret = try allData.filter(filter).first else {
			if let handler = handler {
				handler(Result.failure(DataError.recordNotFound))
			}
			return
		}

		if let handler = handler {
			handler(Result.success(ret))
		}
	}

	func save(_ record: T, completion: ((Result<T>) -> Void)? = nil) {
		if record.id == nil {
			record.makeID()
			allData.append(record)
		}

		if let hander = completion {
			hander(Result.success(record))
		}
		// existing records get saved automatially
	}

	func allItems() -> [T] {
		return allData
	}

}

