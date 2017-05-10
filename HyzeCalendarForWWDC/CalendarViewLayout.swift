//
//  CalendarViewDelegateFlowLayout.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 1/15/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class CalendarViewFlowLayout: UICollectionViewFlowLayout{
    // constant for minimum Spacing in CollectionView
    let minimumSpacing:CGFloat = 2
    
    override init() {
        super.init()
        self.minimumLineSpacing = minimumSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.minimumLineSpacing = minimumSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
    }
}
