//
//  PickColorTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 21.11.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class PickColorTableViewCell: UITableViewCell, EventEditorCellProtocol {
    
    let customColorText = "Custom Color"
    let calendarColorText = "Calendar Color"
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var selectButtonView: UIView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var colorLabel: UILabel!
    
    var eventInformations: EventEditorEventInformations!
    
    func reloadInformations() {
        eventInformations = EventManagement.shared.eventInformation
        
        UIView.animate(withDuration: 0.15) {
            self.cellView.backgroundColor = self.eventInformations.color
        }
        
        colorLabel.text = "Color"
        
        
//        guard let color = eventInformations.calendar?.cgColor else { return }
//
//        if eventInformations.color == UIColor(cgColor: color) {
//            colorLabel.text = calendarColorText
//        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = UIColor.clear
        mainView.backgroundColor = UIColor.clear
        cellView.layer.cornerRadius = cellView.bounds.height / 2
        cellView.layer.masksToBounds = true
        
        reloadInformations()
        
        setUpButton(selectButtonView, button: selectButton, image: #imageLiteral(resourceName: "ic_edit"))
        selectButtonView.layer.shadowColor = Color.black.cgColor
        
        if eventInformations.state == .showDetail {
            selectButtonView.isHidden = true
            colorLabel.textAlignment = .center
        }
    }
    
    @IBAction func edit(_ sender: Any) {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            let storyBoard = UIStoryboard(name: "ColorPicker", bundle: nil)
            guard let startDateViewController = storyBoard.instantiateInitialViewController() else {
                return
            }
            startDateViewController.modalTransitionStyle = .coverVertical
            topController.present(startDateViewController, animated: true, completion: nil)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
