//
//  HEKName.swift
//  HyzeEventKit
//
//  Created by redfleet on 8/25/17.
//  Copyright © 2017 insightmind. All rights reserved.
//

import Foundation

protocol HEKNameProtocol: HEKProduceProtocol {
	
	var name: String { get set }
	
	var isExperimental: Bool { get }
	var vendorID: HEKVendorID? { get set }
	
}

class HEKName: HEKNameProtocol {
	
	
	var name: String
	
	var isExperimental: Bool
	
	var vendorID: HEKVendorID?
	
	func produce() -> String {
		if isExperimental {
			return "X-\(vendorID!.produce())-\(name)"
		} else {
			return name
		}
	}
	
	init(_ name: String, isExperimental: Bool, vendorID: HEKVendorID? ) {
		self.name = name
		self.isExperimental = isExperimental
		self.vendorID = vendorID
	}
	
	
}
