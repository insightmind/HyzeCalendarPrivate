//
//  CalendarSectionReusableView.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 1/25/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class CalendarSectionReusableView: UICollectionReusableView {
    lazy var monthlabel: UILabel = {
        print("[INFORMATION] CalendarSectionReusableView.monthlabel initialized")
        let lbl = UILabel()
        lbl.textColor = UIColor.orange
        lbl.text = "MONTH"
        return lbl
    }()
    override func prepareForReuse() {
        self.willRemoveSubview(monthlabel)
        print("[INFORMATION] CalendarSectionReusableView.monthlabel removed")
    }
    
    override init(frame: CGRect) {
        print("[INFORMATION] CalendarSectionReusableView initialized")
        super.init(frame: frame)
        self.contentMode = .center
        self.monthlabel.frame = self.bounds
        self.monthlabel.textAlignment = .center
        self.backgroundColor = UIColor.clear
        
        self.monthlabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(monthlabel)
        let widthConstraint = NSLayoutConstraint(item: self.monthlabel, attribute: .width, relatedBy: .equal,
                                                 toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 250)
        
        let heightConstraint = NSLayoutConstraint(item: self.monthlabel, attribute: .height, relatedBy: .equal,
                                                  toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
        
        let xConstraint = NSLayoutConstraint(item: self.monthlabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: self.monthlabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
