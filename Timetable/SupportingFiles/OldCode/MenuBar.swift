//
//  MenuBar.swift
//  Timetable
//
//  Created by Jonah Schueller on 16.04.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit


@objc protocol MenuBarDelegate {
    
    @objc func sideMenu()
    
    @objc func today()
    
    @objc func add()
    
}


class MenuBar: UIView{

    private let sideMenuBtn: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(#imageLiteral(resourceName: "Menu"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        return btn
    }()
    
    
    var delegate: MenuBarDelegate? {
        didSet{
            // When this delegate was set
            
            // Update all the touch taregets and remove the old ones
            sideMenuBtn.removeTarget(oldValue, action: #selector(oldValue?.sideMenu), for: .touchUpInside)
            if let delegate = self.delegate {
                sideMenuBtn.addTarget(delegate, action: #selector(delegate.sideMenu), for: .touchUpInside)
            }
            
            today.removeTarget(oldValue, action: #selector(oldValue?.today), for: .touchUpInside)
            if let delegate = self.delegate {
                today.addTarget(delegate, action: #selector(delegate.today), for: .touchUpInside)
            }
            
            add.removeTarget(oldValue, action: #selector(oldValue?.add), for: .touchUpInside)
            if let delegate = self.delegate {
                add.addTarget(delegate, action: #selector(delegate.add), for: .touchUpInside)
            }
        }
    }
    
    var defaultContent: AbstractMenu = AbstractMenu()
    var currentMenuBar: UIView!
    var menuBars = [String: UIView]()
    
    let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private let today = UIButton(type: .system)
    private let add = UIButton(type: .system)
    
    private let title: UILabel! = nil
    
    private var isExpanded = false
    private var expanded: Bool {
        get {
            return isExpanded
        }
        set{
            isExpanded = newValue
           
            UIView.animate(withDuration: 0.15, delay: 0, options: [.curveEaseOut], animations: {
                
                self.constraints.forEach({ (c) in
                    if c.firstAttribute == .height {
                        c.constant = newValue ? 200 : 70
                    }
                })
                self.superview!.layoutIfNeeded()
                    
            }, completion: nil)
                
            
            
        }
    }
    
    init() {
        super.init(frame: .zero)
        constraint()
        AbstractView.defaultMenu = defaultContent
    }
    
    /**
        Sets up the UI for this view
    */
    func constraint() {
        
        backgroundColor = .contrast
        
        addSubview(sideMenuBtn)
        translatesAutoresizingMaskIntoConstraints = false
        defaultContent.translatesAutoresizingMaskIntoConstraints = false
        
        // Setup sidemenu Button
        setupSideMenuButton()
        
        //Setup scroll and stackview
        setupDayIndicator()
        
        // Setup Today and Add Button
        setupButtonBar()
        
        // Add Day Labels to Stack View
        setupDayLabels()
        
        stackView.layoutIfNeeded()
        
        // Set scrollView size
        scrollView.contentSize = stackView.frame.size
        
        scrollView.isScrollEnabled = false
        
        // Add Shadow
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 15
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scrollView.addGestureRecognizer(tap)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        expanded = !expanded
    }
    
    /**
        Sets up the side menu button
    */
    private func setupSideMenuButton(){
        
        sideMenuBtn.centerYAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        sideMenuBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        sideMenuBtn.widthAnchor.constraint(equalToConstant: 40).isActive = true
        sideMenuBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        sideMenuBtn.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        sideMenuBtn.tintColor = UIColor(displayP3Red: 30 / 255, green: 30 / 255, blue: 30 / 255, alpha: 1)
        
    }
    
    /**
      Sets up the ScrollView and the StackView for the day Indicators
    */
    private func setupDayIndicator() {
        
        // Setup ScrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        defaultContent.addSubview(scrollView)
        
        scrollView.topAnchor.constraint(equalTo: defaultContent.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: defaultContent.leadingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        scrollView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        // Setup StackView
        stackView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
    }
    
    /**
     Sets up the button bar with the Today Button and the Add Button
     */
    
    private func setupButtonBar() {
        
        defaultContent.addSubview(add)
        
        add.tintColor = .contrastLighter
//        add.layer.masksToBounds = false
//        add.layer.cornerRadius = 20
//        add.backgroundColor = .interaction
        add.tintColor = .interaction
//        add.tintColor = UIColor(displayP3Red: 30 / 255, green: 30 / 255, blue: 30 / 255, alpha: 1)
        add.translatesAutoresizingMaskIntoConstraints = false
        add.setImage(#imageLiteral(resourceName: "Plus"), for: .normal)
        
        
        add.topAnchor.constraint(equalTo: defaultContent.topAnchor, constant: -10).isActive = true
        add.widthAnchor.constraint(equalToConstant: 40).isActive = true
        add.heightAnchor.constraint(equalToConstant: 40).isActive = true
        add.trailingAnchor.constraint(equalTo: defaultContent.trailingAnchor).isActive = true
        add.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        
        defaultContent.addSubview(today)
        
//        today.tintColor = .interaction
        today.tintColor = UIColor(displayP3Red: 30 / 255, green: 30 / 255, blue: 30 / 255, alpha: 1)
        today.translatesAutoresizingMaskIntoConstraints = false
        
        let num = getCurrentDayNumber()
        print(num)
        let str = Language.shared.getTranslation("Day_\(Day(rawValue: getCurrentDayNumber())!)")
        let des = str[str.startIndex...str.index(str.startIndex, offsetBy: 1)]
        
        today.setTitle(String(des), for: .normal)
        today.titleLabel!.textAlignment = .center
        today.titleLabel!.font = UIFont.robotoMedium(18)
        
        today.topAnchor.constraint(equalTo: defaultContent.topAnchor).isActive = true
        today.widthAnchor.constraint(equalToConstant: 30).isActive = true
        today.heightAnchor.constraint(equalToConstant: 25).isActive = true
        today.trailingAnchor.constraint(equalTo: add.leadingAnchor, constant: -20).isActive = true
        
    }
    
    
    func addMenuBar(_ key: String, _ bar: UIView) {
        menuBars[key] = bar
        
        bar.isHidden = true
        addSubview(bar)
        
        bar.centerYAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        bar.leadingAnchor.constraint(equalTo: sideMenuBtn.trailingAnchor, constant: 40).isActive = true
        bar.heightAnchor.constraint(equalToConstant: 20).isActive = true
        bar.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
    }
    
    
    func loadMenuBar(key: String){
        if let view = menuBars[key] {
            if view == defaultContent {
                view.alpha = 1
                currentMenuBar?.isHidden = true
                
            }else {
                defaultContent.alpha = 0
            }
            
            currentMenuBar = view
            view.isHidden = false
        }
    }
    
    
//    func createTitle
    
    /**
     
     Creates the day indicator labels and adds them to the stackview
     
     */
    private func setupDayLabels() {
        
        for i in 1...7 {
            let day = UILabel()
            
            day.translatesAutoresizingMaskIntoConstraints = false
            day.heightAnchor.constraint(equalToConstant: 20).isActive = true
            day.widthAnchor.constraint(equalToConstant: 150).isActive = true
            day.text = Language.translate("Day_\(Day(rawValue: i)!)")
            day.font = UIFont.robotoMedium(18)
            
            stackView.addArrangedSubview(day)
        }
    }
    
    
    /**
        Returns the number of the current day -> Monday: 1 Tuesday: 2 ...
    */
    func getCurrentDayNumber() -> Int{
        let num = Calendar.current.dateComponents([.weekday], from: Date()).weekday! - 1
        // In the Calander Sunday is equal to 0 but in the Day enum sunday is 7
        return num == 0 ? 7 : num
    }
    
    /**
        Returns the name of the current day
    */
    func getCurrentDay() -> String {
        let date = DateFormatter()
        date.dateFormat = "EEEE"
        return date.string(from: Date())
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
