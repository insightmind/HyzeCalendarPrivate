//
//  AlarmTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 19.12.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class AlarmTableViewCell: UITableViewCell, EventEditorCellProtocol {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var addAlarmView: UIView!
    @IBOutlet weak var selectAlarmView: AlarmTableView!
    @IBOutlet weak var showAllView: UIView!
    @IBOutlet weak var showAllButtonView: UIView!
    @IBOutlet weak var showAllButton: UIButton!
    @IBOutlet weak var addAlarmButtonView: UIView!
    @IBOutlet weak var addAlarmButton: UIButton!
    @IBOutlet weak var addAlarmLabel: UILabel!
    @IBOutlet weak var showAllViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addAlarmViewHeightConstraint: NSLayoutConstraint!
    
    var eventInformations: EventEditorEventInformations! = EventManagement.shared.eventInformation
    
    func reloadInformations() {
        selectAlarmView.reloadData()
        setLayout()
        layoutIfNeeded()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.topView.backgroundColor = Color.lightBlue
        
        setUpMainView()
        setUpAddAlarmView()
        setUpShowAll()
        
        setLayout()
    }
    
    func setUpMainView() {
        mainView.layer.cornerRadius = topView.bounds.height / 2
        mainView.layer.masksToBounds = true
    }
    
    func setUpAddAlarmView() {
        addAlarmView.backgroundColor = Color.blue
        addAlarmLabel.text = "add Alarm"
        setUpButton(addAlarmButtonView, button: addAlarmButton, image: #imageLiteral(resourceName: "ic_add"))
        
        if eventInformations.state == .showDetail {
            addAlarmButtonView.isHidden = true
        } else {
            addAlarmButtonView.isHidden = false
        }
    }
    
    func setUpShowAll() {
        setUpButton(showAllButtonView, button: showAllButton, image: #imageLiteral(resourceName: "ic_keyboard_arrow_down"))
    }
    
    func setLayout() {
        
        let defaultCellHeight: CGFloat = 55
        
        switch eventInformations.state {
        case .create:
            addAlarmViewHeightConstraint.constant = 55
            addAlarmView.isHidden = false
            addAlarmButtonView.isHidden = false
            if let count = eventInformations.alarms?.count {
                if count <= 2 {
                    showAllViewHeightConstraint.constant = 0
                    showAllButtonView.isHidden = true
                } else {
                    showAllViewHeightConstraint.constant = defaultCellHeight
                    showAllButtonView.isHidden = false
                }
            } else {
                showAllViewHeightConstraint.constant = 0
                showAllButtonView.isHidden = true
            }
        case .showDetail:
            addAlarmViewHeightConstraint.constant = 0
            addAlarmView.isHidden = true
            addAlarmButtonView.isHidden = true
            if let count = eventInformations.alarms?.count {
                if count <= 3 {
                    showAllViewHeightConstraint.constant = 0
                    showAllButtonView.isHidden = true
                } else {
                    showAllViewHeightConstraint.constant = defaultCellHeight
                    showAllButtonView.isHidden = false
                }
            } else {
                showAllViewHeightConstraint.constant = 0
                showAllButtonView.isHidden = true
            }
        }
    }
    
    @IBAction func toggleShowAll(_ sender: UIButton) {
        guard let tableView = eventInformations.eventEditorTableViewController else { return }
        eventInformations.showAllAlarms = !eventInformations.showAllAlarms
        tableView.updateCellHeights()
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.showAllButton.transform = CGAffineTransform(rotationAngle: self.eventInformations.showAllAlarms ? CGFloat.pi : 2*CGFloat.pi)
        }, completion: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func addAlarm(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "AddAlarmPopover", bundle: nil)
        guard let viewController = storyboard.instantiateInitialViewController() else { return }
        guard let superViewController = eventInformations.eventEditor else {
            fatalError("Where is the mainEventEditorViewController and why did this even happen?")
        }
        superViewController.present(viewController, animated: true, completion: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reloadInformations()
    }
    
    override func prepareForReuse() {
        reloadInformations()
        return
    }
    
}
