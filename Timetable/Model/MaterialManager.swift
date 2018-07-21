//
//  FileManager.swift
//  Timetable
//
//  Created by Jonah Schueller on 17.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import Foundation
import FirebaseStorage
import FirebaseFirestore

enum MaterialSource : String {
    case chat = "chat"
    case task = "task"
    case news = "news"
    case other = "other"
}

class MaterialManager {
    
    static var fireStorage: Storage!
    
    static func initMaterialManager() {
        fireStorage = Storage.storage()
        print("Successfully initalized Firebase Storage!")
    }
    
    static func materialIsOnLocalStorage(path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    static func loadDataFromLocalFile(url: URL) -> Data? {
        let file = try? FileHandle(forReadingFrom: url)
        
        if file != nil {
            return file!.readDataToEndOfFile()
        }
        return nil
    }
    
    static func getMaterialFromLocalStorage(url: URL) -> Material? {
        
        let file = try? FileHandle(forReadingFrom: url)

        if file != nil {
            let data = file!.readDataToEndOfFile()

            let material = Material(localPath: url.path, data: data, materialID: url.path)
            return material
            
        }
        return nil
    }
    
    static func saveMaterialToLocalStorage(material: Material) {
        
    }
    
    static func deleteMaterialFromLocalStorage(material: Material) {
        
    }
    
    static func getStorageReference(for url: String) -> StorageReference{
        let storageRef = fireStorage.reference()
        let ref = storageRef.child(url)
        
        return ref
    }
    
    static func downloadMaterial(from path: String, _ completion: @escaping ((Data?, Error?) -> Void)) -> StorageDownloadTask{
        let pathRef = fireStorage.reference(withPath: path)
        
        return pathRef.getData(maxSize: 1024 * 1024 * 50, completion: completion)
    }
    
    static func downloadMaterial(from path: String, toFile: URL, _ completion: @escaping ((URL?, Error?) -> Void)) -> StorageDownloadTask{
        let pathRef = fireStorage.reference(withPath: path)
        return pathRef.write(toFile: toFile, completion: completion)
    }
    
    static func uploadMaterial(to path: String, data: Data, _ completion: @escaping ((StorageMetadata?, Error?) -> Void)) -> StorageUploadTask {
        let pathRef = fireStorage.reference(withPath: path)
        
        return pathRef.putData(data, metadata: nil, completion: completion)
    }
    
    static func uploadMaterial(to path: String, from url: URL, _ completion: @escaping ((StorageMetadata?, Error?) -> Void)) -> StorageUploadTask {
        let pathRef = fireStorage.reference(withPath: path)
        
        return pathRef.putFile(from: url, metadata: nil, completion: completion)
    }
    
    static func addMaterial(data: Data, source: MaterialSource, sourceID: String, dataType: String, firestorePath: String) {
    
        let firestore = Database.database.connection
        
        var reference: DocumentReference? = nil
        
        // This is the path to the Firebase Storage file where the data will be stored.
        var firebasePath = ""
    
        // Metadata of the material. This is stored in Firebase Firestore in the /materials/... collection
        // The data is not complete yet. The path to the Firebase Storage file needs to be added (Firestore documentID required(unknown))
        // The documentID is part of the path where the data will be stored and this path needs to be stored in Firestore.
        var metadata: [String : Any] = [
            "userID" : Database.userID,
            "timestamp" : Timestamp(date: Date())
        ]
        // push the metadata to Firestore
        reference = firestore.collection(firestorePath).addDocument(data: metadata) { (error) in
            guard error == nil else {
                print("Error while adding Material Metadata to Firestore! Error: \(error!)")
                return
            }
            // Now the halfcomplete metadata is successfully stored in Firestore
            
            // Complete the firebase Storage file path
            // Structure: /material/{userID}/{usage (ex. 'task', 'chat', ...)}/{usageID (taskID, chatID,...)}/{Firestore documentID} + data-suffix (.jpg, .pdf, ...)
            firebasePath = path("material", Database.userID, source.rawValue, sourceID, reference!.documentID) + dataType
            
            // Push the file data to Firebase Storage
            _ = uploadMaterial(to: firebasePath, data: data) { (metadata, error) in
                guard metadata != nil else {
                    print("There was an error while trying to upload a material to Firebase Storage! Error: \(error!.localizedDescription)")
                    return
                }
            }
            
            // Complete the metadata. Now the client knows the document ID of the Firestore document
            metadata["storagePath"] = firebasePath
            
            // Again push the metadata(now complete) to Firestore
            firestore.document(firestorePath + "/" + reference!.documentID).setData(metadata)
        }
    }
    
    
    
    
    
    
    static func addMaterial(url: URL, source: MaterialSource, sourceID: String, firestorePath: String) {
        
        if let data = loadDataFromLocalFile(url: url) {
            
            let firestore = Database.database.connection
            
            var reference: DocumentReference? = nil
            
            let firebasePath = path("material", Database.userID, source.rawValue, sourceID, url.lastPathComponent)
            
            
            let metadata: [String : Any] = [
                "userID" : Database.userID,
                "storagePath" : firebasePath,
                "timestamp" : Timestamp(date: Date())
            ]
            
            reference = firestore.collection(firestorePath).addDocument(data: metadata) { (error) in
                guard error == nil else {
                    print("Error while adding Material Metadata to Firestore! Error: \(error!)")
                    return
                }
                // Successfully uploaded the metadata to Firestore
                print("Added Material Metadata to Firestore!")
                let observer = uploadMaterial(to: firebasePath, data: data) { (metadata, error) in
                    guard let meta = metadata else {
                        print("There was an error while trying to upload a material to Firebase Storage! Error: \(error!.localizedDescription)")
                        return
                    }
                    
                    print("Successfully uploaded the file (\(firestorePath)")
                }
            }
            
//            let path = "/material/\(Database.userID)/\()"
//            print("Added material(\(url.path) to firebase with path: \(firebasePath)")
            // Upload data to Firebase Storage
            
        }else {
            
        }
        
    }
    
    static func path(_ pathParts: String...) -> String{
        return pathParts.reduce("") { (result, string) in
            result + "/" + string
        }
    }
    
//    static func getMaterial(url: URL) -> Material {
//        if materialIsOnLocalStorage(path: url.absoluteString) {
//
//        }
//
//
//    }
    
}
