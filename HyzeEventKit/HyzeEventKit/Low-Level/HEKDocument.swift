//
//  HEKDocument.swift
//  HyzeEventKit
//
//  Created by redfleet on 8/25/17.
//  Copyright © 2017 insightmind. All rights reserved.
//

import Foundation

protocol HEKDocumentProtocol {
	
	var type: HEKComponents { get }
	
	var contentLines: [HEKContentLine] { get set }
	
}

class HEKDocument: HEKDocumentProtocol {
	
	
	var contentLines: [HEKContentLine]
	
	var type: HEKComponents
	
	init(_ type: HEKComponents, contentLines: [HEKContentLine]) {
		self.type = type
		self.contentLines = contentLines
	}
	
	
}
