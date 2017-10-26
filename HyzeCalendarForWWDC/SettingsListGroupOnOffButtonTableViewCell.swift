//
//  SettingsListGroupOnOffButtonTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 26.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SettingsListGroupOnOffButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    var key: String = ""
    
    func fetchConfiguration(_ informations: SettingsListGroupCellInformations) {
        self.key = informations.key
        configureDesign(informations)
        layoutIfNeeded()
        loadSettings()
    }
    
    func loadSettings() {
        let defaults = UserDefaults.standard
        let state = defaults.bool(forKey: key)
        settingsSwitch.setOn(state, animated: true)
    }
    
    func configureDesign(_ informations: SettingsListGroupCellInformations) {
        mainView.backgroundColor = informations.color
        titleLabel.text = informations.title
        titleLabel.textColor = informations.textColor
    }
    
    @IBAction func toggle(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        defaults.set(!settingsSwitch.isOn, forKey: key)
        defaults.synchronize()
        loadSettings()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
    
}
