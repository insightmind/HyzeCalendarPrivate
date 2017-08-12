//
//  dayViewDecoration.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/13/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class DayViewDecoration: UIView {

    var startInt: CGFloat = 0
    var endInt: CGFloat = 5
    var coloring = UIColor.clear
    var arcWidth: CGFloat = 10
    var inset: CGFloat = 20
    
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius: CGFloat = max(bounds.width - inset, bounds.height - inset)
     
        let startAngle: CGFloat = ((self.startInt * PI)/720) + ((3*PI)/2)
        let endAngle: CGFloat = ((self.endInt * PI)/720) + ((3*PI)/2)
        
        let path = UIBezierPath(arcCenter: center, radius: radius/2 - arcWidth/2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
     
        path.lineWidth = arcWidth
        coloring.setStroke()
        path.stroke()
    }

    func sendIntProperties(start: Int){
        startInt = CGFloat(start)
        endInt = startInt + 5
    }
    
    func sendColorProperties(_ color: UIColor){
        coloring = color
    }
    
    init(frame: CGRect, arc: CGFloat, inset with: CGFloat) {
        super.init(frame: frame)
        arcWidth = arc
        inset = with
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
