//
//  UIViewExtension.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/15/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
	
	func setGradientBackground(colors: [CGColor], locations: [NSNumber], startPosition: CGPoint = CGPoint(x: 0.0, y: 0.0), endPosition: CGPoint = CGPoint(x: 1.0, y: 1.0)) {
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = bounds.insetBy(dx: -2, dy: -2)
		gradientLayer.colors = colors
		gradientLayer.locations = locations
		gradientLayer.startPoint = startPosition
		gradientLayer.endPoint = endPosition
		
		self.layer.insertSublayer(gradientLayer, at: 0)
	}
	
	func setShadow(path: CGPath, color: CGColor = UIColor.black.cgColor, opacity: Float = 0.8, radius: CGFloat = 3, offset: CGSize = CGSize.zero) {
		
		layer.shadowPath = path
		layer.shadowColor = color
		layer.shadowOpacity = opacity
		layer.shadowRadius = radius
		layer.shadowOffset = offset
		
	}
}
