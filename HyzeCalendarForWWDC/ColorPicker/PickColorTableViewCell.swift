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
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var selectButtonView: UIView!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var colorViewLabel: UILabel!
    
    var eventInformations: EventEditorEventInformations!
    
    func reloadInformations() {
        eventInformations = EventManagement.shared.eventInformation
        
        colorView.backgroundColor = eventInformations.color
        colorView.layer.shadowColor = colorView.backgroundColor?.cgColor
        
        guard let color = eventInformations.calendar?.cgColor else {
            colorViewLabel.text = customColorText
            return
        }
        
        if eventInformations.color == UIColor(cgColor: color) {
            colorViewLabel.text = calendarColorText
            return
        } else {
            colorViewLabel.text = customColorText
            return
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = UIColor.clear
        mainView.backgroundColor = UIColor.clear
        cellView.layer.cornerRadius = topView.bounds.height / 2
        cellView.layer.masksToBounds = true
        topView.backgroundColor = Color.lightBlue
        bottomView.backgroundColor = Color.blue
        
        colorView.layer.cornerRadius = cellView.layer.cornerRadius
        colorView.layer.shadowOffset = CGSize(width: 1, height: 3)
        colorView.layer.shadowRadius = 5
        colorView.layer.shadowOpacity = 0.7
        
        reloadInformations()
        
        
        setUpButton(selectButtonView, button: selectButton, image: #imageLiteral(resourceName: "ic_keyboard_arrow_right"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
