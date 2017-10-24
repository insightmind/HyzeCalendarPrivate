//
//  GridCollectionViewFlowLayout.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 24.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class GridCollectionViewFlowLayout: UICollectionViewFlowLayout {

    let minimumSpace: CGFloat = 0
    var cellsPerRow: CGFloat = 1
    let inset: CGFloat = 5
    
    init(cellsPerRow: Int = 1, scrollDirection: UICollectionViewScrollDirection = .vertical) {
        super.init()
        self.cellsPerRow = CGFloat(cellsPerRow)
        self.scrollDirection = scrollDirection
        self.sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        configure()
    }
    
    override init() {
        super.init()
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        self.minimumLineSpacing = 5
        self.minimumInteritemSpacing = minimumSpace
    }
    
    func sizeForItems() -> CGSize {
        
        let width = collectionView!.bounds.width
        let cellSize = CGSize(width: (width - 2 * inset) / cellsPerRow, height: ((width - 2 * inset) / 7 * 6) / cellsPerRow)
        
        return cellSize
    }
    
    override var itemSize: CGSize {
        get {
            return sizeForItems()
        }
        set {
            self.itemSize = sizeForItems()
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
    
}
