//
//  ELEventTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 05.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit
import EventKit

class ELEventTableViewCell: UITableViewCell {
    
    var isMenuOpen: Bool = false
    private var isZoomed: Bool = false
    
    let normalFont = UIFont.systemFont(ofSize: 17)
    let selectedFont = UIFont.boldSystemFont(ofSize: 19)
    
    var event: EKEvent? = nil
    let smallFontSize = UIFont.systemFont(ofSize: 14)
    var eventList: EventListTableViewController?

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var eventView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var buttonsStackView: UIStackView!
    @IBOutlet weak var showButtonView: UIView!
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var editButtonView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var removeButtonView: UIView!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var removeMainView: UIView!
    @IBOutlet weak var editMainView: UIView!
    @IBOutlet weak var showMainView: UIView!
    
    @IBOutlet weak var startTimeToMainViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var endTimeToMainViewConstraint: NSLayoutConstraint!
    
    func configure() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = false
        mainView.layer.cornerRadius = 20
        let txtColor = Color.white.withAlphaComponent(0.7)
        startTime.textColor = txtColor
        endTime.textColor = txtColor
        titleLabel.textColor = Color.white
        mainView.layer.masksToBounds = false
        mainView.layer.shadowColor = Color.black.cgColor
        mainView.layer.shadowOpacity = 0.6
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.shadowRadius = 5
        topView.layer.cornerRadius = 20
        topView.layer.masksToBounds = true
        eventView.layer.cornerRadius = 20
        eventView.layer.masksToBounds = false
        eventView.layer.shadowColor = Color.black.cgColor
        eventView.layer.shadowOpacity = 0.6
        eventView.layer.shadowOffset = CGSize.zero
        eventView.layer.shadowRadius = 5
    }
    
    func configureButtons() {
        setUpButton(editButtonView, button: editButton, image: #imageLiteral(resourceName: "ic_edit"), backgroundColor: Color.blue, tintColor: Color.white)
        editButtonView.layer.shadowColor = Color.black.cgColor
        setUpButton(showButtonView, button: showButton, image: #imageLiteral(resourceName: "ic_star"), backgroundColor: Color.green, tintColor: Color.white)
        showButtonView.layer.shadowColor = Color.black.cgColor
        setUpButton(removeButtonView, button: removeButton, image: #imageLiteral(resourceName: "ic_delete"), backgroundColor: Color.red, tintColor: Color.white)
        removeButtonView.layer.shadowColor = Color.black.cgColor
        
        if isSelected {
            let transform = CGAffineTransform.identity
            buttonsStackView.transform = transform
            blurView.layer.opacity = 1
        } else {
            let transform = CGAffineTransform(translationX: self.bounds.width, y: 0)
            buttonsStackView.transform = transform
            blurView.layer.opacity = 0
        }
    }
    
    func configureGestureRecognizer() {
        let openMenuRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(openMenu))
        openMenuRecognizer.direction = .left
        openMenuRecognizer.numberOfTouchesRequired = 1
        
        mainView.addGestureRecognizer(openMenuRecognizer)
        
        let closeMenuRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(closeMenu))
        closeMenuRecognizer.direction = .right
        closeMenuRecognizer.numberOfTouchesRequired = 1
        
        buttonsStackView.addGestureRecognizer(closeMenuRecognizer)
    }
    
    @objc func openMenu() {
        if isMenuOpen { return }
        
        let transform = CGAffineTransform.identity
        
        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        shadowAnimation.fromValue = 0.6
        shadowAnimation.toValue = 0
        shadowAnimation.duration = 0.375
        self.mainView.layer.add(shadowAnimation, forKey: shadowAnimation.keyPath)
        mainView.layer.shadowOpacity = 0
        
        UIView.animate(withDuration: 0.375, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.buttonsStackView.transform = transform
            self.blurView.layer.opacity = 0
            
            let mainViewTransform = self.isZoomed ? CGAffineTransform.identity : CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.mainView.transform = mainViewTransform
        }) { (_) in
            self.isMenuOpen = true
        }
    }
    
    @objc func closeMenu() {
        if !isMenuOpen { return }
        
        let transform = CGAffineTransform(translationX: self.bounds.width, y: 0)
        
        let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
        shadowAnimation.fromValue = 0
        shadowAnimation.toValue = 0.6
        shadowAnimation.duration = 0.225
        self.mainView.layer.add(shadowAnimation, forKey: shadowAnimation.keyPath)
        mainView.layer.shadowOpacity = 0.6
        
        UIView.animate(withDuration: 0.225, delay: 0, options: .curveEaseOut, animations: {
            self.buttonsStackView.transform = transform
            self.blurView.layer.opacity = 0
            
            let mainViewTransform = self.isZoomed ? CGAffineTransform(scaleX: 1.04, y: 1.04) : CGAffineTransform.identity
            self.mainView.transform = mainViewTransform
        }) { (_) in
            self.isMenuOpen = false
        }
    }
    
    func loadDateTexts() {
        guard let secureEvent = event else { return }
        if secureEvent.isAllDay == true {
            startTime.text = "all Day"
            endTime.text = ""
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        startTime.text = dateFormatter.string(from: secureEvent.startDate)
        endTime.text = dateFormatter.string(from: secureEvent.endDate)
    }
    
    func loadCalendarColor() {
        guard let checkedEvent = event else { return }
        guard let color = EventManagement.shared.getColor(event: checkedEvent) else { return }
        eventView.backgroundColor = color
        topView.backgroundColor = color
    }
    
    func loadTitle() {
        guard let title = event?.title else { return }
        titleLabel.text = title
    }
    
    func loadReadWriteAccess() {
        guard let evnt = event else { return }
        if evnt.isReadOnly() {
            editMainView.isHidden = true
            removeMainView.isHidden = true
        } else {
            editMainView.isHidden = false
            removeMainView.isHidden = false
        }
    }
    
    func loadEvent(_ event: EKEvent) {
        self.event = event
        loadDateTexts()
        loadTitle()
        loadCalendarColor()
        loadReadWriteAccess()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        configureButtons()
        configureGestureRecognizer()
        layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        isZoomed = selected
        isZoomed ? didSelect() : didDeselect()
    }
    
    func didSelect() {
        Selection.shared.selectedEventIdentifier = event?.eventIdentifier
        if let dayView = Settings.shared.renDayView {
            dayView.selectEventView(with: Selection.shared.selectedEventIdentifier, duration: 0.2)
        }
        let transform = isMenuOpen ? CGAffineTransform.identity : CGAffineTransform(scaleX: 1.04, y: 1.04)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.mainView.transform = transform
        }, completion: nil)
    }
    
    func didDeselect() {
        let transform = isMenuOpen ? CGAffineTransform(scaleX: 0.95, y: 0.95) : CGAffineTransform.identity

        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.mainView.transform = transform
        }, completion: nil)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        return
    }
    
    @IBAction func edit(_ sender: Any) {
        openInEventEditor(state: .create)
    }
    @IBAction func show(_ sender: Any) {
        openInEventEditor(state: .showDetail)
    }
    @IBAction func remove(_ sender: Any) {
        guard let identfier = event?.eventIdentifier else { return }
        guard let eventInformations = EventManagement.shared.convertToEventEditorEventInformations(eventIdentifier: identfier, state: .create) else { return }
        let superViewController = UIApplication.shared.keyWindow?.rootViewController
        var mainViewController: ViewController
        for i in (superViewController?.childViewControllers)! {
            if i.title == "MonthView" {
                mainViewController = i as! ViewController
                let alert = UIAlertController(title: "Remove Event?", message: "You can't undo this action! ", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
                    return
                }
                let remove = UIAlertAction(title: "Remove", style: .destructive) { (_) in
                    EventManagement.shared.deleteEvent(eventInformations)
                    guard let eList = self.eventList else { return }
                    eList.reloadList(onlyDesign: false)
                }
                alert.addAction(cancel)
                alert.addAction(remove)
                
                mainViewController.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func openInEventEditor(state: EventEditorState) {
        guard let identfier = event?.eventIdentifier else { return }
        guard let eventInformations = EventManagement.shared.convertToEventEditorEventInformations(eventIdentifier: identfier, state: state) else { return }
        eventInformations.forceDismiss = state == .create ? true : false
        EventManagement.shared.eventInformation = eventInformations
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = "unable to load Event"
        startTime.text = ""
        endTime.text = ""
        mainView.transform = CGAffineTransform.identity
        closeMenu()
    }
    
}
