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
    var coloring: UIColor = Color.white
    var arcWidth: CGFloat = 25
    var allowHourRotation: Bool = false
    var isEvent = false
	var drawLayer = 0
	var isFullDay = false
    var animatedState: EventAnimationType = .load
	let eventIdentifier: String!
	
    var shapeLayer = CAShapeLayer()

    override func draw(_ rect: CGRect) {
		
		let tcenter = CGPoint(x: bounds.width/2, y: bounds.height/2)
		var radius = max(bounds.width, bounds.height)
		if isEvent {
			radius = 1
		} else {
			radius = radius/2 - radius/17 + (9 * CGFloat(drawLayer))
		}
		
		let startAngle = calculateAngle(for: startTime)
		let endAngle = calculateAngle(for: endTime)
		
		
		
		let path = UIBezierPath(arcCenter: tcenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
		
		path.usesEvenOddFillRule = true
		path.lineWidth = arcWidth
		coloring.setStroke()
		
		shapeLayer.path = path.cgPath
		if isEvent {
			shapeLayer.strokeColor = coloring.cgColor
			shapeLayer.fillColor = UIColor.clear.cgColor
			shapeLayer.opacity = 0
			shapeLayer.lineCap = kCALineCapRound
		} else {
			shapeLayer.strokeColor = coloring.cgColor
			shapeLayer.fillColor = coloring.cgColor
			shapeLayer.opacity = 1
		}
		
		shapeLayer.lineWidth = path.lineWidth
		shapeLayer.position = CGPoint(x: 0, y: 0)
		
		self.layer.addSublayer(shapeLayer)

    }
    
    func calculateAngle(for minute: CGFloat) -> CGFloat {
		
		return ((minute * PI)/720) + ((3*PI)/2)

    }
    
	init(frame: CGRect = CGRect(), carcWidth: CGFloat, hourRotation: Bool = false, eventIdentifier: String! = "") {
		self.eventIdentifier = eventIdentifier
        super.init(frame: frame)
        self.allowHourRotation = hourRotation
        arcWidth = carcWidth
    }

	func animate(_ animationType: EventAnimationType = .reload, duration: TimeInterval = 0.5, delay: TimeInterval = 0) {
		
        switch animationType {
        case .select:
			
			let animation = CABasicAnimation(keyPath: "lineWidth")
			animation.duration = duration
			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
			animation.fromValue = arcWidth
            animation.toValue = (arcWidth + 3.5)
			animation.fillMode = kCAFillModeForwards
			animation.isRemovedOnCompletion = false
			shapeLayer.add(animation, forKey: "lineWidth")
			
        case .deselect:
	
			let animation = CABasicAnimation(keyPath: "lineWidth")
			animation.duration = duration
			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
			animation.fromValue = (arcWidth + 3.5)
            animation.toValue = arcWidth
			animation.fillMode = kCAFillModeForwards
			animation.isRemovedOnCompletion = false
			shapeLayer.add(animation, forKey: "lineWidth")
			
        case .add:
			
			let pathAnim = CABasicAnimation(keyPath: "path")
			let tcenter = CGPoint(x: bounds.width/2, y: bounds.height/2)
			var radius = max(bounds.width, bounds.height)
			radius = radius/2 - radius/17 + (9 * CGFloat(drawLayer))
			
			let startAngle = calculateAngle(for: startTime)
			let endAngle = calculateAngle(for: endTime)
			
			let path = UIBezierPath(arcCenter: tcenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
			
			path.usesEvenOddFillRule = true
			path.lineWidth = arcWidth
			
			pathAnim.toValue = path.cgPath
			
			let opacity = CABasicAnimation(keyPath: "opacity")
			opacity.toValue = 1
			
			let group = CAAnimationGroup()
			group.beginTime = CACurrentMediaTime() + delay
			group.animations = [pathAnim, opacity]
			group.duration = duration
			group.fillMode = kCAFillModeForwards
			group.isRemovedOnCompletion = false
			group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			shapeLayer.add(group, forKey: nil)
			
        case .delete:
			
			let pathAnim = CABasicAnimation(keyPath: "path")
			let tcenter = CGPoint(x: bounds.width/2, y: bounds.height/2)
			var radius = max(bounds.width, bounds.height)
			radius = 1
			
			let startAngle = calculateAngle(for: startTime)
			let endAngle = calculateAngle(for: endTime)
			
			let path = UIBezierPath(arcCenter: tcenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
			
			path.usesEvenOddFillRule = true
			path.lineWidth = arcWidth
			
			pathAnim.toValue = path.cgPath
			
			let opacity = CABasicAnimation(keyPath: "opacity")
			opacity.toValue = 0
			
			let group = CAAnimationGroup()
			group.beginTime = CACurrentMediaTime() + delay
			group.animations = [pathAnim, opacity]
			group.duration = duration
			group.fillMode = kCAFillModeRemoved
			group.isRemovedOnCompletion = false
			group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
			shapeLayer.add(group, forKey: nil)
			
			
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
