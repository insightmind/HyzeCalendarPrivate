//
//  Design.swift
//  HyzeCalendarForWWDC
//
//  Created by redfleet on 8/11/17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//



import UIKit

struct Color {
    static let white = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let black = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    static let grey = #colorLiteral(red: 0.171, green: 0.1708723033, blue: 0.1708723033, alpha: 1)
    static let orange = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    static let blue = #colorLiteral(red: 0.204, green: 0.571, blue: 0.901, alpha: 1)
    static let lightBlue = #colorLiteral(red: 0.219, green: 0.629, blue: 1, alpha: 1)
    static let darkBlue = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
    static let green = #colorLiteral(red: 0.3764705882, green: 0.7803921569, blue: 0.3882352941, alpha: 1)
    static let darkGreen = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
    static let red = #colorLiteral(red: 0.929, green: 0.263, blue: 0.216, alpha: 1)
    static let lightRed = #colorLiteral(red: 1, green: 0.2805668505, blue: 0.2337245871, alpha: 1)
    static let darkRed = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
}

class Design {
    
    static let shared = Design()
    
    var currentETViewHeight: CGFloat = 0
    var currentETViewState: ETViewState = .normal
    var currentETViewIsExpandedByNumOfRows: CGFloat = 0
    
}


