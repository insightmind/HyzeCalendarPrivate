//
//  DefaultAlarmTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 19.12.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class DefaultAlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var removeButtonView: UIView!
    @IBOutlet weak var removeButton: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var bottomLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundColor = Color.blue
        topLabel.textColor = Color.white
        bottomLabel.textColor = Color.white
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setUpButton(removeButtonView, button: removeButton, image: #imageLiteral(resourceName: "ic_remove"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
