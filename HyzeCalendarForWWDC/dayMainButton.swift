//
//  dayMainButton.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 1/31/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class dayMainButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.shadowOpacity = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
