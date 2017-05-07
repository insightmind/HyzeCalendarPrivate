//
//  Event.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 2/4/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

enum EventAnimationType {
    case select, deselect, add, delete, load, reload, magic
}

class EventView: UIButton {

    var startTime: CGFloat = 0
    var endTime: CGFloat = 2 * PI
    var coloring: UIColor = UIColor.green
    var arcWidth: CGFloat = 25
    var allowHourRotation: Bool = false
    var allowShadow = true
    var animatedState: EventAnimationType = .load
    
    var shapeLayer = CAShapeLayer()


    override func draw(_ rect: CGRect) {
        let tcenter = CGPoint(x: bounds.width/2, y: bounds.height/2)
        var radius = max(bounds.width, bounds.height)
        radius = radius/2 - radius/13
        
        let startAngle = calculateAngle(for: startTime)
        let endAngle = calculateAngle(for: endTime)
        

        
        let path = UIBezierPath(arcCenter: tcenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        path.usesEvenOddFillRule = true
        path.lineWidth = arcWidth
        coloring.setStroke()
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = coloring.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = path.lineWidth
        shapeLayer.position = CGPoint(x: 0, y: 0)
        shapeLayer.opacity = 1
        
        self.layer.addSublayer(shapeLayer)
        

        
        
    }
    
    func calculateAngle(for minute: CGFloat) -> CGFloat {
        return ((minute * PI)/720) + ((3*PI)/2)
    }
    
    
    
    init(frame: CGRect = CGRect(), carcWidth: CGFloat , addShadow: Bool = false, hourRotation: Bool = false) {
        super.init(frame: frame)
        self.allowHourRotation = hourRotation
        arcWidth = carcWidth
        self.allowShadow = addShadow
        if allowShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowOpacity = 1
            self.layer.shadowRadius = 2
        }
    }

    
    func animate(_ animationType: EventAnimationType = .reload, duration: TimeInterval = 0.5) {
        
        let animation = CABasicAnimation(keyPath: "lineWidth")
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        switch animationType {
        case .select:
            animation.fromValue = arcWidth
            animation.toValue = arcWidth + 15.0
            break
        case .deselect:
            animation.fromValue = arcWidth + 15.0
            animation.toValue = arcWidth
            break
        case .add:
            break
        case .delete:
            break
        case .load:
            break
        case .reload:
            break
        case .magic:
            break
        }
	
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        shapeLayer.add(animation, forKey: "lineWidth")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sendTimeProperties(start: Int, end: Int){
        startTime = CGFloat(start)
        endTime = CGFloat(end)
    }
    
    func sendColorProperties(_ color: UIColor){
        coloring = color.withAlphaComponent(1)
    }
}
