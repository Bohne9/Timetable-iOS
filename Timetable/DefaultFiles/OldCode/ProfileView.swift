//
//  ProfileView.swift
//  Timetable
//
//  Created by Jonah Schueller on 19.04.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

@objc protocol ProfileMenuDelegate {
   
    @objc func editProfile()
    
    @objc func saveProfile(uid: String, name: String?, email: String?)
    
}

fileprivate enum ProfileState {
    case Edit
    case Save
}

class ProfileMenu: AbstractMenu {
    
    let title = UILabel()
    var delegate: ProfileMenuDelegate?
    
    let edit = UIButton(type: .system)
    
//    var editAd: GADInterstitial!
    
    
    var map: [String : String] {
        get{
            return [
                "name" : view.name.text ?? "",
                "email" : view.email.text ?? "",
                "uid" : Database.userID
                
            ]
        }
    }
    
    private var state = ProfileState.Edit
    private let view: ProfileView
    init(view: ProfileView) {
        self.view = view
        super.init(frame: .zero)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        edit.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(title)
        
        title.text = Language.translate("Profile")
        title.font = UIFont.robotoMedium(18)
        
        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
        title.widthAnchor.constraint(equalToConstant: 100).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        

//        createInterstitial()
        addSubview(edit)
        
        edit.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        edit.tintColor = UIColor(displayP3Red: 30 / 255, green: 30 / 255, blue: 30 / 255, alpha: 1)
        
        edit.topAnchor.constraint(equalTo: topAnchor).isActive = true
        edit.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        edit.widthAnchor.constraint(equalToConstant: 25).isActive = true
        edit.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        edit.addTarget(self, action: #selector(handleEditSave(_:)), for: .touchUpInside)
        
    }
    
    @objc func handleEditSave(_ sender: UIButton) {
        
        switch state {
            
        case .Edit:
//            delegate?.editProfile()
//            loadAd()
            edit.setImage(#imageLiteral(resourceName: "Check"), for: .normal)
            view.isEditable = true
            state = .Save
        case .Save:
            save()
        }
        
    }
    
    func save(){
        if state == .Save{
            Database.database.updateUserInformation(map)
            //            delegate?.saveProfile(uid: view.uid.text!, name: view.name.text, email: view.email.text)
            edit.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
            view.isEditable = false
            _ = view.resignFirstResponder()
            state = .Edit
        }
        
    }
    
    override func close() {
        super.close()
        save()
    }
//
//    private func createInterstitial(){
//        editAd = GADInterstitial(adUnitID: "ca-app-pub-4090633946148380/4546489256")
//
//        // Test adUnitID
////        editAd = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
//        let request = GADRequest()
//        editAd.load(request)
//    }
//
//    private func loadAd(){
//
////        if editAd.isReady {
////            editAd.present(fromRootViewController: ViewController.controller!)
////            createInterstitial()
////        }else {
////            print("EditAd is not ready!")
////        }
//
//    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ProfileView: AbstractView {

    let name = DescribtedTextField("Name")
    let email = DescribtedTextField("Email")
    let uid = DescribtedTextField("User-ID (not editable)")
    
    
    var isEditable: Bool{
        get {
            print("Warning! isEditable Attribute of ProfileView always returns true!!!")
            return true
        }
        set{
            name.textField.isEnabled = newValue
            email.textField.isEnabled = newValue
            setAlpha(newValue ? 1.0 : 0.7)
        }
    }
    
    let stack = UIStackView()
    
    override init() {
        super.init()
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .background
        
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 50
        stack.backgroundColor = .background
        
        name.textField.placeholder = "Name"
        email.textField.placeholder = "Email"
        
        uid.textField.isEnabled = false
        
        isEditable = false

        setupTextFields(name, email, uid)
        
        setContent(stack)
            
    }
    
    private func setupTextFields(_ views: DescribtedTextField...){
        
        for view in views {
            
            stack.addArrangedSubview(view)
            view.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
            view.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
        }
    }

    
    func setValues(_ data: [String : String]){
        name.textField.text = data["name"]!
        email.textField.text = data["email"]!
        uid.textField.text = data["uid"]!
    }
    
    fileprivate func setAlpha(_ to: CGFloat) {
        name.alpha = to
        email.alpha = to
        uid.alpha = to
        
    }
    
    
    override func resignFirstResponder() -> Bool {
        name.resignFirstResponder()
        email.resignFirstResponder()
        uid.resignFirstResponder()
        return super.resignFirstResponder()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
