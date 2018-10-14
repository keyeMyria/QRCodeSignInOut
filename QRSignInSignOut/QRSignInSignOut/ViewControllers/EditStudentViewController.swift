//
//  EditStudentViewController.swift
//  QRSignInSignOut
//
//  Created by Kun Lu on 10/6/18.
//  Copyright © 2018 Kun Lu. All rights reserved.
//

import UIKit
import Eureka
import ImageRow
class EditStudentViewController: FormViewController {
	var viewModel: ViewModel?
	var vmFactory: ViewModelFactory

	init(viewModelFactory: @escaping ViewModelFactory) {
		self.vmFactory = viewModelFactory
		super.init(nibName: nil, bundle: nil)
	}

//	public protocol RowType: TypedRowType {
//		init(_ tag: String?, _ initializer: (Self) -> Void)
//	}
//
//	extension RowType where Self: BaseRow {
//
//		/**
//		Default initializer for a row
//		*/
//		public init(_ tag: String? = nil, _ initializer: (Self) -> Void = { _ in }) {
//			self.init(tag: tag)
//			RowDefaults.rowInitialization["\(type(of: self))"]?(self)
//			initializer(self)
//		}
//	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		ImageRow.defaultCellUpdate = { cell, row in
			cell.accessoryView?.layer.cornerRadius = 36
			cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 72, height: 72)
		}

		// Enables the navigation accessory and stops navigation when a disabled row is encountered
		navigationOptions = RowNavigationOptions.Enabled.union(.StopDisabledRow)
		// Enables smooth scrolling on navigation to off-screen rows
		animateScroll = true
		// Leaves 20pt of space between the keyboard and the highlighted row after scrolling to an off screen row
		rowKeyboardSpacing = 20
		
		vmFactory { vm in
			if let vm = vm as? ViewModel {
				self.viewModel = vm
				self.buildForm(vm)
			}
		}

	}

	private func buildForm(_ viewModel: ViewModel) {
		form
			// MARK: Students
			+++ Section()
			<<< TextRow() {
				$0.title = "First"
				$0.placeholder = "Enter first name here"
				$0.value = viewModel.first
				$0.onChange { row in
					viewModel.first = row.value
				}
				$0.add(rule: RuleRequired()) //1
				$0.validationOptions = .validatesOnChange //2
				$0.cellUpdate { (cell, row) in //3
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
				}
			}

			<<< TextRow() {
				$0.title = "Last"
				$0.placeholder = "Enter last name here"
				$0.value = viewModel.last
				$0.onChange { row in
					viewModel.last = row.value
				}
				$0.add(rule: RuleRequired()) //1
				$0.validationOptions = .validatesOnChange //2
				$0.cellUpdate { (cell, row) in //3
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
				}
			}
			<<< PickerInlineRow<Sex>("Gender") { (row : PickerInlineRow<Sex>) -> Void in
				row.title = row.tag
				row.displayValueFor = { (rowValue: Sex?) in
					return rowValue.map { $0.rawValue }
				}
				row.options = [Sex.male, Sex.female, Sex.unknown]
				row.value = viewModel.gender
				row.onChange { row in
					viewModel.gender = row.value ?? .unknown
				}
			}

			<<< PushRow<String>() { //1
				$0.title = "Level" //2
				$0.value = viewModel.level //3
				$0.options = viewModel.levelOptions //4
				$0.onChange { row in //5
					if let value = row.value {
						viewModel.level = value
					}
				}
			}
			// MARK: Contacts
			+++ Section("Parents/Contacts")
			<<< NameRow() {
				$0.title = "Name"
				$0.placeholder = "First Last"
				$0.value = viewModel.contactName
				$0.onChange { row in
					if let value = row.value {
						viewModel.contactName = value
					}
				}
			}

			<<< PickerInlineRow<ParentContact.Relationship>("Relation") { (row : PickerInlineRow<ParentContact.Relationship>) -> Void in
				row.title = row.tag
				row.displayValueFor = { (rowValue: ParentContact.Relationship?) in
					return rowValue.map { $0.description }
				}
				row.options = [ParentContact.Relationship.father,
							   ParentContact.Relationship.mother,
							   ParentContact.Relationship.grandfather,
							   ParentContact.Relationship.grandmother]
				row.value = viewModel.contactRelation
				row.onChange { row in
					viewModel.contactRelation = row.value ?? .other("")
				}
			}

			<<< EmailRow() {
					$0.title = "Email"
					$0.value = viewModel.contactEmail
//					$0.add(rule: RuleRequired())
					$0.add(rule: RuleEmail())
					$0.validationOptions = .validatesOnChangeAfterBlurred
					$0.onChange { row in
						if let value = row.value {
							viewModel.contactEmail = value
						}
					}
				}
				.cellUpdate { cell, row in
					if !row.isValid {
						cell.titleLabel?.textColor = .red
					}
				}
				.onRowValidationChanged { cell, row in
					let rowIndex = row.indexPath!.row
					while row.section!.count > rowIndex + 1 && row.section?[rowIndex  + 1] is LabelRow {
						row.section?.remove(at: rowIndex + 1)
					}
					if !row.isValid {
						for (index, validationMsg) in row.validationErrors.map({ $0.msg }).enumerated() {
							let labelRow = LabelRow() {
								$0.title = validationMsg
								$0.cell.height = { 30 }
							}
							row.section?.insert(labelRow, at: row.indexPath!.row + index + 1)
						}
					}
				}

			<<< PhoneRow() {
				$0.title = "Mobile Phone Number"
				$0.value = viewModel.contactPhone
				$0.onChange({ (row) in
					if let value = row.value {
						viewModel.contactPhone = value
					}
				})
			}

			+++ ImageRow() {
				$0.title = "Photo"
				$0.value = viewModel.image
				$0.onChange({ (row) in
					viewModel.image = row.value
				})
		}
	}
}
