//
//  SettingsListTableViewCell.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 25.10.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SettingsListTableViewCell: UITableViewCell {
    
    private var superView: UIViewController?
    private var tableViewController: UIViewController?

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var mainView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {}
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {}
    
    func configure() {
        backgroundColor = UIColor.clear
        
        cellView.backgroundColor = UIColor.clear
        cellView.layer.cornerRadius = 20
        cellView.layer.masksToBounds = true
        
        let label = UILabel()
        label.textColor = Color.white
        label.text = "Please add Content"
        label.textAlignment = .center
        setMainView(to: label)
    }
    
    func setTitle(_ to: String) {
        title.text = to
    }
    
    func connect(to superController: UIViewController) {
        self.superView = superController
    }
    
    func setMainView(to controller: UIViewController) -> Bool {
        guard let superController = superView else { return false }
        superController.addChildViewController(controller)
        
        setMainView(to: controller.view)
        
        controller.didMove(toParentViewController: superController)
        self.tableViewController = controller
        return true
    }
    
    func setMainView(to view: UIView) {
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.mainView.leadingAnchor, constant: 0),
            view.trailingAnchor.constraint(equalTo: self.mainView.trailingAnchor, constant: 0),
            view.topAnchor.constraint(equalTo: self.mainView.topAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: self.mainView.bottomAnchor, constant: 0)
            ])
    }
    
}
