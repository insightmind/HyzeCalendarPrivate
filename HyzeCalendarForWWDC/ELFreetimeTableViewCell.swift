//
//  ELFreetimeTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 05.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class ELFreetimeTableViewCell: UITableViewCell {

    @IBOutlet weak var pointView: UIView!
    
    func configure() {
        backgroundColor = UIColor.clear
        pointView.layer.cornerRadius = pointView.frame.width/2
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
