//
//  SettingsLinkViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 27.12.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

class SettingsLinkViewController: UIViewController {

    @IBOutlet weak var contextLabel: UILabel!
    @IBOutlet weak var linkButtonView: UIView!
    @IBOutlet weak var linkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.blue
        contextLabel.textColor = Color.white
        view.setUpButton(linkButtonView, button: linkButton, image: #imageLiteral(resourceName: "ic_keyboard_arrow_right"))
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func link(_ sender: UIButton) {
        if openInBrowser(url: "tweetbot://NiklasBuelow/user_profile/NiklasBuelow", isApp: true) { return }
        if openInBrowser(url: "twitter:///user?screen_name= NiklasBuelow", isApp: true) { return }
        if openInBrowser(url: "http://www.twitter.com/NiklasBuelow") { return }
    }
    
    func openInBrowser(url: String, isApp: Bool = false) -> Bool {
        if let realURL = URL(string: url) {
            if UIApplication.shared.canOpenURL(realURL) {
                UIApplication.shared.open(realURL, options: [:], completionHandler: nil)
                return true
            }
        }
        return false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
