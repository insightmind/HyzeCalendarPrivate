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
    
    var event: EKEvent? = nil
    let smallFontSize = UIFont.systemFont(ofSize: 14)

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var startTime: UILabel!
    @IBOutlet weak var endTime: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var selectMenu: UIView!
    
    @IBOutlet weak var editButtonView: UIView!
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var showButtonView: UIView!
    @IBOutlet weak var showButton: UIButton!
    
    @IBOutlet weak var removeButtonView: UIView!
    @IBOutlet weak var removeButton: UIButton!
    
    func configure() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = false
        mainView.layer.cornerRadius = 20
        let txtColor = Color.white.withAlphaComponent(0.7)
        startTime.textColor = txtColor
        endTime.textColor = txtColor
        titleLabel.textColor = Color.white
        mainView.layer.masksToBounds = false
        mainView.layer.shadowColor = Color.grey.cgColor
        mainView.layer.shadowOpacity = 0.6
        mainView.layer.shadowOffset = CGSize.zero
        mainView.layer.shadowRadius = 5
        selectMenu.layer.cornerRadius = 20
    }
    
    func configureButtons() {
        setUpButton(editButtonView, button: editButton, image: #imageLiteral(resourceName: "ic_edit"), backgroundColor: Color.blue)
        editButtonView.layer.cornerRadius = editButton.bounds.width / 2
        editButtonView.layer.shadowColor = Color.grey.cgColor
        setUpButton(showButtonView, button: showButton, image: #imageLiteral(resourceName: "ic_star"), backgroundColor: Color.green)
        showButtonView.layer.cornerRadius = showButton.bounds.width / 2
        showButtonView.layer.shadowColor = Color.grey.cgColor
        setUpButton(removeButtonView, button: removeButton, image: #imageLiteral(resourceName: "ic_delete"), backgroundColor: Color.red)
        removeButtonView.layer.cornerRadius = removeButton.bounds.width / 2
        removeButtonView.layer.shadowColor = Color.grey.cgColor
    }
    
    func configureRecognizer() {
        let editRecognizer = UITapGestureRecognizer(target: self, action: #selector(edit(_:)))
        editButtonView.addGestureRecognizer(editRecognizer)
        let showRecognizer = UITapGestureRecognizer(target: self, action: #selector(show(_:)))
        editButtonView.addGestureRecognizer(showRecognizer)
        let removeRecognizer = UITapGestureRecognizer(target: self, action: #selector(remove(_:)))
        editButtonView.addGestureRecognizer(removeRecognizer)
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
        guard let calendar = event?.calendar else { return }
        let color = UIColor(cgColor: calendar.cgColor)
        mainView.backgroundColor = color
    }
    
    func loadTitle() {
        guard let title = event?.title else { return }
        titleLabel.text = title
    }
    
    func loadReadWriteAccess() {
        guard let evnt = event else { return }
        if evnt.isReadOnly() {
            editButtonView.isHidden = true
            removeButtonView.isHidden = true
        } else {
            editButtonView.isHidden = false
            removeButtonView.isHidden = false
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
        configureRecognizer()
        layoutIfNeeded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            selectMenu.isHidden = false
        } else {
            selectMenu.isHidden = true
        }
        self.configureButtons()
        UIView.animate(withDuration: 0.3, animations: {
            self.layoutIfNeeded()
        }) { (_) in
            self.configureButtons()
        }
        
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
        EventManagement.shared.deleteEvent(eventInformations)
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
    }
    
}
