//
//  SubjectViewController.swift
//  Timetable
//
//  Created by Jonah Schueller on 27.06.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//


import UIKit

class SubjectViewController: UIViewController, UIGestureRecognizerDelegate {

    // Init UI-Subview elements
    var subject: Subject? {
        didSet{
            reloadData()
        }
    }
    
    let stackView = UIStackView()
    
    lazy var subjectImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .appWhite
        imgView.image = #imageLiteral(resourceName: "informatik").withRenderingMode(.alwaysTemplate)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        return imgView
    }()
    
    
    lazy var titleLabel: TextField = {
        let label = TextField()
        label.font = UIFont.robotoBold(30)
        label.textColor = .appWhite
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        
        return label
    }()
    
    lazy var chatId: DescribtedTextField = {
        let tf = DescribtedTextField("Subject Identifier")
        
        return tf
    }()
    
    
    var subjectTaskDetailTableView = SubjectTaskDetailTableView()
    
//    var subjectTaskDetailView = SubjectTaskDetailView()
    
    lazy var dismiss: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "Cross").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.imageView!.tintColor = .appWhite
        btn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn)
        btn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        btn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        btn.widthAnchor.constraint(equalToConstant: 25).isActive = true
        btn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        btn.titleEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        return btn
    }()
    
    var panGesture: UIPanGestureRecognizer!
    var animator: UIViewPropertyAnimator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = .appWhite

        view.backgroundColor = .background
        
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        
        view.addSubview(stackView)
        stackView.constraint(to: view.safeAreaLayoutGuide, topOffset: 30, leading: 20, trailing: -20, bottom: -50)
        
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center

        constraintUserInterface()
        
        chatId.textField.placeholder = "Click to add Chat usage"
        chatId.textField.textColor = .appWhite
        chatId.descrLabel.textColor = .gray
        chatId.line.backgroundColor = .appWhite
        chatId.textField.textAlignment = .center
        
        dismiss.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        // Do any additional setup after loading the view.
        
        
        view.addSubview(subjectTaskDetailTableView)
        subjectTaskDetailTableView.constraint(to: view.safeAreaLayoutGuide)
        subjectTaskDetailTableView.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
        
        
        createTopShadowBlocker()
        
        addPanGesture()
        
//        view.addSubview(subjectTaskDetailView)
//        subjectTaskDetailView.constraint(to: view.safeAreaLayoutGuide)
//        subjectTaskDetailView.transform = CGAffineTransform(translationX: view.frame.width, y: 0)
    }
    
    
    private func addPanGesture(){
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        panGesture.delegate = self
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return panGesture.velocity(in: view).y > 0
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer){
        
        let translation = gesture.translation(in: view)
        let fraction = translation.y / view.frame.height
        switch gesture.state {
        case .began:
            prepareDismiss()
            animator.pauseAnimation()
//            ViewController.controller.statusBarStyle = .lightContent
        case .changed:
            animator.fractionComplete = fraction
        case .ended:
            
            let velocity = gesture.velocity(in: view)
            
            if velocity.y < 0 || fraction <= 0.05{
                animator.isReversed = true
            }
            
            let duration =  1.0 - animator.fractionComplete
            
            animator.continueAnimation(withTimingParameters: nil, durationFactor: duration)
            
        default:
            print("Default case of SubjectViewController panGesture handler dismiss")
        }
        
        
    }
    
    func constraintUserInterface(){
        
        stackView.addArrangedSubview(subjectImage)
        subjectImage.widthAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
        subjectImage.heightAnchor.constraint(lessThanOrEqualToConstant: 150).isActive = true
    
        stackView.addArrangedSubview(titleLabel)
        titleLabel.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        let task = createMenuButton(title: Language.translate("Tasks"))
        let news = createMenuButton(title: Language.translate("News"))
        let char = createMenuButton(title: Language.translate("Chat"))
        let materials = createMenuButton(title: Language.translate("Materials"))
        
        task.addTarget(self, action: #selector(fadeSubjectTaskDetailViewIn), for: .touchUpInside)
        
        subjectTaskDetailTableView.dismiss.addTarget(self, action: #selector(fadeSubjectTaskDetailViewOut), for: .touchUpInside)
        
        stackView.addArrangedSubview(chatId)
        
        chatId.heightAnchor.constraint(equalToConstant: 60).isActive = true
        chatId.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        
    }
    
    
    private func createTopShadowBlocker(){
        let shadowBlocker = UIView()
        shadowBlocker.backgroundColor = .background
        
        shadowBlocker.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(shadowBlocker)
        shadowBlocker.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        shadowBlocker.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        shadowBlocker.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        shadowBlocker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
    }
    
    
    private func createMenuButton(title: String, image: UIImage = #imageLiteral(resourceName: "next")) -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(.appWhite, for: .normal)
        btn.titleLabel?.font = UIFont.robotoBold(20)
        
        btn.contentHorizontalAlignment = .left
        
        let img = UIImageView(image: image.withRenderingMode(.alwaysTemplate))
        img.tintColor = .appWhite
        img.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addSubview(img)
        
        img.centerYAnchor.constraint(equalTo: btn.centerYAnchor).isActive = true
        img.trailingAnchor.constraint(equalTo: btn.trailingAnchor, constant: -5).isActive = true
        img.widthAnchor.constraint(equalToConstant: 25).isActive = true
        img.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        stackView.addArrangedSubview(btn)
        btn.heightAnchor.constraint(lessThanOrEqualToConstant: 50).isActive = true
        btn.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        
        return btn
    }
    
    func open(task: Task, subject: Subject) {
        self.subject = subject
        subjectTaskDetailTableView.transform = .identity
        view.layoutIfNeeded()
        subjectTaskDetailTableView.open(task, subject)
    }
    
    
    
    ///
    /// - Parameter inOut: 0 = in, 1 out
    private func fadeSubjectTaskDetailView(inOut: CGFloat){
        UIView.animate(withDuration: 0.2) {
            self.subjectTaskDetailTableView.transform = CGAffineTransform(translationX: self.view.frame.width * inOut, y: 0)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func fadeSubjectTaskDetailViewIn(){
        fadeSubjectTaskDetailView(inOut: 0)
    }
    @objc func fadeSubjectTaskDetailViewOut(){
        fadeSubjectTaskDetailView(inOut: 1)
    }
    
    func reloadData(){
        
        if let sub = subject{
            subjectTaskDetailTableView.subject = subject
            titleLabel.text = sub.lessonName
            chatId.text = sub.globalIdentifier
        }
    }

    @objc func handleDismiss(){
//        ViewController.controller.dismiss(animated: true, completion: nil)
        prepareDismiss()
//        ViewController.controller.statusBarStyle = .lightContent
    }
    
    
    func prepareDismiss(){
        animator = UIViewPropertyAnimator(duration: 0.25, curve: .easeInOut, animations: {
            self.view.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            self.view.alpha = 0.0
            self.view.layoutIfNeeded()
        })
        
        animator.startAnimation()
    }
    
    func present(){
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
            self.view.transform = .identity
            self.view.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: nil)
//        ViewController.controller.statusBarStyle = .default
    }

    
}










