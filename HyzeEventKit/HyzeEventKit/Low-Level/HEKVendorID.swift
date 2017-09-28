//
//  HEKVendorID.swift
//  HyzeEventKit
//
//  Created by redfleet on 8/25/17.
//  Copyright © 2017 insightmind. All rights reserved.
//

import Foundation

protocol HEKVendorIDProtocol: HEKProduceProtocol {
	
	var name: String { get }

}

class HEKVendorID: HEKVendorIDProtocol {
	
	var name: String
	
	func produce() -> String {
		return name
	}
	
	init(_ name: String) {
		self.name = name
	}
	
}
