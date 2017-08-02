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
    var isEvent = false
	var drawLayer = 0
	var isFullDay = false
    var animatedState: EventAnimationType = .load
	let eventIdentifier: String!
	
    var shapeLayer = CAShapeLayer()

	//TODO: fix layout and center issues
    override func draw(_ rect: CGRect) {
		
		coloring.setStroke()
		let rect = CGRect(x: bounds.width/2 , y: bounds.height/2 , width: bounds.width, height: bounds.height)
		shapeLayer.transform = CATransform3DMakeScale(0.9 + (CGFloat(drawLayer) * 0.1), 0.9 + (CGFloat(drawLayer) * 0.1), 0)
		shapeLayer.bounds = rect
		shapeLayer.frame = self.frame
        shapeLayer.path = UIBezierPath(ovalIn: rect).cgPath
		
		if !isFullDay {
			shapeLayer.strokeStart = calculateAngle(for: 0)
			shapeLayer.strokeEnd = calculateAngle(for: 0)
			shapeLayer.opacity = 0
		}
		
		shapeLayer.strokeColor = coloring.cgColor
		shapeLayer.fillColor = UIColor.clear.cgColor
		if isEvent {
			shapeLayer.lineCap = kCALineCapRound
		}
		
		shapeLayer.lineWidth = arcWidth / (1 + (CGFloat(drawLayer) * 0.1))
        
        self.layer.addSublayer(shapeLayer)
		
		shapeLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    }
    
    func calculateAngle(for minute: CGFloat) -> CGFloat {
		
		var result = minute / 1440 + 0.75
		
		if result > 1 {
			result -= 1
		}
		
        return result
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
            animation.fromValue = arcWidth / (1 + (CGFloat(drawLayer) * 0.1))
            animation.toValue = (arcWidth + 3.5) / (1 + (CGFloat(drawLayer) * 0.1))
			animation.fillMode = kCAFillModeForwards
			animation.isRemovedOnCompletion = false
			shapeLayer.add(animation, forKey: "lineWidth")
            break
        case .deselect:
			let animation = CABasicAnimation(keyPath: "lineWidth")
			animation.duration = duration
			animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            animation.fromValue = (arcWidth + 3.5) / (1 + (CGFloat(drawLayer) * 0.1))
            animation.toValue = arcWidth / (1 + (CGFloat(drawLayer) * 0.1))
			animation.fillMode = kCAFillModeForwards
			animation.isRemovedOnCompletion = false
			shapeLayer.add(animation, forKey: "lineWidth")
            break
        case .add:
			if isFullDay {
				return
			}
			let startAngle = calculateAngle(for: startTime)
			let endAngle = calculateAngle(for: endTime)
			
			let start = CABasicAnimation(keyPath: "strokeStart")
			start.toValue = startAngle
			
			let end = CABasicAnimation(keyPath: "strokeEnd")
			end.toValue = endAngle
			
			let opacity = CABasicAnimation(keyPath: "opacity")
			opacity.toValue = 1
			
			let group = CAAnimationGroup()
			group.beginTime = CACurrentMediaTime() + delay
			group.animations = [start, end, opacity]
			group.duration = duration
			group.fillMode = kCAFillModeForwards
			group.isRemovedOnCompletion = false
			group.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
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
