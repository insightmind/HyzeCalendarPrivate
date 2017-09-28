//
//  HEKParamValue.swift
//  HyzeEventKit
//
//  Created by redfleet on 8/25/17.
//  Copyright © 2017 insightmind. All rights reserved.
//

import Foundation

protocol HEKParamValueProtocol: HEKProduceProtocol {
	
	var name: String { get }
	
	var isQuotedString: Bool { get }
	
}

class HEKParamValue: HEKParamValueProtocol {
	
	var name: String
	
	var isQuotedString: Bool
	
	func produce() -> String {
		if isQuotedString {
			return "\"\(name)\""
		} else {
			return "\(name)"
		}
	}
	
	init(_ name: String, isQuotedString: Bool) {
		self.name = name
		self.isQuotedString = isQuotedString
	}
	
}
