//
//  ChatCollectionView.swift
//  Timetable
//
//  Created by Jonah Schueller on 09.05.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit
import Firebase


class ChatViewController: UIViewController, UITextFieldDelegate {
    
    let textField = TextField()
    let send = UIButton(type: .system)
    
    let keyboardBar = UIView()
    
    var collectionView: ChatCollectionView = ChatCollectionView(UICollectionViewFlowLayout())
    var bottomConstraint: NSLayoutConstraint!
    
    var subject: Subject {
        get{
            return collectionView.subject
        }
        
        set{
            collectionView.subject = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        view.addSubview(keyboardBar)
        
        keyboardBar.addSubview(textField)
        keyboardBar.addSubview(send)
        
        keyboardBar.backgroundColor = .appDarkWhite
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        keyboardBar.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        send.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .background
        
        bottomConstraint = keyboardBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint.isActive = true
        keyboardBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        keyboardBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        keyboardBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        send.setImage(#imageLiteral(resourceName: "send"), for: .normal)
        send.tintColor = .contrast
        
        send.backgroundColor = UIColor.interaction
        send.layer.masksToBounds = false
        send.layer.cornerRadius = 17.5
        
        send.centerYAnchor.constraint(equalTo: keyboardBar.centerYAnchor).isActive = true
        send.widthAnchor.constraint(equalToConstant: 35).isActive = true
        send.trailingAnchor.constraint(equalTo: keyboardBar.trailingAnchor, constant: -10).isActive = true
        send.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        send.imageEdgeInsets = UIEdgeInsets(top: 8, left: 6.5, bottom: 8, right: 5)
        
//        send.topAnchor.constraint(equalTo: keyboardBar.topAnchor, constant: 10).isActive = true
        
        send.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        textField.backgroundColor = .contrast
        textField.placeholder = "Message"
        textField.isHidden = false
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        textField.font = UIFont.robotoMedium(15)
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 17.5
        
        textField.placeholderColor(UIColor.background.withAlphaComponent(0.6))
        
        textField.centerYAnchor.constraint(equalTo: keyboardBar.centerYAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: keyboardBar.leadingAnchor, constant: 10).isActive = true
        textField.trailingAnchor.constraint(equalTo: send.leadingAnchor, constant: -10).isActive = true
//        textField.topAnchor.constraint(equalTo: keyboardBar.topAnchor, constant: 10).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        
        collectionView.bottomAnchor.constraint(equalTo: keyboardBar.topAnchor, constant: -5).isActive = true

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        send.isEnabled = textField.text != nil
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
        
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        // 3
        let animationDurarion = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 4
        let changeInHeight = (keyboardFrame.height) * (show ? -1 : 1)
        //5
        print("Keyboard height: \(changeInHeight)")
        UIView.animate(withDuration: animationDurarion) {
            self.bottomConstraint.constant += changeInHeight
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func sendMessage(){
        let timestamp = Timestamp(date: Date())
        let content = textField.text!
        let user = Database.userID
        
        let data = ["content" : content, "timestamp" : timestamp, "user" : user] as [String : Any]
        
        Database.database.addMessage(subject, data:  data)
        
        textField.text = ""
        textField.resignFirstResponder()
    }
    
    override func removeFromParentViewController() {
        view.removeFromSuperview()
        super.removeFromParentViewController()
    }
    
    
}


class ChatCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    var subject: Subject! {
        didSet {
            if subject != oldValue {
                messages = []
            }
        }
    }
    var messages: [Message] = []
    var firebasePath: String!
    var lastRef: QueryDocumentSnapshot?
    
    
    init(_ layout: UICollectionViewFlowLayout) {
        super.init(frame: .zero, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        
        register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: "msg")
        
        backgroundColor = .background
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "msg", for: indexPath) as! ChatCollectionViewCell
        cell.message = messages[indexPath.row]
        
        return cell
    }
    
    
    /// Calculate the size of a message box based on the
    /// font and message length
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let msgText = messages[indexPath.item]
        let size = CGSize(width: collectionView.frame.width - 10, height: 2000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        let estSize = NSString(string: msgText.message).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.robotoMedium(14)], context: nil)
        return CGSize(width: size.width, height: estSize.height + 45)
        
    }
    
    
    /// It fetches a batch of messages from Firebase in case the
    /// given subject has a chatPath entry
    func fetchNextMessages(){
        guard let chatPath = subject.globalIdentifier else {
            return
        }
        
        if firebasePath == nil {
            firebasePath = "Chats/\(chatPath)/messages/"
        }
        
        print("Fetch messages")
        
        // In case the first batch will be fetched
        if lastRef == nil {
            // Get the first 50 messages from the server
            let first = Database.database.connection.collection(firebasePath).order(by: "timestamp").limit(to: 50)
            
            first.addSnapshotListener { (snap, error) in
                print("First Snapshot")
                self.processSnapshot(snap, error)
            }
        }
            // For the later batch fetches
        else {
            // Get the next 50 messages batch
            let next = Database.database.connection.collection(firebasePath).order(by: "timestamp").start(afterDocument: lastRef!)
            next.addSnapshotListener { (snap, error) in
                print("Next Snapshot")
                self.processSnapshot(snap, error)
            }
        }
    }
    
    var num: Int = 0
    
    private func processSnapshot(_ snap: QuerySnapshot?, _ error: Error?) {
        guard let snap = snap else {
            print("Error fetching messages! Error: \(error!)")
            return
        }
        
        guard let last = snap.documents.last else {
            // Query is empty
            return
        }
        
        print("Fetch num: \(num)")
        num += 1
        
        self.lastRef = last
        
        for doc in snap.documentChanges {
            
            switch doc.type {
            case .added:
                self.addMessage(doc.document)
            case .modified:
                print("modified")
            case .removed:
                print("removed")
                
            }
        }
        
        self.reloadData()
    }
    
    
    func addMessage(_ snapshot: QueryDocumentSnapshot) {
        let message = Message()
        
        message.messageId = snapshot.documentID
        message.chatID = subject.globalIdentifier
        message.userID = snapshot.get("user") as! String
        message.message = snapshot.get("content") as! String
        message.timestamp = snapshot.get("timestamp") as! Timestamp
        print("Message Added: \(message.message)")
        messages.append(message)
        
        if message.userID == Database.userID {
            
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ChatCollectionViewCell: UICollectionViewCell {
    
    
    let user: UILabel
    let text: UITextView
    
    var message: Message! {
        didSet{
            text.text = message.message
        }
    }
    
    
    override init(frame: CGRect) {
        user = UILabel()
        text = UITextView()
        super.init(frame: frame)
        
        backgroundColor = .contrast
        
        translatesAutoresizingMaskIntoConstraints = false
        user.translatesAutoresizingMaskIntoConstraints = false
        text.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(user)
        
        user.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        user.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        user.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        user.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        addSubview(text)
        
        text.topAnchor.constraint(equalTo: user.bottomAnchor, constant: 5).isActive = true
        text.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5).isActive = true
        text.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5).isActive = true
        text.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        
        text.backgroundColor = .contrast
        text.font = UIFont.robotoMedium(14)
        text.isScrollEnabled = false
        text.isEditable = false
        
        layer.masksToBounds = false
        layer.cornerRadius = 8
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
