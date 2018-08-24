//
//  TimetableController.swift
//  Timetable
//
//  Created by Jonah Schueller on 02.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

class TimetableController: UINavigationController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!
    let cellIdentifier = "TimetableCollectionViewCellIdentifier"
    
    let timetableNavigationBar = TimetableNavigationBar()
    
    var timetableDays: [TimetableDay]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Timetable"
        view.backgroundColor = .white
        
        navigationBar.prefersLargeTitles = true
        navigationBar.barTintColor = .white
        
        setupNavigationBar()
        setupCollectionView()
        
//        navigationController?.navigationBar.backgroundColor = .red
        
        print("TimetableController.viewDidLoad")
        
        reload(Database.database.timetableDays)
        
//        var data = [String : String]()
//        data["lessonName"] = "Informatik"
//        data["room"] = "126"
//        data["startTime"] = Time("12:00").database
//        data["endTime"] = Time("13:30").database
//        data["day"] = "\(Day.Thursday.rawValue)"
//        Database.database.addLesson(data)
    }
    
    
    private func setupCollectionView(){
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = view.frame.width * 0.1
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        view.addSubview(collectionView)
        
        collectionView.constraint(topAnchor: navigationBar.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor)
        
        collectionView.isPagingEnabled = true
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.backgroundColor = .white
        
        collectionView.register(TimetableCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setupNavigationBar(){
        timetableNavigationBar.addAndConstraint(to: navigationBar, topOffset: 0, leading: 20, trailing: 20, bottom: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TimetableCollectionViewCell
        
        if let day = timetableDays?[indexPath.row] {
            cell.timetableDay = day
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.9, height: view.frame.height * 0.7)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    func reload(_ timetableDays: [TimetableDay]) {
        self.timetableDays = timetableDays
        collectionView?.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let percent = scrollView.contentOffset.x / scrollView.contentSize.width
        timetableNavigationBar.scroll(percent)
    }
    
}
