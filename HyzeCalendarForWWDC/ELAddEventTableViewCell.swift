//
//  ELAddEventTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 11.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class ELAddEventTableViewCell: UITableViewCell {
    
    var tableView: EventListTableViewController?

    @IBOutlet weak var addEventButtonView: UIView!
    @IBOutlet weak var addEventButton: UIButton!
    
    @IBOutlet weak var selectTodayButtonView: UIView!
    @IBOutlet weak var selectTodayButton: UIButton!
    
    @IBOutlet weak var layerButtonView: UIView!
    @IBOutlet weak var layerButton: UIButton!

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
    
    @IBAction func addEvent(_ sender: UIButton) {
        EventManagement.shared.eventInformation = EventEditorEventInformations()
        EventManagement.shared.eventInformation.calendar = EventManagement.shared.getHyzeCalendar() ?? EventManagement.shared.EMEventStore.defaultCalendarForNewEvents
        let storyboard = UIStoryboard(name: "EventEditor", bundle: nil)
        let superViewController = UIApplication.shared.keyWindow?.rootViewController
        var mainViewController: ViewController
        guard let eventEditor = storyboard.instantiateInitialViewController() else { return }
        for i in (superViewController?.childViewControllers)! {
            if i.title == "MonthView" {
                mainViewController = i as! ViewController
                eventEditor.modalPresentationStyle = .overCurrentContext
                eventEditor.modalTransitionStyle = .crossDissolve
                mainViewController.present(eventEditor, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func toggleLayer(_ sender: UIButton) {
        guard let eventList = tableView else { return }
        Settings.shared.isEventListRelative = !Settings.shared.isEventListRelative
        updateLayerDesign()
        eventList.reloadList(onlyDesign: true)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        layoutIfNeeded()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        updateDesign()
    }
    
    func updateDesign() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = false
        let bColor = Settings.shared.isDarkMode ? Color.black : Color.white
        let tColor = Settings.shared.isDarkMode ? Color.white : Color.black
        if let superController = tableView {
            if superController.isEmbededInDayView {
                selectTodayButtonView.isHidden = true
            } else {
                selectTodayButtonView.isHidden = false
                setUpButton(selectTodayButtonView, button: selectTodayButton, image: #imageLiteral(resourceName: "ic_keyboard_arrow_right"), backgroundColor:  bColor, tintColor: tColor)
                selectTodayButtonView.layer.shadowColor = Color.black.cgColor
            }
        }
        
        setUpButton(addEventButtonView, button: addEventButton, image: #imageLiteral(resourceName: "ic_add"), backgroundColor: Color.green)
        addEventButtonView.layer.shadowColor = Color.black.cgColor
        addEventButtonView.layer.cornerRadius = addEventButtonView.bounds.height / 2
        updateLayerDesign()
        updateSelectTodayIcon()
    }
    
    
    
    func updateLayerDesign() {
        let bColor = Settings.shared.isDarkMode ? Color.black : Color.white
        let tColor = Settings.shared.isDarkMode ? Color.white : Color.black
        var image: UIImage
        if Settings.shared.isEventListRelative {
            image = #imageLiteral(resourceName: "ic_layers")
        } else {
            image = #imageLiteral(resourceName: "ic_layers_clear")
        }
        setUpButton(layerButtonView, button: layerButton, image: image, backgroundColor: bColor, tintColor: tColor)
        layerButtonView.layer.shadowColor = Color.black.cgColor
    }
    
    func updateSelectTodayIcon() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
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
            self.selectTodayButton.transform = transform
        }, completion: nil)
    }
    
}
