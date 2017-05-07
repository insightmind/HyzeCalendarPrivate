//
//  CalendarViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 1/22/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class CalendarViewCell: UICollectionViewCell {
    
    lazy var label: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .center
        self.backgroundColor = UIColor.clear
        self.label.contentMode = .center
        self.label.frame = self.bounds
        //let dayCellView = dayView(frame: self.bounds)
        self.contentView.layer.cornerRadius = self.bounds.width / 2
        //self.addSubview(dayCellView)
        self.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        self.label.textColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
    }
}
