//
//  LessonAddViewExtension.swift
//  Timetable
//
//  Created by Jonah Schueller on 30.03.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

extension UIColor {
    func interpolateRGBColorTo(_ end: UIColor, fraction: CGFloat) -> UIColor? {
        let f = min(max(0, fraction), 1)
        
        guard let c1 = self.cgColor.components, let c2 = end.cgColor.components else { return nil }
        
        let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
        let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
        let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
        let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

protocol TimeChooserDelegate {
    
    func timeChooser(_ timeChooser: TimeChooser, _ day: Day, _ time: Time) -> Bool
    
    func timeChooser(_ timeChooser: TimeChooser, finished: Bool)
    
}

// +++++++++++++++++++++++++++++++
//                               +
//                               +
//      START TIMECHOOSER CLASS  +
//                               +
//                               +
// +++++++++++++++++++++++++++++++

class TimeChooser: UIView, UIPickerViewDelegate, UIPickerViewDataSource, TimeChooserDelegate{
    
    var textField: DescribtedTextField
    private let line = UIView()
    var delegate: TimeChooserDelegate?
    
    let dayPicker = UIPickerView(frame: .zero)
    let hourPicker = UIPickerView(frame: .zero)
    let minutePicker = UIPickerView(frame: .zero)
    
    let dayData = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"].map { (input) in
        return Language.translate("Day_\(input)")
    }
    
    let hourData: [String] = {
        var data = [String]()
        for i in 0...23 {
            data.append(String(i))
        }
        return data
    }()
    
    let minuteData: [String] = {
        var data = [String]()
        for i in stride(from: 0, to: 60, by: 5) {
            data.append(i < 10 ? "0\(i)" : "\(i)")
        }
        return data
    }()
    
    // Returns the day as Day object based on the dayPicker state
    var day: Day{
        get{
            return Day(rawValue: dayPicker.selectedRow(inComponent: 0) + 1)!
        }
    }
    
    // Returns the time as Time object based on hourPicker state and minutePicker state
    var time: Time{
        get {
            return Time("\(hourData[hourPicker.selectedRow(inComponent: 0)]):\(minuteData[minutePicker.selectedRow(inComponent: 0)])")
        }
    }
    
    var expanded: Bool = false {
        didSet{
            expand(expanded)
        }
    }
    
    var text: String?{
        get{
            let str = "\(Language.translate("Day_\(day)")) - \(time.description)"
            
            return str
        }
        set {
            textField.text = newValue
        }
    }
    
    var bottomConstraint: NSLayoutConstraint?
    
    init(_ tf: String) {
        textField = DescribtedTextField(tf)
        super.init(frame: .zero)
        
        textField.textField.isEnabled = false
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.background
        
        layer.masksToBounds = false
        
        addSubview(textField)
        
        textField.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // Stack pickerViews horizontally
        constraint(dayPicker, textField.bottomAnchor, leadingAnchor, 3/5)
        constraint(hourPicker, textField.bottomAnchor, dayPicker.trailingAnchor, 1/5)
        constraint(minutePicker, textField.bottomAnchor, hourPicker.trailingAnchor, 1/5)
        
//        layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        
        textField.line.removeFromSuperview()
        
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .contrast
        addSubview(line)

        line.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        line.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
    
    func expand(_ expand: Bool) {
        var height: CGFloat = 60.0
        
        if expand {
//            layer.anchorPoint = CGPoint(x: 0.5, y: 0)
            height = 150.0
        }
        
        if bottomConstraint == nil {
            constraints.forEach { (con) in
                if con.firstAttribute == .bottom {
                    self.bottomConstraint = con
                }
            }
        }
        
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraint?.constant = CGFloat(height)
//            self.frame.size.height = CGFloat(height)
            
            self.layoutIfNeeded()
        }
    }
    
    
    // Add Button click -> add the lesson to the timetable and hide
    @objc func addBtnEvent(){
        let success = delegate!.timeChooser(self, day, time)
        delegate!.timeChooser(self, finished: success)
    }
    
    // Cancel Button click -> hide
    @objc func cancelBtnEvent() {
        delegate!.timeChooser(self, finished: true)
    }
    
    
    // Stacks the pickerViews horizontally
    private func constraint(_ view: UIPickerView, _ top: NSLayoutYAxisAnchor, _ leading: NSLayoutXAxisAnchor, _ width: CGFloat){
        addSubview(view)
        
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
        view.topAnchor.constraint(equalTo: top).isActive = true
        view.leadingAnchor.constraint(equalTo: leading).isActive = true
        view.widthAnchor.constraint(equalTo: widthAnchor, multiplier: width).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    
    // Get the data for the pickerViews
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == dayPicker {
            return dayData[row]
        }else if (pickerView == hourPicker) {
            return hourData[row]
        }else {
            return minuteData[row]
        }
        textField.text = text
    }
    
    
    // Set font and color for the pickerView labels
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = (view as? UILabel) ?? UILabel()
        
        label.textColor = .contrast
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        
        // where data is an Array of String
        label.text = self.pickerView(pickerView, titleForRow: row, forComponent: component)!
        
        return label
    }
    
    // Amount of rows based on the pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView == dayPicker ? dayData.count : pickerView == hourPicker ? hourData.count : minuteData.count
    }
    
    // One column per pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return  1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = text
    }
    
    
    // Default implementation -> when 'add' was hit
    func timeChooser(_ timeChooser: TimeChooser, _ day: Day, _ time: Time) -> Bool {
        print("TimeChooserDelegate not implemented")
        return true
    }
    
    // Remove timeChooser view from superview
    func timeChooser(_ timeChooser: TimeChooser, finished: Bool) {
        if (finished){
            removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// +++++++++++++++++++++++++++++++
//                               +
//                               +
//      END TIMECHOOSER CLASS    +
//                               +
//                               +
// +++++++++++++++++++++++++++++++
//
//
//class TextField: UITextField, UITextFieldDelegate {
//
//    let padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10);
//
//
//    init(){
//        super.init(frame: .zero)
//        delegate = self
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override var placeholder: String?{
//        didSet{
//            placeholderColor(textColor ?? .black)
//        }
//    }
//
//    func placeholderColor(_ color: UIColor){
//        var placeholderText = ""
//        if self.placeholder != nil{
//                placeholderText = self.placeholder!
//        }
//        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedStringKey.foregroundColor : color])
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//
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
//}



// +++++++++++++++++++++++++++++++
//                               +
//                               +
//      START TEXTFIELD CLASS    +
//                               +
//                               +
// +++++++++++++++++++++++++++++++
class DescribtedTextField: UIView, UITextFieldDelegate {
    
    let descrLabel: UILabel
    let textField: TextField
    let line = UIView()
    
    var text: String? {
        get{
            let text = textField.text
            
//            let regex = try? NSRegularExpression(pattern: "", options: )
            return textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        }
        set {
            textField.text = newValue
        }
    }
    
    convenience init(translate: String) {
        self.init(Language.translate(translate))
    }
    
    init(_ str: String) {
        descrLabel = UILabel()
        textField = TextField()
        
        super.init(frame: CGRect.zero)
        
        descrLabel.font = UIFont.robotoRegular(15)
        descrLabel.text = str
        
        translatesAutoresizingMaskIntoConstraints = false
        descrLabel.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        
//        textField.backgroundColor = UIColor(red:0.75, green:0.73, blue:0.71, alpha:0.6)
        descrLabel.textColor = .background
        textField.textColor = .background
        textField.font = UIFont.robotoMedium(18)
        textField.textAlignment = .left
        
       
        addSubview(descrLabel)
        addSubview(textField)
        
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 3
        textField.delegate = self
        
//        textField.bounds = CGRect(x: -5, y: -5, width: 5, height: 5)
        
        descrLabel.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
        descrLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        descrLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        descrLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        descrLabel.alpha = 0.8
        
        setupTextField()
        
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .background
        addSubview(line)
        
        line.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4).isActive = true
        line.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 2).isActive = true
        
    }
    
    
    fileprivate func setupTextField(){
        textField.topAnchor.constraint(equalTo: descrLabel.bottomAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textField.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        textField.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func shake(){
        line.backgroundColor = .error
        
        layoutIfNeeded()
        UIView.animate(withDuration: 5) {
            self.line.backgroundColor = .background
            self.layoutIfNeeded()
        }
        
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.06
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: center.x - 10, y: center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: center.x + 10, y: center.y))
        
        layer.add(animation, forKey: "position")
    }
    
    
    func setTextFieldFont(size: CGFloat) {
        textField.font = UIFont.robotoMedium(max(10, size))
    }
    
    func setDescrTextField(size: CGFloat) {
        descrLabel.font = UIFont.robotoMedium(max(10, size - 4))
        descrLabel.constraints.forEach { (con) in
            if con.firstAttribute == .height {
                con.constant = size
            }
        }
    }
    
    func color(_ color: UIColor) {
        descrLabel.textColor = color
        textField.textColor = color
        line.backgroundColor = color
    }
    
    
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// +++++++++++++++++++++++++++++++
//                               +
//                               +
//      END TEXTFIELD CLASS      +
//                               +
//                               +
// +++++++++++++++++++++++++++++++




class ConfirmView: UIView{
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 10.0
    
    var confirm = UIButton(type: .system)
    var cancelBtn = UIButton(type: .system)
    let title = UILabel()
    
    var action: ((Bool) -> Void)?
    
    init(_ msg: String) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.background
        
        layer.masksToBounds = false
        layer.cornerRadius = cornerRadius
        
        // Red Banner setup
        let banner = UIView()
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.backgroundColor = .appRed
        banner.clipsToBounds = true
        banner.layer.cornerRadius = cornerRadius
        banner.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        addSubview(banner)
        
        banner.topAnchor.constraint(equalTo: topAnchor).isActive = true
        banner.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        banner.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        banner.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
        
        title.text = msg
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 15, weight: .heavy)
        title.textAlignment = .center
        title.textColor = .contrast
        title.numberOfLines = 0
        
        addSubview(title)
        title.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15).isActive = true
        // Cancel Button setup
        setupButton(cancelBtn, Language.translate("Cancel"))
        cancelBtn.addTarget(self, action: #selector(cancelBtnEvent), for: .touchUpInside)
        
        // Confirm Button setup
        setupButton(confirm, Language.translate("Yes"))
        confirm.addTarget(self, action: #selector(confirmBtnEvent), for: .touchUpInside)
        
        // Setup constraints
        cancelBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelBtn.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cancelBtn.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        cancelBtn.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        confirm.heightAnchor.constraint(equalToConstant: 40).isActive = true
        confirm.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        confirm.leadingAnchor.constraint(equalTo: centerXAnchor).isActive = true
        confirm.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    func setupButton(_ btn: UIButton, _ title: String) {
        btn.translatesAutoresizingMaskIntoConstraints = false
        addSubview(btn)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.contrast, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .heavy)
    }
    
    // Cancel Button click -> hide
    @objc func cancelBtnEvent() {
        action?(false)
    }
    
    // Confirm Button click -> hide
    @objc func confirmBtnEvent() {
        action?(true)
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Create a cornerRadius + shadow
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
            shadowLayer.fillColor = UIColor.background.cgColor
            
            shadowLayer.shadowColor = UIColor.black.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 10
            
            layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
}

