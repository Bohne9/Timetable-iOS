//
//  Extensions.swift
//  Timetable
//
//  Created by Jonah Schueller on 22.06.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

extension Date {
    
    init(nanoseconds: Int32) {
        self.init(timeIntervalSince1970: Double(nanoseconds) / 1000000000.0)
    }
    
    func format(with format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}

extension UIColor {
    
    func lighter(by percentage:CGFloat=20.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=20.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=20.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
    
    static func grayscale(gray: CGFloat, alpha: CGFloat = 1.0) -> UIColor{
        return UIColor(red: gray, green: gray, blue: gray, alpha: alpha)
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
    
    // Interaction: #4888DB
    // Background: #2A2E37
    // Background-Contrast: #F1F1F1
    // Error: #CE4339
    // Success: #8CC94E
    
    static let interaction = UIColor(hexString: "#4888DB")
    static let interactionDarker = UIColor.interaction.darker()!
    static let interactionLighter = UIColor.interaction.lighter()!
    
    // Old blue gradient color : #47495D
//    static let background = UIColor(hexString: "#47495D")
//    static let background = UIColor(hexString: "#222427")
    static let background = UIColor(hexString: "#33353E")
    // 24272C
    static let backgroundContrast = UIColor(hexString: "#24272C")
    //    static let backgroundDarker = UIColor.background.darker()!
    //    static let backgroundLighter = UIColor.background.lighter()!
    //
    //    static let backgroundLighter = UIColor(hexString: "#47495D")
    static let lightBlue = UIColor(hexString: "#1A4C98")
    static let lightBlack = UIColor(hexString: "#2A2A32")
    
    static let contrast = UIColor(hexString: "#F1F1F1")
    static let contrastDarker = UIColor.contrast.darker()!
    static let contrastLighter = UIColor.contrast.lighter()!
    
    static let appWhite = grayscale(gray: 0.95)
    
    static let error = UIColor(hexString: "#E71A25")
    static let errorDarker = UIColor.error.darker()!
    static let errorLighter = UIColor.error.lighter()!
    
    static let success = UIColor(hexString: "#5EA27F")
    static let successDarker = UIColor.success.darker()!
    static let successLighter = UIColor.success.lighter()!
    
    //    static let appDarkGray = UIColor(red:0.19, green:0.20, blue:0.24, alpha:1.0)
    //    static let appLightGray = UIColor(red:0.75, green:0.76, blue:0.78, alpha:1.0)
    //    static let appLightBlue = UIColor(red:0.59, green:0.75, blue:0.81, alpha:1.0)
    //    static let appDarkWhite = UIColor(red:0.75, green:0.73, blue:0.71, alpha:1.0)
    //    static let appRed = UIColor(red:0.76, green:0.36, blue:0.34, alpha:1.0)
    //    static let appWhite = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    //
    //    static let appDarkGray = UIColor(red:0.32, green:0.33, blue:0.39, alpha:1.0)
    
    
    //    static let appDarkGray = UIColor(red:0.19, green:0.20, blue:0.24, alpha:1.0)
    static let appLightGray = UIColor(red:0.75, green:0.76, blue:0.78, alpha:1.0)
    static let appLightBlue = UIColor(red:0.59, green:0.75, blue:0.81, alpha:1.0)
    static let appDarkWhite = UIColor(red:0.75, green:0.73, blue:0.71, alpha:1.0)
    static let appRed = UIColor(red:0.76, green:0.36, blue:0.34, alpha:1.0)
    //    static let appWhite = UIColor(red:0.96, green:0.96, blue:0.96, alpha:1.0)
    
}

extension UIView {
    
    func constraint(to view: UIView, topOffset: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: topOffset).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
    }
    
    func constraint(to view: UILayoutGuide, topOffset: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: topOffset).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
    }
    
    func constraint(topAnchor: NSLayoutYAxisAnchor, leading: NSLayoutXAxisAnchor, trailing: NSLayoutXAxisAnchor, bottom: NSLayoutYAxisAnchor, topOffset: CGFloat = 0, leadingOff: CGFloat = 0, trailingOff: CGFloat = 0, bottomOff: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: topAnchor, constant: topOffset).isActive = true
        leadingAnchor.constraint(equalTo: leading, constant: leadingOff).isActive = true
        trailingAnchor.constraint(equalTo: trailing, constant: trailingOff).isActive = true
        bottomAnchor.constraint(equalTo: bottom, constant: bottomOff).isActive = true
    }
    
    func constraint(topAnchor: NSLayoutYAxisAnchor, leading: NSLayoutXAxisAnchor, trailing: NSLayoutXAxisAnchor, bottom: NSLayoutYAxisAnchor, insets: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: topAnchor, constant: insets).isActive = true
        leadingAnchor.constraint(equalTo: leading, constant: insets).isActive = true
        trailingAnchor.constraint(equalTo: trailing, constant: insets).isActive = true
        bottomAnchor.constraint(equalTo: bottom, constant: insets).isActive = true
    }
    
    func addAndConstraint(to view: UIView, topOffset: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0, bottom: CGFloat = 0) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor, constant: topOffset).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leading).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: trailing).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottom).isActive = true
    }
    
    
}


extension UIFont {
    
    static func robotoBold(_ ofSize: CGFloat) -> UIFont{
        return UIFont(name: "Roboto-Bold", size: ofSize)!
    }
    
    static func robotoMedium(_ ofSize: CGFloat) -> UIFont{
        return UIFont(name: "Roboto-Medium", size: ofSize)!
    }
    
    static func robotoRegular(_ ofSize: CGFloat) -> UIFont{
        return UIFont(name: "Roboto-Regular", size: ofSize)!
    }
    
    static func robotoThin(_ ofSize: CGFloat) -> UIFont{
        return UIFont(name: "Roboto-Thin", size: ofSize)!
    }
    
    static func robotoLight(_ ofSize: CGFloat) -> UIFont{
        return UIFont(name: "Roboto-Light", size: ofSize)!
    }
    
    static func robotoBlack(_ ofSize: CGFloat) -> UIFont{
        return UIFont(name: "Roboto-Black", size: ofSize)!
    }
}


