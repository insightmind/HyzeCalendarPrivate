//
//  HEKParam.swift
//  HyzeEventKit
//
//  Created by redfleet on 8/25/17.
//  Copyright © 2017 insightmind. All rights reserved.
//

import Foundation

protocol HEKParamProtocol: HEKProduceProtocol {
	
	var name: String { get set }
	var values: [HEKParamValue] { get set }
	
}

class HEKParam: HEKParamProtocol {
	
	
	var name: String
	var values: [HEKParamValue]
	
	func produce() -> String {
		if values.count == 1 {
			return values.first!.produce()
		} else {
			var string = ""
			for value in values {
				string += "\(value.produce()),"
			}
			string.removeLast()
			return string
		}
	}
	
	
	init(_ name: String, values: [HEKParamValue]) {
		self.name = name
		self.values = values
	}
	
}
