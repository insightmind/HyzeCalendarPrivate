//
//  ETViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 28.09.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import Lottie

class ETViewController: UIViewController {

    @IBOutlet weak var gestureBar: UIView!
    @IBOutlet weak var dayLabel: UILabel!

    @IBOutlet weak var leftToolbarButton: UIButton!
    @IBOutlet weak var rightToolbarButton: UIButton!
    
    @IBOutlet weak var toolBar: UIView!
    
    var rightAnimation: LOTAnimationView?
    var isActive: Bool = true
    
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
    

    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        guard let animation = rightAnimation else { return }
        if isActive {
            animation.play(fromProgress: 0.5, toProgress: 1, withCompletion: { (_) in
                animation.animationProgress = 0
            })
            isActive = false
        } else {
            animation.play(fromProgress: 0, toProgress: 0.5, withCompletion: nil)
            isActive = true
        }
        
    }
    
    func setUpToolbar() {
        let leftImage = #imageLiteral(resourceName: "ic_keyboard_arrow_right").withRenderingMode(.alwaysTemplate)
        leftToolbarButton.setImage(leftImage, for: .normal)
        leftToolbarButton.tintColor = Color.white
        
        setUpLayerAnimation()
    }
    
    func setUpLayerAnimation() {
        var layerString = "layers_blue"
        guard let isToday = Selection.shared.selectedIsToday else { return }
        guard let isWeekend = Selection.shared.selectedIsOnWeekend else { return }
        if isToday{
            layerString = "layers_red"
        } else if isWeekend {
            layerString = "layers_green"
        }
        let animation = LOTAnimationView(name: layerString)
        rightAnimation = animation
        animation.contentMode = .scaleAspectFill
        animation.animationSpeed = 2.5
        animation.backgroundColor = UIColor.clear
        animation.frame = rightToolbarButton.bounds
        rightToolbarButton.addSubview(animation)
        animation.play(toProgress: 0.5, withCompletion: nil)
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
