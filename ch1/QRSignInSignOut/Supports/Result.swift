//
//  Result.swift
//  QRSignInSignOut
//
//  Created by Kun Lu on 10/12/18.
//  Copyright © 2018 Kun Lu. All rights reserved.
//

import Foundation

enum DataError: Error {
	case recordNotFound
}

enum Result<T> {
	case success(T)
	case failure(Error)

	var value: T? {
		switch self {
		case .success(let value):
			return value

		case .failure:
			return nil
		}
	}

	func map<R>(_ selector: (T) throws -> R) rethrows -> Result<R> {
		switch self {
		case let .success(value):
			return .success(try selector(value))

		case let .failure(error):
			return .failure(error)
		}
	}

	func flatMap<R>(_ selector: (T) throws -> Result<R>) rethrows -> Result<R> {
		switch self {
		case let .success(value):
			return try selector(value)

		case let .failure(error):
			return .failure(error)
		}
	}

	func apply(_ f: (Result<T>) throws -> Void) rethrows -> Void {
		try f(self)
	}
}
