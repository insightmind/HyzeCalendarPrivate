//
//  dayMainButtonLabels.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/7/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class dayMainButtonLabels: UIStackView {
    


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func calculateHourLabelPosition(_ hour: CGFloat) -> [CGFloat]{
        
        let angle = (PI/12)*hour
        
        let x: CGFloat = (self.bounds.width/2)*cos(angle)
        let y: CGFloat = (self.bounds.height/2)*sin(angle)
        
        return [x,y]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.topLabel.frame = 
        self.topLabel.text = "DAY"
        self.addSubview(topLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
