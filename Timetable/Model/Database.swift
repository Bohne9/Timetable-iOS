//
//  Database.swift
//  Timetable
//
//  Created by Jonah Schueller on 03.03.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import Foundation
import Firebase

class Database {
    
    static let database = Database()
    
    let connection = Firestore.firestore()
    static var userID: String = ""
    
    var timetableDays: [TimetableDay] = []
    
    var subjects = [Subject]()
    var lessons: [String : TimetableLesson] = [:]
    var tasks = [Task]()
    
    var delegate: DataUpdateDelegate!
    
    private var lessonPath: String = ""
    private var subjectPath: String = ""
    private var profilePath: String = ""
    
    init() {
        
        for day in 1...7 {
            let timetableDay = TimetableDay(day: Day(rawValue: day)!)
            timetableDays.append(timetableDay)
        }
        
        let settings = connection.settings
        settings.isPersistenceEnabled = true
        settings.areTimestampsInSnapshotsEnabled = true
        connection.settings = settings
        
    }
    
    func configure(_ completion: @escaping () -> Void) {
        print("configure")
        
        print(path("tasks", "123", "task"))
        
        Auth.auth().signInAnonymously { (user, error) in
            
            if let error = error {
                print("Ups! An error occured: \n\t\(error.localizedDescription)")
            }else if let user = user {
                print("Successfully signed in! User information: \(user.user.uid)")
                Database.userID = user.user.uid
                
                self.lessonPath = "lessons/\(Database.userID)/lessons"
                self.subjectPath = "subjects/\(Database.userID)/subjects"
                self.profilePath = "users/\(Database.userID)/"
                self.addSnapshotListeners()
                
//                self.loadData(completion)
                //tFvwBoI3gYdQ1mPBOgno5pz9gvG2
                //tFvwBoI3gYdQ1mPBOgno5pz9gvG2
            }
        }
    }
    
    func addSnapshotListeners(){
        
        
        // Snapshot Listener for any changes in the lessons field
        connection.collection(lessonPath).addSnapshotListener { (snapshot, error) in
            
            guard let snapshot = snapshot else {
                print("Error in Lessons collection snapshot listener: Error: \(error!.localizedDescription)")
                return
            }
            
            snapshot.documentChanges.forEach({ (doc) in
                
                let data = TimetableLesson(doc.document.data())
                
                data.id = doc.document.documentID
                // print("SnapshotListener: \(data)")
                
                self.setLesson(data)
                
                switch doc.type {
                    
                case .added:
                    self.updateUserInterface(reason: .LessonAdd, data.map)
                case .modified:
                    self.updateUserInterface(reason: .LessonChange, data.map)
                    self.reloadSubjects()
                case .removed:
                    self.lessons.removeValue(forKey: data.id)
                    self.reloadSubjects()
                    self.updateUserInterface(reason: .LessonRemove, data.map)
                    
                }
                
            })
        }
        
        
        connection.collection(subjectPath).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error in Subject collection snapshot listener: Error: \(error.localizedDescription)")
            }else {
                if let snap = snapshot {
                    snap.documentChanges.forEach({ (doc) in
                        
                        var subject = Subject(doc.document.get("lessonName") as! String)
                        subject.id = doc.document.documentID
                        
                        print("Subject from Firebase: \(doc.document.data())")
                        
                        if self.subjects.contains(subject){
                            let index = self.subjects.index(of: subject)!
                            let s = self.subjects[index]
                            s.id = subject.id
                            s.globalIdentifier = doc.document.get("identifier") as? String ?? ""
                            subject = s
                            
                        }else {
                            subject.globalIdentifier = doc.document.get("identifier") as? String ?? ""
                            self.subjects.append(subject)
                            self.addTaskSubjectSnapshotListener(subject: subject)
                        }
                        
                        
                        switch doc.type {
                            
                        case .added:
                            self.updateUserInterface(reason: .SubjectAdd, subject.map)
                        case .modified:
                            self.updateUserInterface(reason: .SubjectChange, subject.map)
                        case .removed:
                            self.subjects.remove(at: self.subjects.index(of: subject)!)
                            self.updateUserInterface(reason: .SubjectRemove, subject.map)
                        }
                        
                        print("Subjects:")
                        self.subjects.forEach({ (s) in
                            print("\t\(s.map)")
                        })
                    })
                }
            }
        }
    
        
        connection.document(profilePath).addSnapshotListener { (snapshot, error) in
            guard let snap = snapshot else {
                print("Error in Subject collection snapshot listener: Error: \(error!.localizedDescription)")
                return
            }
            
            if let data = snap.data() {
                self.updateUserInterface(reason: .ProfileChange, data as! [String : String])
            }else {
                self.insertDefaultUserInformation()
            }
        }
    }
    
    
    
    /// Adds a SnapshotListener to the Firebase Task Collectoin of the subject
    ///
    /// - Parameter subject: Subject for which a Snapshot Listener should be added
    func addTaskSubjectSnapshotListener(subject: Subject) {
        guard subject.globalIdentifier != "" else {
            return
        }
        
        let identifier = subject.globalIdentifier!
        
        // Adding the snapshot listener
        connection.collection("tasks/\(identifier)/tasks").addSnapshotListener { (snapshot, error) in
            guard let snap = snapshot else {
                self.printError("listening for tasks of subject \(identifier)", error!)
                return
            }
            
            for doc in snap.documentChanges {
                
                let task = Task(document: doc.document)
                
                switch doc.type {
                    
                case .added:
                    // When a task was added: Look for the cooresponding subject, add the task and update the userinterface
                    if let subject = self.getSubject(globalIdentifier: task.subjectIdentifier) {
                        self.tasks.append(task)
                        subject.addTask(task: task)
                        self.addTaskMaterialSnapshotListener(task: task)
                        self.updateUserInterface(reason: .TaskAdd, task.map)
                    }
                case .modified:
                    if let t = self.getTask(id: task.taskID) {
                        t.map = task.map
                        self.updateUserInterface(reason: .TaskChange, task.map)
                    }
                    
                case .removed:
                    if let subject = self.getSubject(globalIdentifier: task.subjectIdentifier) {
                        self.tasks.remove(at: self.tasks.index(of: task)!)
                        subject.removeTask(task: task)
                        self.updateUserInterface(reason: .TaskRemove, task.map)
                    }
                }
                
            }
        }
    }
    
    
    
    /// Adds a snapshot listerner to the tasks/{subjectIdentifier}/tasks/{taskID}//material/ collection.
    /// In case the listerner is triggered: Extract the materialPath from the data that comes with it.
    /// With this material path get the metadata from the Material.
    /// MaterialPath = The path to the firestore material document
    /// - Parameter task: Task for the Snapshot listener
    private func addTaskMaterialSnapshotListener(task: Task) {
        let subjectIdentifier = task.subjectIdentifier
        let materialPath = path("tasks", subjectIdentifier, "tasks", task.taskID, "materials")
//        print("Add Material listener")
        connection.collection(materialPath).addSnapshotListener({ (snapshot, error) in
            guard let documents = snapshot?.documentChanges else {
                self.printError("listening for task material", error!)
                return
            }
            
            for doc in documents {
                switch doc.type {
                case .added:
                    // get the material collection path. This path is stored in the task/materials/metaDataPath field
                    let metaDataPath = doc.document.data()["materialPath"] as! String
                    
                    // get the material metadata from firestore
                    self.getMaterialMetadata(materialPath: metaDataPath, { (material, error) in
                        guard let material = material else {
                            self.printError("getting some material metadata", error!)
                            return
                        }
                        print("Got some material: \(material.url.path)")
                        // Add the received material metadata to the task and the subject
                        task.materials.append(material)
                        self.getSubject(globalIdentifier: subjectIdentifier)?.material.append(material)
                    })
                    self.updateUserInterface(reason: .TaskAdd, task.map)
                case .modified:
                    break
                case .removed:
                    break
                }
            
            }
        })
    }
    
    
    
    /// Downloads the metadata for a Material object.
    /// Process: The materialPath is stored in a task, news, or chat document. The materialPath is the path to the matieral document in firestore.
    /// In the material document is the metadata for the material like storagePath, userID, timestamp and so on.
    /// - Parameters:
    ///   - materialPath: Path to the matieral document
    ///   - completion: completion callback, if matieral is nil = error.
    private func getMaterialMetadata(materialPath: String, _ completion: @escaping (Material?, Error?) -> Void) {
        
        connection.document(materialPath).getDocument { (docSnapshot, error) in
            guard let data = docSnapshot?.data() else {
                completion(nil, error!)
                return
            }
            let material = Material(firebasePath: URL(fileURLWithPath: data["storagePath"] as! String), materialID: docSnapshot!.documentID, userID: data["userID"] as! String)
            material.timestamp = data["timestamp"] as! Timestamp
            completion(material, nil)
        }
        
    }
    
    /// Reloads the subjects and removes the ones that have no more lessons
    private func reloadSubjects(){
        
        let subSet = subjects.filter { (sub) -> Bool in
            self.lessons.filter({ (l) -> Bool in
                return l.value.lessonName == sub.lessonName
            }).count == 0
        }
        
        subSet.forEach { (subject) in
            self.deleteSubject(subject.map)
        }
        
    }
    
    
    func getLessonsOf(subject: Subject) -> [TimetableLesson] {
        return lessons.values.filter({ (lesson) -> Bool in
            return lesson.lessonName == subject.lessonName
        })
    }
    
    func setLesson(_ lesson: TimetableLesson) {
        lessons[lesson.id] = lesson
    }
    
    func subjectExists(_ lessonName: String) -> Bool {
        for sub in subjects{
            if sub.lessonName == lessonName {
                return true
            }
        }
        return false
    }
    
    func getTask(id: String) -> Task? {
        for task in tasks {
            if task.taskID == id {
                return task
            }
        }
        return nil
    }
    
    func getSubject(id: String) -> Subject? {
        for subject in subjects {
            if subject.id == id {
                return subject
            }
        }
        return nil
    }
    
    func getSubject(globalIdentifier: String) -> Subject? {
        for subject in subjects {
            if subject.globalIdentifier == globalIdentifier {
                return subject
            }
        }
        return nil
    }
    
    
    func getSubject(_ lessonName: String) -> Subject {
        for sub in subjects{
            if sub.lessonName == lessonName {
                return sub
            }
        }
        
        let subject = Subject(lessonName)
        subjects.append(subject)
        return subject
    }
    
    
    
    private func getTimetableDay(day: Day) -> TimetableDay? {
        for time in timetableDays {
            if time.day == day {
                return time
            }
        }
        
        return nil
    }
    
    
    func addLesson(_ data: [String : String]) {
        
        let lessonName = data["lessonName"]!
        if !subjectExists(lessonName) {
            let subject = Subject(lessonName)
            addSubject(subject.map)
        }
        
        connection.collection(lessonPath).addDocument(data: data, completion: { (error) in
            if let err = error {
                self.printError("adding lesson", err)
            }
        })
    }
    
    func removeLesson(_ data: [String : String]) {
        
        ref("\(lessonPath)/\(data["id"]!)").delete(completion: { (error) in
            if let err = error {
                self.printError("removing a lesson", err)
            }
        })
    }
    
    func updateLesson(_ data: [String : String]) {
        let path = (lessonPath + "/" + data["id"]!)
        
        ref(path).setData(data) {
            (error) in
            if let err = error {
                self.printError("updating a lesson", err)
            }
        }
        
        if !subjectExists(data["lessonName"]!) {
            addSubject(["lessonName": data["lessonName"]!])
        }
    }
    
    
    private func ref(_ path: String) -> DocumentReference {
        return connection.document(path)
    }
    
    
    func addSubject(_ data: [String : String]){
        if !subjectExists(data["lessonName"]!){
            connection.collection("subjects/\(Database.userID)/subjects").addDocument(data: data, completion: { (error) in
                if let err = error{
                    self.printError("adding a subject", err)
                }
            })
        }
    }
    
    func updateSubject(_ data: [String : String]){
        ref("subjects/\(Database.userID)/subjects/\(data["id"]!)").setData(data, completion: { (error) in
            if let err = error{
                self.printError("updating a subject", err)
            }
        })
    }
    
    func deleteSubject(_ data: [String : String]) {
        ref("subjects/\(Database.userID)/subjects/\(data["id"]!)").delete(completion: { (error) in
            if let err = error{
                self.printError("adding a subject", err)
            }
        })
    }
    
    func mapSubject(newName: String, oldName: String) {
        
        let sub = getSubject(oldName)
        
        print("Map Subject: \(sub.map)")
        
        ref("subjects/\(Database.userID)/subjects/\(sub.id)").setData(sub.map) { (error) in
            if let err = error {
                self.printError("updating a subject", err)
            }
        }
        
        var update: [TimetableLesson] = []
        
        for lesson in lessons.values {
            if lesson.lessonName == oldName  {
                update.append(lesson)
            }
        }
        
        update.forEach { (l) in
            l.lessonName = newName
            self.updateLesson(l.map)
        }
        
        // In case subject already exists it won't be added to firebase
        
        if !subjectExists(newName){
            let subject = Subject(newName)
            subject.globalIdentifier = sub.globalIdentifier
            
            addSubject(subject.map)
        }
        deleteSubject(getSubject(oldName).map)
    }
    
    
    /// Requesting, Creating and Updating the user information
    func updateUserInformation(_ data: [String : String]) {
        var d = data
        var n = data["name"]
        if n == nil || n == ""{
            n = UIDevice.current.name
            d["name"] = n
        }
        connection.document(profilePath).setData(d) { (error) in
            if let error = error {
                print("Updating user information failed! Error: \(error)")
            }
        }
    }
    
    
    func insertDefaultUserInformation(){
        let data = ["uid" : Database.userID,
                    "name" : UIDevice.current.name,
                    "email" : ""]
        
        updateUserInformation(data)
    }
    
    
    
    /// Call this method to add a Task to the Firebase Firestore database
    ///
    /// - Parameter data: JSON like Dictionary describing the Task. The Keywords are documented in the Task class.
    func addTask(_ data: [String : String]) {
        let subjectIdentifier = data["subjectID"]!
        
        connection.collection(path("tasks", subjectIdentifier, "tasks")).addDocument(data: data) { (error) in
            if let error = error{
                self.printError("adding a task to subject '\(subjectIdentifier)'", error)
            }
        }
    }
    
    
    /// Method to edit an existing Task in the Firebase Firestore database.
    ///
    /// - Parameter data: JSON like Dictionary describing the Task. The Keywords are documented in the Task class.
    func editTask(_ data: [String : String]) {
        let path = self.path("tasks", data["subjectID"]!, "tasks", data["taskID"]!)
        
        ref(path).setData(data) { (error) in
            if let error = error{
                self.printError("editing a task to subject", error)
            }
        }
    }
    
    /// Method to remove an existing Task from the Firebase Firestore database.
    ///
    /// - Parameter data: JSON like Dictionary describing the Task. The Keywords are documented in the Task class.
    func removeTask(_ data: [String : String]) {
        let path = self.path("tasks", data["subjectID"]!, "tasks", data["taskID"]!)
        
        ref(path).delete { (error) in
            if let error = error{
                self.printError("deleting a task to subject", error)
            }
        }
    }
    
    
    func addMessage(_ subject: Subject, data: [String : Any])  {
        
        if let path = subject.globalIdentifier {
            connection.collection("Chats/\(path)/messages").addDocument(data: data)
        }
    }
    
    
    
    func updateUserInterface(reason: DataUpdateType, _ data: [String : String]) {
        
        switch reason {
            
        case .LessonAdd:
            delegate.lessonAdd(reason: .LessonAdd, data)
        case .LessonChange:
            delegate.lessonChange(reason: .LessonChange, data)
        case .LessonRemove:
            delegate.lessonRemove(reason: .LessonRemove, data)
        case .SubjectAdd:
            delegate.subjectAdd(reason: .SubjectAdd, data)
        case .SubjectChange:
            delegate.subjectChange(reason: .SubjectChange, data)
        case .SubjectRemove:
            delegate.subjectRemove(reason: .SubjectRemove, data)
        case .ProfileChange:
            delegate.profileChange(reason: .ProfileChange, data)
        case .TaskAdd:
            delegate.taskAdd(reason: .TaskAdd, data)
        case .TaskChange:
            delegate.taskChange(reason: .TaskChange, data)
        case .TaskRemove:
            delegate.taskRemove(reason: .TaskRemove, data)
        }
    }
    
    
    func printError(_ msg: String, _ error: Error) {
        print("Error while \(msg) Error: '\(error.localizedDescription)'")
        
    }
    
    func path(_ pathParts: String...) -> String{
        return pathParts.reduce("") { (result, string) in
            result + "/" + string
        }
    }
    
    func timeValueOfToday() -> Int {
        var timeValue = (getCurrentDayNumber() - 1) * 24
        
        let date = Date()
        let calander = Calendar.current
        let comp = calander.dateComponents([.hour, .minute], from: date)
        
        timeValue += comp.hour! + comp.minute!
    
        return timeValue
    }
    
    
    func getCurrentDayNumber() -> Int{
        let num = Calendar.current.dateComponents([.weekday], from: Date()).weekday! - 1
        print("D \(num)")
        return num == 0 ? 7 : num
    }
    
    
    //    private func loadSubjects(_ completion: (()-> Void)? = nil) {
    //        self.subjects = []
    //        connection.collection("subjects").whereField("uid", isEqualTo: Database.userID).getDocuments { (snapshot, error) in
    //            if let error = error {
    //                print("Error while loading the subjects! Error: \(error)")
    //            }else {
    //                for snap in snapshot!.documents {
    //
    //                    let id = snap.documentID
    //                    let lessonName = snap["lessonName"] as! String
    //
    //                    let subject = Subject(lessonName)
    //                    subject.id = id
    //
    //                    self.subjects.insert(subject)
    //                    print("Loaded Subject: '\(lessonName)'")
    //                }
    //                completion?()
    //            }
    //        }
    //    }
    //
    //
    //    func loadLessons(_ completion: @escaping () -> Void) {
    //
    //
    //        // Load subjects
    //        connection.collection(lessonPath).getDocuments(completion: { (snap, error) in
    //            // An error happend
    //            if let error = error {
    //                print("There was an error loading the lesson data from Firebase! Error: \(error.localizedDescription)")
    //            }else {
    //                print("Receive documents")
    //                for doc in snap!.documents {
    //
    //                    let subject = self.getSubject(doc.get("lessonName") as! String)
    //
    //                    let lesson = TimetableLesson(snap: doc, subject: subject)
    //
    //                    self.updateUserInterface(reason: .LessonAdd, lesson.map)
    //
    //                    // Insert into array
    //                    self.getTimetableDay(day: lesson.day)?.lessons.append(lesson)
    //
    //                }
    //            }
    //            completion()
    //        })
    //
    //    }

}

