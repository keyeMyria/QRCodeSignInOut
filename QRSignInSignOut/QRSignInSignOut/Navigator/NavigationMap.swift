//
//  NavigationMap.swift
//  QRSignInSignOut
//
//  Created by Kun Lu on 9/22/18.
//  Copyright © 2018 Kun Lu. All rights reserved.
//

import Foundation
import SafariServices
import URLNavigator
//public typealias ViewModelFactory<T> = (_ onGetViewModel: @escaping (_ viewModel: T ) -> Void) -> Void

public typealias ViewModelFactory = (_ then: @escaping (_ viewModel: Any ) -> Void) -> Void
struct NavigationMap {

	static func urlString(withPatter pattern: String) -> String {
		let appURLScheme = "littlestar://"
		return appURLScheme + pattern
	}

	static func initialize(navigator: NavigatorType) {
		let studentDetailURLString = urlString(withPatter: "student/<int:hash>")
		navigator.register(studentDetailURLString) { url, values, context in
			guard let hash = values["hash"] as? Int else { return nil }

			return EditStudentViewController(viewModelFactory: { ( then: @escaping (Any) -> Void) in

				DataManager.shared.student?.fetchRecord(by: { (student) -> Bool in
					return student.hashValue == hash
				}, completion: { (res: Result<Student>) in
					if let student = res.value {
						let vm = EditStudentViewController.ViewModel(student: student)
						then(vm)
					}
				})
			})
		}

		navigator.register("http://<path:_>", self.webViewControllerFactory)
		navigator.register("https://<path:_>", self.webViewControllerFactory)

		navigator.handle("navigator://alert", self.alert(navigator: navigator))
		//    navigator.handle("navigator://<path:_>") { (url, values, context) -> Bool in
		//      // No navigator match, do analytics or fallback function here
		//      print("[Navigator] NavigationMap.\(#function):\(#line) - global fallback function is called")
		//      return true
		//    }
	}

	private static func webViewControllerFactory(
		url: URLConvertible,
		values: [String: Any],
		context: Any?
		) -> UIViewController? {
		guard let url = url.urlValue else { return nil }
		return SFSafariViewController(url: url)
	}

	private static func alert(navigator: NavigatorType) -> URLOpenHandlerFactory {
		return { url, values, context in
			guard let title = url.queryParameters["title"] else { return false }
			let message = url.queryParameters["message"]
			let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
			alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
			navigator.present(alertController)
			return true
		}
	}
}
