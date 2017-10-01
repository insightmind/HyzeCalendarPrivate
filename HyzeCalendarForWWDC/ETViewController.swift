//
//  ETViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 28.09.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class ETViewController: UIViewController {

    @IBOutlet weak var gestureBar: UIView!
    @IBOutlet weak var dayLabel: UILabel!

    @IBOutlet weak var leftToolbarButton: UIButton!
    @IBOutlet weak var rightToolbarButton: UIButton!
    
    @IBOutlet weak var toolBar: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 20
        self.view.layer.masksToBounds = true
        setUpGestureBar()
        setUpToolbar()
        // Do any additional setup after loading the view.
    }
    
    func setUpGestureBar() {
        gestureBar.layer.cornerRadius = gestureBar.bounds.height / 2
        gestureBar.backgroundColor = Color.grey.withAlphaComponent(0.5)
    }
    
    func setUpToolbar() {
        let leftImage = #imageLiteral(resourceName: "ic_error_outline").withRenderingMode(.alwaysTemplate)
        leftToolbarButton.setImage(leftImage, for: .normal)
        leftToolbarButton.tintColor = Color.white
        let rightImage = #imageLiteral(resourceName: "ic_error_outline").withRenderingMode(.alwaysTemplate)
        rightToolbarButton.setImage(rightImage, for: .normal)
        rightToolbarButton.tintColor = Color.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
