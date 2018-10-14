//
//  Student.swift
//  QRSignInSignOut
//
//  Created by Kun Lu on 9/26/18.
//  Copyright © 2018 Kun Lu. All rights reserved.
//

import Foundation
import UIKit

enum Sex: String, Codable {
	case male
	case female
	case unknown

}


protocol ModelType: AnyObject {
	var id: String? { get }
	func makeID()
}

class Model: ModelType {
	public private(set) var id: String?
	func makeID() {
		if id == nil {
			self.id = UUID().uuidString
		}
	}
}

struct PersonName: Equatable {
	var first: String
	var last: String

	public static func == (lhs: PersonName, rhs: PersonName) -> Bool {
		return lhs.first == rhs.first && lhs.last == rhs.last
	}
}

class ParentContact {
	var name: String = ""
	//var mobile: String = ""
	var phones = [String]()
	var email: String = ""
	var relation = Relationship.other("unknown")
}

extension ParentContact {
	enum Relationship: CustomStringConvertible, Equatable {
		case father
		case mother
		case grandfather
		case grandmother
		case other(String)

		var description: String {
			switch self {
			case .father:
				return "Father"
			case .mother:
				return "Mother"
			case .grandfather:
				return "Grandfather"
			case .grandmother:
				return "Grandmother"
			case .other(let relative):
				return relative
			}
		}

		init(_ string: String) {
			if string == "Father" {
				self = .father
			} else if string == "Mother" {
				self = .mother
			} else if string == "Grandfather" {
				self = .grandfather
			} else if string == "Grandmother" {
				self = .grandmother
			} else {
				self = .other(string)
			}
		}

		static func == (lhs: Relationship, rhs: Relationship) -> Bool {
			return lhs.description == rhs.description
		}
	}
}

class Student: Model {
	var firstName: String
	var lastName: String
	var level: GradeLevel
	var pinCode: String = ""
	var sex: Sex = .unknown
	var contact = ParentContact()
	var image: UIImage?
	init(firstName first: String,
		 lastName last: String,
		 level: GradeLevel = .junior) {

		firstName = first
		lastName = last
		self.level = level
		super.init()
		createPin()
	}

	private func createPin() {
		pinCode = generateRandomNumber(4)
	}

	private func generateRandomNumber(_ numDigits: Int) -> String {
		var ret = "";
		for _ in 0..<numDigits {
			let randomNumber = arc4random_uniform(10)
			ret += String(randomNumber)
		}
		return ret
	}
}

extension Student {
	enum GradeLevel: String {
		case junior = "Junior"

		case first = "Level 1"

		case second = "Level 2"

		case third = "Level 3"

		case fourth = "Level 4"

		case fifth = "Level 5"

		case sixth = "Level 6"

		case seventh = "Level 7"

		case eighth = "Level 8"

		case advanced  = "AP" //advance placement
	}
}

extension Student: Hashable {
	public var hashValue: Int {

		let ret = (firstName + lastName + sex.rawValue + level.rawValue).hashValue
		print("hash: \(ret)")
		return ret
	}
}

extension Student: Equatable {}
func ==(lhs: Student, rhs: Student) -> Bool {
	return lhs.hashValue == rhs.hashValue
}
