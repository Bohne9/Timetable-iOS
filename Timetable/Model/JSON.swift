//
//  JSON.swift
//  Timetable
//
//  Created by Jonah Schueller on 26.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import Firebase
import FirebaseFirestore

protocol DocumentChangeDelegate {
    func documentAdd(_ data: JSONRepresentation, _ error: Error?)
    
    func documentUpdate(_ data: JSONRepresentation, _ error: Error?)
    
    func documentDelete(_ data: JSONRepresentation, _ error: Error?)
}

extension DocumentChangeDelegate {
    func documentListener(_ data: JSONRepresentation, _ document: DocumentSnapshot?, _ error: Error?) {
        guard let document = document else {
            print("DocumentChangeDelegate.documentListener Error!: Message: \(error?.localizedDescription)")
            return
        }
        
    }
}

class JSONRepresentation: DocumentChangeDelegate {
    
    subscript(key: String) -> Any?{
        get{
            return getValue(for: key)
        }
        set{
            setValue(for: key, with: newValue)
        }
    }
    
    var pathPrefix: String{
        return "--pathPrefix not definied--"
    }
    
    var id: String! {
        get{ return getString(for: "id") }
        set{ setValue(for: "id", with: newValue) }
    }
    
    var userID: String!{
        get{ return getString(for: "userID") }
        set{ setValue(for: "userID", with: newValue) }
    }
    
    var delegate: DocumentChangeDelegate
    
    init(_ data: [String: Any]) {
        fromJSON(data)
        delegate = self
    }
    
    internal var json = [String : Any]()
    
    func toJSON() -> [String : Any] {
        return json
    }
    
    func fromJSON(_ data: [String : Any]) {
        json = data
    }

    func setValue(for key: String, with value: Any?) {
        json[key] = value
    }
    
    func getValue(for key: String) -> Any? {
        return json[key]
    }
 
    func nilValue(for key: String) {
        setValue(for: key, with: nil)
    }
    
    // Some helper Methods
    
    func getString(for key: String) -> String {
        return getValue(for: key) as! String
    }
    
    func getTimestamp(for key: String) -> Timestamp {
        return getValue(for: key) as! Timestamp
    }
    
    func getHexColor(for key: String) -> UIColor {
        return UIColor(hexString: getString(for: key))
    }
    
    func getInt(for key: String) -> Int {
        return getValue(for: key) as! Int
    }
    
    func getDouble(for key: String) -> Double {
        return getValue(for: key) as! Double
    }
    
    // Nil Save Methods
    
    func getOptionalString(for key: String) -> String? {
        return getValue(for: key) as? String
    }
    
    func getOptionalTimestamp(for key: String) -> Timestamp? {
        return getValue(for: key) as? Timestamp
    }
    
    func getOptionalHexColor(for key: String) -> UIColor? {
        return UIColor(hexString: getOptionalString(for: key) ?? "#000000")
    }
    
    func getOptionalInt(for key: String) -> Int? {
        return getValue(for: key) as? Int
    }
    
    func getOptionalDouble(for key: String) -> Double? {
        return getValue(for: key) as? Double
    }
    
    func getIdentifier() -> String? {
        return getOptionalString(for: "id")
    }
    
    func getTimestamp() -> Timestamp? {
        return getOptionalTimestamp(for: "timestamp")
    }
    
    func firestorePath() -> String? {
        fatalError("firestorePath is not implemented!")
    }
    
    func firestoreCollectionPath() -> String{
        fatalError("firestoreCollectionPath is not implemented!")
    }
    
    func path(_ pathParts: String...) -> String{
        return pathParts.reduce("") { (result, string) in
            result + "/" + string
        }
    }
    
    
    
    
    func documentAdd(_ data: JSONRepresentation, _ error: Error?) {
        if let error = error {
            print("Error! \(error.localizedDescription)")
            return
        }
        print("Document added")
    }
    
    func documentUpdate(_ data: JSONRepresentation, _ error: Error?) {
        if let error = error {
            print("Error! \(error.localizedDescription)")
            return
        }
        print("Document updated")
    }
    
    func documentDelete(_ data: JSONRepresentation, _ error: Error?) {
        if let error = error {
            print("Error! \(error.localizedDescription)")
            return
        }
        print("Document updated")
    }
    
    func documentListener(_ data: JSONRepresentation, _ document: DocumentSnapshot?, _ error: Error?) {
        guard let document = document else {
            print("Error! \(error!.localizedDescription)")
            return
        }
        let state = document
        switch <#value#> {
        case <#pattern#>:
            <#code#>
        default:
            <#code#>
        }
    }
    
    
    func writeToFirestore(){
        let firestore: Firestore = Database.database.connection
        if let path = firestorePath() {
            let data = toJSON()
            firestore.document(path).setData(data) { (error) in
                self.delegate.documentUpdate(self, error)
            }
        }else {
            let collectionPath = firestoreCollectionPath()
            let data = toJSON()
            var reference: DocumentReference!
            reference = firestore.collection(collectionPath).addDocument(data: data, completion: { (error) in
                self.delegate.documentAdd(self, error)
            })
            reference.addSnapshotListener { (document, error) in
                
                self.delegate.documentListener(self, document, error)
            }
        }
    }
    
    func deleteFromFirestore(){
        let firestore: Firestore = Database.database.connection
        if let path = firestorePath() {
            firestore.document(path).delete { (error) in
                self.delegate.documentDelete(self, error)
            }
        }
    }
    
    
}
