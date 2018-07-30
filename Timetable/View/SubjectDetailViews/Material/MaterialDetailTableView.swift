//
//  MaterialDetailTableView.swift
//  Timetable
//
//  Created by Jonah Schueller on 22.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit
import QuickLook

enum MaterialTimeInterval: String{
    
    typealias RawValue = String
    
    case today = "Today"
    case week = "This week"
    case previous = "MoreThanAWeek"
}


class MaterialDetailTableView: MasterDetailTableView<Material>, UITableViewDelegate, UITableViewDataSource, QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
    
    var subject: Subject? {
        didSet{
            if let subject = subject {
                titleLabel.text = "\(subject.lessonName)\n\(titleExtension)"
                data = subject.material
                reload()
            }
        }
    }
    
    private var todayMaterial = [Material]()
    private var weekMaterial = [Material]()
    private var previousMaterial = [Material]()
    
    private var materialToPreview: Material?
    private var urlToPreview: URL?
    
    private let headerIdentifier = "MaterialTableViewHeader"
    
    var dataStorage = [(timeInterval: MaterialTimeInterval, data: [Material])]()
    
    init() {
        super.init(frame: .zero)
        
        dismissImage = #imageLiteral(resourceName: "back")
        titleExtension = Language.translate("Materials")
        
        cellIdentifier = "materialCellIdentifier"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MaterialDetailTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.register(MaterialDetailTableViewCellHeader.self, forHeaderFooterViewReuseIdentifier: headerIdentifier)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStorage[section].data.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataStorage.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MaterialDetailTableViewCell
        let material = dataStorage[indexPath.section].data[indexPath.row]
        cell.setValues(material: material, type: dataStorage[indexPath.section].timeInterval)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! MaterialDetailTableViewCellHeader
        header.titleLabel.text = Language.translate(dataStorage[section].timeInterval.rawValue)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: true)
        
        let material = dataStorage[indexPath.section].data[indexPath.row]
        
        previewMaterial(indexPath: indexPath)
    }
    
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        if let url = urlToPreview {
            controller.title = materialToPreview!.dataName
            return url as QLPreviewItem
        }
        
//        if let material = materialToPreview {
////            print(material.url)
////
//            let item = URL(dataRepresentation: material.data!, relativeTo: nil)
//
//            print(item!.pathExtension)
//
//            return item! as QLPreviewItem
//
////            return URL(fileURLWithPath: url.path) as! QLPreviewItem
//        }
        return URL(string: "Ups! There was an error. :(")! as QLPreviewItem
    }
    
    func previewMaterial(indexPath: IndexPath) {
        let material = dataStorage[indexPath.section].data[indexPath.row]
        if material.data != nil{
            
//            let tempURL = URL(fileURLWithPath: NSTemporaryDirectory() + material.url.path)
//            try? material.data!.write(to: tempURL)
//
//            materialToPreview = tempURL
            
            materialToPreview = material
            let quickLook = QLPreviewController()
            
            quickLook.delegate = self
            quickLook.dataSource = self
            ViewController.controller.present(quickLook, animated: true, completion: nil)
        }else {
            MaterialManager.getMaterial(path: material.url.path, materialID: material.materialID) { (material, error) in
                guard let material = material else {
                    return
                }
//                let tempURL = URL(fileURLWithPath: NSTemporaryDirectory() + material.url.path)
//                try? material.data!.write(to: tempURL)
//
//                self.materialToPreview = tempURL
                self.materialToPreview = material
                print("Show material")
                
                let data = material.data!
                
                self.urlToPreview = URL(fileURLWithPath: NSTemporaryDirectory() + material.url.lastPathComponent)
                
                try? data.write(to: self.urlToPreview!)
                
//                let img = UIImage(data: material.data!)
//
//                let imgView = UIImageView(image: img)
//                imgView.contentMode = .scaleAspectFit
//                imgView.addAndConstraint(to: self)
                
                let quickLook = QLPreviewController()

                quickLook.delegate = self
                quickLook.view.backgroundColor = .background
                quickLook.dataSource = self
                ViewController.controller.present(quickLook, animated: true, completion: nil)
            }
        }
    }
    
    override func reload() {
        mapTasks()
        tableView.reloadData()
    }
    
    
    
    /// Maps the Material objects in the MaterialDetailView.material list to today, week, and previous tasks based on their timestamp
    private func mapTasks(){
        let day: Double = 60 * 60 * 24 // 60 seconds * 60 minuntes * 24 hours = 1 day
        let week: Double = day * 7 // 60 seconds * 60 minuntes * 24 hours * 7 days = 1 week
        
        // Clear lists to avoid redunancy
        todayMaterial = []
        weekMaterial = []
        previousMaterial = []
        dataStorage = []
        
        data.forEach { (material) in
            let timeDis = material.timestamp.dateValue().timeIntervalSinceNow
            // Check when the task was added. In the past 24h, past 7 days or before
            // The timeDis value must be negated because if timeIntervalSinceNow is negative when date is before now
            
            if -timeDis < day {
                self.todayMaterial.append(material)
            }else if -timeDis < week {
                self.weekMaterial.append(material)
            }else {
                self.previousMaterial.append(material)
            }
        }
        
        todayMaterial.sort { (lhs, rhs) -> Bool in
            return lhs.timestamp.dateValue() > rhs.timestamp.dateValue()
        }
        weekMaterial.sort { (lhs, rhs) -> Bool in
            return lhs.timestamp.dateValue() > rhs.timestamp.dateValue()
        }
        previousMaterial.sort { (lhs, rhs) -> Bool in
            return lhs.timestamp.dateValue() > rhs.timestamp.dateValue()
        }
        
        // Add the data lists to the data list
        // Purpose: In case a list doesn't contain any elements it won't show up in the tableview and there are no empty sections
        if todayMaterial.count != 0 {
            dataStorage.append((.today, todayMaterial))
        }
        if weekMaterial.count != 0 {
            dataStorage.append((.week, weekMaterial))
        }
        if previousMaterial.count != 0 {
            dataStorage.append((.previous, previousMaterial))
        }
        
    }
    
}
