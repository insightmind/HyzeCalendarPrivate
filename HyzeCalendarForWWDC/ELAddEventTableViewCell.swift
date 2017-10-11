//
//  ELAddEventTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 11.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class ELAddEventTableViewCell: UITableViewCell {

    @IBOutlet weak var addEventButtonView: UIView!
    @IBOutlet weak var addEventButton: UIButton!
    
    
    @IBOutlet weak var selectTodayButtonView: UIView!
    @IBOutlet weak var selectTodayButton: UIButton!
    
    @IBOutlet weak var layerButtonView: UIView!
    @IBOutlet weak var layerButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateDesign()
        // Initialization code
    }
    
    func updateDesign() {
        backgroundColor = UIColor.clear
        layer.masksToBounds = false
        let bColor = Settings.shared.isDarkMode ? Color.grey : Color.white
        let tColor = Settings.shared.isDarkMode ? Color.white : Color.grey
        setUpButton(selectTodayButtonView, button: selectTodayButton, image: #imageLiteral(resourceName: "ic_keyboard_arrow_right"), backgroundColor:  bColor, tintColor: tColor)
        selectTodayButtonView.layer.shadowColor = Color.grey.cgColor
        setUpButton(addEventButtonView, button: addEventButton, image: #imageLiteral(resourceName: "ic_add"), backgroundColor: Color.green)
        addEventButtonView.layer.shadowColor = Color.grey.cgColor
        addEventButtonView.layer.cornerRadius = addEventButtonView.bounds.height / 2
        setUpButton(layerButtonView, button: layerButton, image: #imageLiteral(resourceName: "ic_layers"), backgroundColor: bColor, tintColor: tColor)
        layerButtonView.layer.shadowColor = Color.grey.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
