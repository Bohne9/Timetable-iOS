//
//  TextField.swift
//  Timetable
//
//  Created by Jonah Schueller on 11.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class TextField: UITextField, UITextFieldDelegate {
    
//    let padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10);

    
    init(){
        super.init(frame: .zero)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var placeholder: String?{
        didSet{
            placeholderColor(placeHolderColor)
        }
    }
    
    private var placeHolderColor: UIColor = .black
    
    func placeholderColor(_ color: UIColor){
        placeHolderColor = color
        var placeholderText = ""
        if self.placeholder != nil{
            placeholderText = self.placeholder!
        }
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor : color])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
//    override open func textRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
//
//    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
//
//    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
//        return UIEdgeInsetsInsetRect(bounds, padding)
//    }
}
