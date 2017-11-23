//
//  ColorPickerViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 21.11.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class ColorPickerViewController: PopoverViewController {
    
    var selectedColor = EventManagement.shared.eventInformation.color
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundEffectView: UIVisualEffectView!
    @IBOutlet weak var selectView: UIView!
    @IBOutlet weak var selectInView: UIView!
    @IBOutlet weak var customButtonView: UIView!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var calendarButtonView: UIView!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var bottomBlurEffectView: UIVisualEffectView!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.layer.cornerRadius = 20
        mainView.layer.masksToBounds = true
        
        self.view.backgroundColor = UIColor.clear
        mainView.backgroundColor = UIColor.clear
        let blurEffect = UIBlurEffect(style: Settings.shared.isDarkMode ? .dark : .light)
        backgroundEffectView.effect = blurEffect
        bottomBlurEffectView.effect = blurEffect
        
        customButtonView.layer.cornerRadius = customButtonView.bounds.height / 2
        calendarButtonView.layer.cornerRadius = calendarButtonView.bounds.height / 2
        
        customButton.backgroundColor = UIColor.clear
        calendarButton.backgroundColor = UIColor.clear
        
        selectView.backgroundColor = UIColor.clear
        selectInView.backgroundColor = UIColor.clear
        
        loadDefaultColors()
        
        // Do any additional setup after loading the view.
    }
    
    func loadDefaultColors() {
        
        if let calendarColor = eventInformations.calendar?.cgColor {
            calendarButtonView.backgroundColor = UIColor(cgColor: calendarColor)
        } else {
            calendarButtonView.isHidden = true
        }
        
        calendarButtonView.layer.shadowColor = calendarButtonView.backgroundColor?.cgColor
        calendarButtonView.layer.shadowRadius = 5
        calendarButtonView.layer.shadowOpacity = 0.4
        calendarButtonView.layer.shadowOffset = CGSize(width: 1, height: 3)
        
        setCustomColor(selectedColor)
        
    }
    
    func setCustomColor(_ color: UIColor) {
        selectedColor = color
        
        customButtonView.backgroundColor = selectedColor
        customButtonView.layer.shadowColor = selectedColor.cgColor
        customButtonView.layer.shadowRadius = 5
        customButtonView.layer.shadowOpacity = 0.4
        customButtonView.layer.shadowOffset = CGSize(width: 1, height: 3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setCustom(_ sender: Any) {
        eventInformations.color = selectedColor
        self.dismiss(animated: true) {
            guard let tableView = self.eventInformations.eventEditorTableViewController else {
                return
            }
            tableView.reloadCell(.colorPicker, onlyInformations: true)
        }
    }
    
    @IBAction func setDefault(_ sender: Any) {
        eventInformations.color = calendarButtonView.backgroundColor!
        self.dismiss(animated: true) {
            guard let tableView = self.eventInformations.eventEditorTableViewController else {
                return
            }
            tableView.reloadCell(.colorPicker, onlyInformations: true)
        }
    }
    // MARK: - Navigation

    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: true, completion: nil)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embed" {
            if let collectionView = segue.destination as? ColorPickerCollectionViewController {
                collectionView.superViewController = self
            }
        }
    }

}
