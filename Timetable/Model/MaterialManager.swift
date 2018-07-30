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
    
    static func getDataFromLocalStorage(_ path: String) -> Data? {
        
        let file = try? FileHandle(forReadingFrom: URL(fileURLWithPath: path))

        if file != nil {
            let data = file!.readDataToEndOfFile()
            file!.closeFile()
            return data
            
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
    
    
    /// The method getMaterial loads data from the local storage in case the client has the data on the device. Otherwise
    /// the data will be downloaded from firebase Storage
    ///
    /// - Parameters:
    ///   - path: Path where the data is located
    ///   - materialID: materialID of the data. This ID should be downloaded from firebase firestore.
    ///   - completion: completion for processing the data. If the material object is not nil there was no error. Otherwise there is an error.
    static func getMaterial(path: String, materialID: String, _ completion: @escaping (Material?, Error?) -> Void){
        print("Downloading material: \(path)")
        // Look if the data is on the local storage
        if materialIsOnLocalStorage(path: path) {
            // If the data can be loaded
            if let data = getDataFromLocalStorage(path) {
                let material = Material(localPath: path, data: data, materialID: materialID)
                completion(material, nil)
            }
        }else {
            // Otherwise download the data from Firebase
            let reference = fireStorage.reference(withPath: path)
            
            // Get the maxDownloadSize from the user settings
            let maxSize = Settings.shared.maxDownloadSize
            
            reference.getData(maxSize: maxSize) { (data, error) in
                guard let data = data else{
                    completion(nil, error!)
                    return
                }
                let url = URL(string: "gs://timetabl-df669.appspot.com\(path)")!
                
                let material = Material(firebasePath: url, data: data, materialID: materialID)
                completion(material, nil)
                
                // If Settings say always store the data on the local store -> do so
                if Settings.shared.alwaysStoreMaterialToLocalStorage {
                    do {
                        // Try to store the data on the local storage
                        try data.write(to: URL(fileURLWithPath: path))
                    }catch {
                        print("Error while trying to save a file on the local device")
                    }
                }
            }
        }
    }
    
    
    // TODO:
    // - Material picker integrieren
    // - Material TableView übersicht anfangen
   
    
    /// Adds the data from the url to Firebase Storage.
    /// Uses the clients userID as owner of the data and adds the data to his material collection
    /// - Parameters:
    ///   - url: URL where the data is stored
    ///   - source: The source where the data comes from. (task, chat, news, ...)
    ///   - sourceID: The ID of the source where the data comes from. TaskID or ChatID and so on...
    ///   - completion: - completion: Callback for if the upload was successfull or not. Material?: if nil = an error occured
    static func addMaterial(url: URL,  source: MaterialSource, sourceID: String, _ completion: @escaping (Material?) -> Void) {
        // Get the data from the local storage
        if let data = getDataFromLocalStorage(url.path) {
            let firestorePath = MaterialManager.path("materials", Database.userID, "materials")
            let dataName = url.lastPathComponent
            let dataType = url.pathExtension
            addMaterial(data: data, dataName: dataName, source: source, sourceID: sourceID, dataType: dataType, firestorePath: firestorePath, completion)
        }else {
            // If data is not available
            completion(nil)
        }
        
    }
    
    
    
    /// Adds the data from the url to Firebase Storage.
    /// Uses the clients userID as owner of the data and adds the data to a custom material path
    /// - Parameters:
    ///   - url: URL where the data is stored
    ///   - source: The source where the data comes from. (task, chat, news, ...)
    ///   - sourceID: The ID of the source where the data comes from. TaskID or ChatID and so on...
    ///   - firestorePath: Path where Metadata should be stored in Firestore.
    ///   - completion: - completion: Callback for if the upload was successfull or not. Material?: if nil = an error occured
    static func addMaterial(url: URL,  source: MaterialSource, sourceID: String, firestorePath: String, _ completion: @escaping (Material?) -> Void) {
        // Get the data from the local storage
        if let data = getDataFromLocalStorage(url.path) {
            let dataName = url.lastPathComponent
            let dataType = url.pathExtension
            addMaterial(data: data, dataName: dataName, source: source, sourceID: sourceID, dataType: dataType, firestorePath: firestorePath, completion)
        }else {
            // If data is not available
            completion(nil)
        }
        
    }
    
    
    
    /// The method addMaterial takes some Data saves it to Firebase Storage and puts the Metadata into Firebase Firestore
    ///
    /// - Parameters:
    ///   - data: Data that should be saved in the cloud
    ///   - source: The source where the data comes from. (task, chat, news, ...)
    ///   - sourceID: The ID of the source where the data comes from. TaskID or ChatID and so on...
    ///   - dataType: Format of the data. .jpg, .pdf and so on
    ///   - firestorePath: Path where Metadata should be stored in Firestore.
    ///   - completion: Callback for if the upload was successfull or not. Material?: if nil = an error occured
    static func addMaterial(data: Data, dataName: String, source: MaterialSource, sourceID: String, dataType: String, firestorePath: String, _ completion: @escaping (Material?) -> Void) {
        
        
        let firestore = Database.database.connection
        
        var reference: DocumentReference? = nil
        
        // This is the path to the Firebase Storage file where the data will be stored.
        var firebasePath = ""
    
        // Metadata of the material. This is stored in Firebase Firestore in the /materials/... collection
        // The data is not complete yet. The path to the Firebase Storage file needs to be added (Firestore documentID required(unknown))
        // The documentID is part of the path where the data will be stored and this path needs to be stored in Firestore.
        var metadata: [String : Any] = [
            "dataName" : dataName,
            "userID" : Database.userID,
            "timestamp" : Timestamp(date: Date())
        ]
        
        // push the metadata to Firestore
        reference = firestore.collection(firestorePath).addDocument(data: metadata) { (error) in
            guard error == nil else {
                completion(nil)
                print("Error while adding Material Metadata to Firestore! Error: \(error!)")
                return
            }
            
            // Now the halfcomplete metadata is successfully stored in Firestore
            
            // Complete the firebase Storage file path
            // Structure: /material/{userID}/{usage (ex. 'task', 'chat', ...)}/{usageID (taskID, chatID,...)}/{Firestore documentID} + data-suffix (.jpg, .pdf, ...)
            firebasePath = path("material", Database.userID, source.rawValue, sourceID, reference!.documentID) + dataType
            
            // Push the file data to Firebase Storage
            _ = uploadMaterial(to: firebasePath, data: data) { (meta, error) in
                guard meta != nil else {
                    print("There was an error while trying to upload a material to Firebase Storage! Error: \(error!.localizedDescription)")
                    completion(nil)
                    return
                }
                
                
                // Complete the metadata. Now the client knows the document ID of the Firestore document
                metadata["storagePath"] = firebasePath
                
                // Again push the metadata(now complete) to Firestore
                firestore.document(firestorePath + "/" + reference!.documentID).setData(metadata, completion: { (error) in
                    guard error == nil else {
                        // Something went wrong -> completion failed
                        completion(nil)
                        return
                    }
                    
                    // Create Material Object out of the data
                    
                    let material = Material(firebasePath: URL(fileURLWithPath: firebasePath), data: data, materialID: reference!.documentID)
                    material.timestamp = Timestamp(date: Date())
                    // Everything was fine, completed successfully!
                    completion(material)
                    
                    if Settings.shared.alwaysStoreMaterialToLocalStorage {
                        do {
                            try data.write(to: URL(fileURLWithPath: firebasePath))
                        }catch {
                            print("Error while trying to store a file on the local device")
                        }
                    }
                })
            }
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
