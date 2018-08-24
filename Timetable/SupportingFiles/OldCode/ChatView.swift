//
//  ChatView.swift
//  Timetable
//
//  Created by Jonah Schueller on 28.04.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit
import FirebaseFirestore


enum ChatState {
    case Start
    case Join
    case Create
    case Reset
    case Rank1
    case Rank2
}

fileprivate protocol ChatTransitionDelegate {
    
    func start()
    
    func join()
    
    func create()
    
    func reset()
    
    func rank1()
    
    func rank2()
    
}


class ChatMenu: AbstractMenu {
    
    let title = UILabel()
    
    private let view: ChatView
    
    init(view: ChatView) {
        self.view = view
        super.init(frame: .zero)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(title)
        
        title.font = UIFont.robotoMedium(18)
        
        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
        title.widthAnchor.constraint(equalToConstant: 100).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        title.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
    }
    
    override func close() {
        super.close()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//       *
//       *  Start ChatView class
//       *
//       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



class ChatView: AbstractView, ChatTransitionDelegate  {
    
    var subject: Subject!
    
    let nextLesson: DescribtedTextField
    
    var joinBtn: UIButton!
    var done: UIButton!
    var chat: UIButton!
    var tasks: UIButton!
    let chatPath: DescribtedTextField
    
    var collectionView: ChatCollectionView!
    
    let titleImage = UIImageView()
    
    var currentCVC: ChatViewController!
    var viewControllers: [Subject : ChatViewController] = [:]
    var isPresentingChat: Bool = false
    
    private let stack = UIStackView()
    
    override init() {
        nextLesson = DescribtedTextField(Language.translate("Chat_NextLesson"))
        chatPath = DescribtedTextField("Chat-ID")
        
        super.init()
        translatesAutoresizingMaskIntoConstraints = false
        
        setupUserInterface()
        
        super.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //       *
    //       *  End of Init-Methods - Start of "Setup joining chat room ui"
    //       *
    //       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    /// "Join an existing subject chat tap action"
    ///
    /// - Parameter sender: joinBtn Button
    @objc func joinAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2) {
            self.joinBtn.alpha = 0.0
            self.joinBtn.transform = CGAffineTransform(scaleX: 0.7, y: 1)
            
            self.chatPath.alpha = 1.0
            self.chatPath.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            self.done.alpha = 1.0
            self.done.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    
    /// When user typed in a subject chat ID
    ///
    /// - Parameter sender: done Button
    @objc func doneAction(_ sender: UIButton) {
        let path = chatPath.text
        
        if let path = path {
//            print("Joining Subject chat: \(path)")
            let con = Database.database.connection
            con.document("Chats/\(path)").getDocument { (doc, error) in
                if let error = error {
                    print("Error while getting a subject chat path: )")
                    return
                }
                guard let doc = doc else {
                    print("")
                    return
                }
                
                if !doc.exists{
                    self.subjectChatDoesntExist()
                    print("Document doesnt exists")
                    return
                }
                
                print("Subject Path Data: \(doc.data())")
                var data = self.subject.map
                data["chatPath"] = path
                Database.database.updateSubject(data)
                self.joinChatAnimation()
                self.subject.globalIdentifier = path
                self.loadChatOfSubject()
            }
            
        }else {
            chatPath.shake()
        }
    }
    
    private func joinChatAnimation(){
        UIView.animate(withDuration: 0.2) {
//            self.joinBtn.alpha = 1.0
//            self.joinBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
            
//            self.chatPath.alpha = 0.0
//            self.chatPath.transform = CGAffineTransform(scaleX: 0.7, y: 1)
            
            self.chat.alpha = 1.0
            
            self.chat.transform = CGAffineTransform(scaleX: 1, y: 1)
            
            self.done.alpha = 0.0
            self.done.transform = CGAffineTransform(scaleX: 0.7, y: 1)
            
        }
    }
    
    
    
    private func subjectChatDoesntExist(){
//        ViewController.controller!.presentAlertView(title: "Warning", message: "Ups! That subject Id does not exits. Check the spelling!", confirm: "Ok")
    }
    
    @objc func chatLoadAction() {
        isPresentingChat = true
        presentChatViewController(currentCVC)
    }
    
    private func loadChatOfSubject() {
        updateContentSize()
        
        currentCVC.subject = subject
        currentCVC.collectionView.fetchNextMessages()
        
    }
    
    @objc func rotate() {
        
        
    }
    
    
    /// Loads the view based on the subject rank
    func loadChatPreview() {
        if subject.hasIdentifier() {
            doneAction(joinBtn)
        }
        
        
    }
    
    // LOGIC
    
    
    func changeState(_ nextState: ChatState) {
        switch nextState {
        case .Start:
            start()
        case .Join:
            join()
        case .Create:
            create()
        case .Reset:
            reset()
        case .Rank1:
            rank1()
        case .Rank2:
            rank2()
        }
    }
    
    func start(){
        
    }
    
    func join(){
        joinChatAnimation()
    }
    
    func create(){
        
    }
    
    func reset(){
        
    }
    
    func rank1(){
        
    }
    
    func rank2(){
        
    }
    
    
    
    
    //       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //       *
    //       *
    //       *
    //       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //       *
    //       *  UI SETUP
    //       *
    //       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //       *
    //       *
    //       *
    //       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    private func setupUserInterface() {
        
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .equalSpacing
        stack.spacing = 30
        stack.backgroundColor = .background
        
        // Create and constraint subject icon
        titleImage.image = #imageLiteral(resourceName: "informatik").withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        titleImage.translatesAutoresizingMaskIntoConstraints = false
        titleImage.contentMode = .scaleAspectFit
        
        stack.addArrangedSubview(titleImage)
        titleImage.widthAnchor.constraint(equalToConstant: 150).isActive = true
        titleImage.heightAnchor.constraint(equalTo: titleImage.widthAnchor).isActive = true
        titleImage.tintColor = .contrast
        
        NotificationCenter.default.addObserver(self, selector: #selector(rotate), name: .UIDeviceOrientationDidChange, object: nil)
        
        stack.addArrangedSubview(nextLesson)
        nextLesson.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        nextLesson.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
        nextLesson.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        //       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        //       *
        //       *  Setup "joining a chat room"
        //       *
        //       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        // Setup joinBtn button
        joinBtn = UIButton(type: .system)
        // Attibuted String with attrs: Font, Underline, Foreground Color
        let joinText = NSAttributedString(string: "Join a Subject chat ", attributes: [.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
                                                                           .font: UIFont.robotoMedium(16), .foregroundColor : UIColor.contrast])
        joinBtn.setAttributedTitle(joinText, for: .normal)
        joinBtn.addTarget(self, action: #selector(joinAction(_:)), for: .touchUpInside)
        
        stack.addArrangedSubview(joinBtn)
        joinBtn.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        joinBtn.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
        joinBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        // Setup done button
        done = UIButton(type: .system)
        // Attibuted String with attrs: Font, Underline, Foreground Color
        let doneText = NSAttributedString(string: Language.translate("Done"), attributes: [.underlineStyle : NSUnderlineStyle.styleSingle.rawValue,
                                                                               .font: UIFont.robotoMedium(16), .foregroundColor : UIColor.contrast])
        done.setAttributedTitle(doneText, for: .normal)
        done.addTarget(self, action: #selector(doneAction(_:)), for: .touchUpInside)
        
        stack.addArrangedSubview(done)
        done.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        done.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
        done.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        // Setup chatPath textfield
        chatPath.textField.placeholder = "Insert Chat-ID of existing chat"
        
        stack.addSubview(chatPath)
        chatPath.topAnchor.constraint(equalTo: joinBtn.topAnchor).isActive = true
        chatPath.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        chatPath.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
        chatPath.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        chatPath.alpha = 0.0
        chatPath.transform = CGAffineTransform(scaleX: 0.7, y: 1)
        
        done.alpha = 0.0
        done.transform = CGAffineTransform(scaleX: 0.7, y: 1)
        
        
        //       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        //       *
        //       *  Setup Chat Button
        //       *
        //       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        chat = UIButton(type: .system)
        chat.setTitle("Chat", for: .normal)
        chat.setTitleColor(.contrast, for: .normal)
        chat.titleLabel!.font = .robotoMedium(18)
//        chat.titleLabel?.textAlignment = .right
        chat.contentHorizontalAlignment = .left
        
        chat.translatesAutoresizingMaskIntoConstraints = false
        
        let chatImg = UIImageView(image: #imageLiteral(resourceName: "next").withRenderingMode(.alwaysTemplate))
        chatImg.tintColor = .contrast
//        chatImg.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        chat.addSubview(chatImg)
        
        chatImg.translatesAutoresizingMaskIntoConstraints = false
        chatImg.centerYAnchor.constraint(equalTo: chat.centerYAnchor).isActive = true
        chatImg.heightAnchor.constraint(equalToConstant: 20).isActive = true
        chatImg.widthAnchor.constraint(equalToConstant: 20).isActive = true
        chatImg.trailingAnchor.constraint(equalTo: chat.trailingAnchor).isActive = true
        
        stack.addSubview(chat)
        
        chat.topAnchor.constraint(equalTo: chatPath.bottomAnchor, constant: 20).isActive = true
        chat.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
        chat.trailingAnchor.constraint(equalTo: stack.trailingAnchor).isActive = true
        chat.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
//        chat.titleLabel!.transform = CGAffineTransform(translationX: 100, y: 0)
        
//        chat.titleLabel!.transform
        
        chat.alpha = 0.0
        chat.transform = CGAffineTransform(scaleX: 0.7, y: 1)
        
        chat.addTarget(self, action: #selector(chatLoadAction), for: .touchUpInside)
        
        // Add stack view to superview
        setContent(stack)
        
    }
    
    
    
    
    //       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    //       *
    //       *  General Methods
    //       *
    //       *++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
    
    func presentChatViewController(_ vc: ChatViewController) {
        
//        ViewController.controller!.presentChildViewController(vc)
        
    }
    
    
    /// Subject icon scale when user bounces up
    ///
    /// - Parameter scrollView: -
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            let scale = min(max((-scrollView.contentOffset.y + 50) / 75, 1), 1.75)
            
            titleImage.transform = CGAffineTransform(scaleX: scale, y: scale)
            
        }
    }
    
    
    /// Called when the ChatView will be loaded
    ///
    /// - Parameter data: Subject which chat/detail view was clicked
    override func open(_ data: Any?) {
        
        if let subject = data as? Subject {
            self.subject = subject

            isPresentingChat = false
            if viewControllers[subject] == nil {
                let vc = ChatViewController()
                vc.subject = subject
                viewControllers[subject] = vc
            }
            
            if subject.hasIdentifier() {
                loadChatPreview()
            }
            
            currentCVC = viewControllers[subject]
            (menu as! ChatMenu).title.text = subject.lessonName
            
            let next = searchForNextLesson()
            let nxtStr = "\(Language.translate("Day_\(next.day)")) - \(next.startTime.description) - \(next.endTime.description)"
            nextLesson.text = nxtStr
            print("Next Lesson: \(searchForNextLesson())")
        }
    }
    
    
    override func close() {
        super.close()
     
        if isPresentingChat {
            currentCVC.removeFromParentViewController()
        }
    }
    
    
    /// Searches for the next lesson of this subject
    ///
    /// - Returns: The Timetablelesson Object of the next lesson
    private func searchForNextLesson() -> TimetableLesson{
        let now: Double = Double(Database.database.timeValueOfToday())
        var lessons = Database.database.getLessonsOf(subject: subject).sorted { (l, r) -> Bool in
            let disL = l.startValue - now
            if disL < 0 {
                return false
            }
            let disR = r.startValue - now
            
            return disL < disR
        }
        
        lessons.sort()
        
        return lessons.first!
    }
    
    
    /// Overriden setContent
    /// Reduces the offset to the topbar
    /// - Parameter content: contentView
    override func setContent(_ content: UIView) {
        addSubview(content)
        
        content.translatesAutoresizingMaskIntoConstraints = false
        self.content = content
        
        content.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        content.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        content.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        content.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        content.widthAnchor.constraint(equalTo: widthAnchor, constant: -40).isActive = true
        
        updateContentSize()
    }
}






