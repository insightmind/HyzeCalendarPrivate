//
//  dayMainButton.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 1/31/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class DayMainButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
	
	override func layoutSubviews() {
		let path = UIBezierPath(ovalIn: self.bounds).cgPath
		self.setShadow(path: path, color: self.backgroundColor?.cgColor ?? UIColor.black.cgColor, opacity: 0.5, radius: 10, offset: CGSize(width: 3.0, height: 10.0))
	}
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
