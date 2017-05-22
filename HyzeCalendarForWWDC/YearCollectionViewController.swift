//
//  CalendarViewYearCollectionViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 5/10/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

private let reuseIdentifier = "monthCell"

class YearCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
	
	internal var yearID: Int
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(MonthCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
		self.collectionView!.isScrollEnabled = false
		self.collectionView!.allowsSelection = false
		// Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	init(collectionViewLayout layout: UICollectionViewLayout, IDofYearCell ID: Int) {
		self.yearID = ID
		super.init(collectionViewLayout: layout)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
		
		collectionView.backgroundColor = UIColor.clear
		
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 12
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MonthCollectionViewCell
    
        // Configure the cell
		if cell.controller == nil {
			let newController = MonthCollectionViewController(collectionViewLayout: CalendarViewFlowLayout(), idOfYear: self.yearID, idOfMonth: indexPath.item)
			self.addChildViewController(newController)
			newController.view.frame = cell.bounds
			cell.addSubview(newController.view)
			newController.didMove(toParentViewController: self)
			cell.controller = newController
		}
		
        return cell
    }
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let width = self.view.bounds.width
		let height = self.view.bounds.height / 12
		let size = CGSize(width: width, height: height)
		return size
	}

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
