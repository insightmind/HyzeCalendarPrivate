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
    var isEvent = false
    var animatedState: EventAnimationType = .load
	
    var shapeLayer = CAShapeLayer()

	//TODO: fix layout and center issues
    override func draw(_ rect: CGRect) {
		
		coloring.setStroke()
		
		var radius = max(bounds.width, bounds.height)
		radius = radius/2 - radius/13
		let rect = CGRect(x: bounds.width/2 , y: bounds.height / 2 , width: radius * 2, height: radius * 2)
		shapeLayer.bounds = rect
		shapeLayer.frame = self.frame
        shapeLayer.path = UIBezierPath(ovalIn: rect).cgPath
		shapeLayer.strokeStart = calculateAngle(for: 0)
		shapeLayer.strokeEnd = calculateAngle(for: 0)
        shapeLayer.strokeColor = coloring.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = arcWidth
        if isEvent {
            shapeLayer.lineCap = kCALineCapRound
        }
        shapeLayer.opacity = 1
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func calculateAngle(for minute: CGFloat) -> CGFloat {
		
		var result = minute / 1440 + 0.75
		
		if result > 1 {
			result -= 1
		}
		
        return result
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
		
        switch animationType {
        case .select:
			let animation = CABasicAnimation(keyPath: "lineWidth")
			animation.duration = duration
			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.fromValue = arcWidth
            animation.toValue = arcWidth + 3.5
			animation.fillMode = kCAFillModeForwards
			animation.isRemovedOnCompletion = false
			shapeLayer.add(animation, forKey: "lineWidth")
            break
        case .deselect:
			let animation = CABasicAnimation(keyPath: "lineWidth")
			animation.duration = duration
			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.fromValue = arcWidth + 3.5
            animation.toValue = arcWidth
			animation.fillMode = kCAFillModeForwards
			animation.isRemovedOnCompletion = false
			shapeLayer.add(animation, forKey: "lineWidth")
            break
        case .add:
			let startAngle = calculateAngle(for: startTime)
			let endAngle = calculateAngle(for: endTime)
			
			let start = CABasicAnimation(keyPath: "strokeStart")
			start.toValue = startAngle
			
			let end = CABasicAnimation(keyPath: "strokeEnd")
			end.toValue = endAngle
			
			let group = CAAnimationGroup()
			group.animations = [start, end]
			group.duration = duration
			group.autoreverses = true
			group.repeatCount = HUGE
			shapeLayer.add(group, forKey: nil)
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
