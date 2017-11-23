//
//  ColorPickerCollectionViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 21.11.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class ColorPickerCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var superViewController: ColorPickerViewController?
    
    let spacing: CGFloat = 16
    let colorsPerRow: CGFloat = 5
    
    var colors = [MaterialColor]()
    
    let reuseIdentifier = "colorCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.contentInset = UIEdgeInsets(top: 8, left: spacing, bottom: 50, right: spacing)
        self.collectionView!.allowsMultipleSelection = false

        loadColors()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return spacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = (colorsPerRow + 1) * spacing
        let fullContentWidth = collectionView.bounds.width - insets
        let width = fullContentWidth / colorsPerRow
        return CGSize(width: width, height: width)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        cell.contentView.layer.cornerRadius = cell.bounds.width / 2
        cell.contentView.backgroundColor = colors[indexPath.item].color
        
//        cell.contentView.layer.shadowColor = cell.contentView.backgroundColor?.cgColor
//        cell.contentView.layer.shadowOffset = CGSize(width: 1, height: 3)
//        cell.contentView.layer.shadowRadius = 5
//        cell.contentView.layer.shadowOpacity = 0.6
//    
        return cell
    }
    
    func loadColors() {
        colors = []
        let groups = MaterialColors.colorGroups
        for group in groups {
            colors.append(group.primaryColor)
        }
        colors.append(MaterialColor(name: "Grey", color: Color.grey, textColor: Color.grey))
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3) {
            guard let vc = self.superViewController else {
                return
            }
            vc.setCustomColor(self.colors[indexPath.item].color)
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            cell?.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            cell?.transform = CGAffineTransform.identity
        }, completion: nil)
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
