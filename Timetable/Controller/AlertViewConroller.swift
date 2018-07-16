//
//  AlertViewConroller.swift
//  Timetable
//
//  Created by Jonah Schueller on 26.04.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class AlertViewConroller: UIViewController {

    var container: UIView!
    
    var titleLabel: UILabel?
    var messageLabel: UILabel?
    var buttons: [UIButton] = []
    private var completion: ((_ result: Bool) -> Void)?
    var buttonStack: UIStackView!
    var rootViewController: UIViewController?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func setupEnvironment(){
        container = UIView()
        buttonStack = UIStackView()
        
        container.layer.masksToBounds = false
        container.layer.cornerRadius = 10
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        container.transform = CGAffineTransform(scaleX: 1.0, y: 0)
        view.addSubview(container)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .contrast
        
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        container.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        
        container.addSubview(buttonStack)
        
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        
        
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        
        buttonStack.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        buttonStack.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        buttonStack.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    func setTitle(title: String) {
        
        titleLabel = UILabel()
        titleLabel?.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(titleLabel!)
        titleLabel?.text = title
        titleLabel?.font = UIFont.robotoBold(20)
        
        titleLabel?.topAnchor.constraint(equalTo: container.topAnchor, constant: 5).isActive = true
        titleLabel?.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
        titleLabel?.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20).isActive = true
        titleLabel?.heightAnchor.constraint(equalToConstant: 50).isActive = true

        createLine()
    }
    
    
    func createLine(){
        let line = UIView()
        container.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor).isActive = true
        line.leadingAnchor.constraint(equalTo: titleLabel!.leadingAnchor).isActive = true
        line.trailingAnchor.constraint(equalTo: titleLabel!.trailingAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 2).isActive = true
        line.backgroundColor = .black
        
    }
    
    
    func setMessage(message msg: String){
        if titleLabel == nil {
            fatalError("Error while creating a AlertViewController with message '\(msg)'. Error was thrown because there is no titleLabel specified. Call setTitle(title: String) first!")
        }
        
        messageLabel = UILabel()
        messageLabel?.numberOfLines = -1
        messageLabel?.text = msg
        
        messageLabel?.font = UIFont.robotoMedium(16)
        
        messageLabel?.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(messageLabel!)
        
        messageLabel?.topAnchor.constraint(equalTo: titleLabel!.bottomAnchor, constant: 5).isActive = true
        messageLabel?.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20).isActive = true
        messageLabel?.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20).isActive = true
        messageLabel?.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -5).isActive = true

    }
    
    func addConfirm(_ title: String) {
        
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.font = UIFont.robotoMedium(15)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(handleConfirm(_:)), for: .touchUpInside)
        buttonStack.addArrangedSubview(btn)
    }
    
    func addDismiss(_ title: String) {
        
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.adjustsFontSizeToFitWidth = true
        btn.titleLabel?.font = UIFont.robotoMedium(15)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(handleDismiss(_:)), for: .touchUpInside)
        buttonStack.addArrangedSubview(btn)
    }
    
    
    @objc func handleConfirm(_ sender: UIButton) {
        completion?(true)
        hide { (_) in
            self.dismissAlert()
        }
    }
    
    @objc func handleDismiss(_ sender: UIButton) {
        completion?(false)
        hide { (_) in
            self.dismissAlert()
        }
    }
    
    func dismissAlert(){
        view.removeFromSuperview()
        removeFromParentViewController()
    }
    
    func show(){
        UIView.animate(withDuration: 0.3) {
            self.container.transform = .identity
            self.view.layoutIfNeeded()
        }
    }
    
    func hide(_ compilation: ((Bool) -> Void)?){
        UIView.animate(withDuration: 0.3, animations: {
            self.container.transform = CGAffineTransform(scaleX: 1.0, y: 0)
            self.view.layoutIfNeeded()
        }, completion: compilation)
    }
    
    func build(title: String, message: String, dismiss: String, confirm: String, _ completion: ((_ result: Bool) -> Void)?) {
        setupEnvironment()
        self.completion = completion
        setTitle(title: title)
        setMessage(message: message)
        
        addDismiss(dismiss)
        addConfirm(confirm)
        
    }
    
    func build(title: String, message: String, confirm: String, _ completion: ((_ result: Bool) -> Void)? = nil) {
        setupEnvironment()
        self.completion = completion
        setTitle(title: title)
        setMessage(message: message)
        
        addConfirm(confirm)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            hide { (_) in
                self.dismissAlert()
            }
        }
    }


}
