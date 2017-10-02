//
//  ETViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 28.09.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import Lottie

enum ETViewState {
    case expanded
    case normal
    case minimal
}


class ETViewController: UIViewController {
    
    var state: ETViewState = .normal

    @IBOutlet weak var gestureBar: UIView!
    @IBOutlet weak var dayLabel: UILabel!

    @IBOutlet weak var leftToolbarButton: UIButton!
    @IBOutlet weak var rightToolbarButton: UIButton!
    @IBOutlet var rightTapGestureRecognizer: UITapGestureRecognizer!
    
    @IBOutlet weak var toolBar: UIView!
    
    var rightAnimation: LOTAnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 20
        self.view.layer.masksToBounds = true
        setUpGestureBar()
        setUpToolbar()
        setUpTitle()
    }
    
    @IBAction func jumpToToday(_ sender: UIButton) {
        let superViewController = UIApplication.shared.keyWindow?.rootViewController
        var mainViewController: ViewController
        for i in (superViewController?.childViewControllers)! {
            if i.title == "MonthView" {
                mainViewController = i as! ViewController
                guard let calendarViewController = mainViewController.calendarViewController else { return }
                let (todayYearID, todayMonthID, _) = Selection.shared.todaysDayCellIndex
                calendarViewController.scrollToSection(yearID: todayYearID, monthID: todayMonthID - 1, animated: true)
            }
        }
    }
    
    func setUpGestureBar() {
        gestureBar.layer.cornerRadius = gestureBar.bounds.height / 2
        gestureBar.backgroundColor = Color.grey.withAlphaComponent(0.5)
    }
    
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        setLayerPosition()
    }
    
    func setUpTitle() {
        switch state {
        case .normal:
            dayLabel.isHidden = true
        default:
            dayLabel.isHidden = false
        }
    }
    
    func setLayerPosition() {
        guard let animation = rightAnimation else { return }
        if Settings.shared.isEventListRelative {
            animation.play(fromProgress: 0.5, toProgress: 1, withCompletion: { (_) in
                animation.animationProgress = 0
            })
        } else {
            animation.play(fromProgress: 0, toProgress: 0.5, withCompletion: nil)
        }
        Settings.shared.isEventListRelative = !Settings.shared.isEventListRelative
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
        animation.animationSpeed = 4
        animation.backgroundColor = UIColor.clear
        animation.frame = rightToolbarButton.bounds
        rightToolbarButton.addSubview(animation)
        if Settings.shared.isEventListRelative {
            animation.animationProgress = 0.5
        } else {
            animation.animationProgress = 0
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDesign() {
        guard let isToday = Selection.shared.selectedIsToday else { return }
        guard let isWeekend = Selection.shared.selectedIsOnWeekend else { return }
        UIView.animate(withDuration: 0.2) {
            if isToday {
                self.view.backgroundColor = Color.red
            } else if isWeekend {
                self.view.backgroundColor = Color.green
            } else{
                self.view.backgroundColor = Color.blue
            }
            if let animation = self.rightAnimation {
                animation.removeFromSuperview()
                self.setUpLayerAnimation()
            }
        }
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.updateSelectTodayIcon()
        }, completion: nil)
        
    }
    
    func updateSelectTodayIcon() {
        let up = -(CGFloat.pi)/2
        let down = (CGFloat.pi)/2
        var transform = CGAffineTransform.init(rotationAngle: 0)
        let (todaysYearID, todaysMonthID, _ ) = Selection.shared.todaysDayCellIndex
        if todaysYearID == Selection.shared.currentYearID {
            if todaysMonthID > Selection.shared.currentMonthID {
                transform = CGAffineTransform.init(rotationAngle: down)
            } else if todaysMonthID < Selection.shared.currentMonthID {
                transform = CGAffineTransform.init(rotationAngle: up)
            }
        } else if todaysYearID > Selection.shared.currentYearID {
            transform = CGAffineTransform.init(rotationAngle: down)
        } else {
            transform = CGAffineTransform.init(rotationAngle: up)
        }
        self.leftToolbarButton.transform = transform
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
