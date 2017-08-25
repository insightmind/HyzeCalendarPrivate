//
//  HEKContentLine.swift
//  HyzeEventKit
//
//  Created by redfleet on 8/25/17.
//  Copyright © 2017 insightmind. All rights reserved.
//

import Foundation

protocol HEKContentLineProtocol: HEKProduceProtocol  {
	
	var name: HEKName { get }
	var params: [HEKParam] { get set }
	var value: String { get set }

}

class HEKContentLine: HEKContentLineProtocol {
	
	var name: HEKName
	var params: [HEKParam]
	var value: String
	
	func produce() -> String {
		var paramString: String = ""
		for param in params {
			paramString += param.produce()
		}
		let line = "\(name.produce)\(paramString):\(value)"
		return line
	}
	
	init(_ name: HEKName, params: [HEKParam], value: String) {
		self.name = name
		self.params = params
		self.value = value
	}
	
	
}
