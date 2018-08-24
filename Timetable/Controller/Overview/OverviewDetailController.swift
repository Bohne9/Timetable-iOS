//
//  OverviewDetailControllerViewController.swift
//  Timetable
//
//  Created by Jonah Schueller on 09.08.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

let overviewSectionWidths: [CGFloat] = [1.0, 0.9, 0.9, 0.9, 0.9]
let overviewSectionHeights: [CGFloat] = [200, 100, 100, 100, 100]

class OverviewDetailController: UIViewController, UIViewControllerTransitioningDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    var lesson: TimetableLesson?
    
    var statusBarIsHidden: Bool = false{
        didSet{
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarIsHidden
    }

    var collectionView: UICollectionView!
    
    let headerIdentifier = "OverviewDetailControllerHeaderIdentifier"

    let topIdentifier = "OverviewDetailControllerTopIdentifier"
    let taskIdentifier = "OverviewDetailControllerTaskIdentifier"
    let materialIdentifier = "OverviewDetailControllerMaterialIdentifier"
    
    private var panGesture: UIPanGestureRecognizer!

    var interactionController: DragDownInteraction!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.layoutSubviews()
        
        view.backgroundColor = UIColor(hexString: "#FEFEFE")
        
        OverviewDetailTopCell.topOffset = UIApplication.shared.keyWindow!.safeAreaInsets.top
        
        setupCollectionView()
        addPanGesture()
        
        modalPresentationStyle = .custom
        
    }
    
    private func addPanGesture(){
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        collectionView.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        
        if collectionView.contentOffset.y == 0.0 {
            
            let translationY = 1.0 - max(min(gesture.translation(in: collectionView).y / 250.0, 0.25), 0.0)
            
//          collectionView.transform = CGAffineTransform(scaleX: translationY, y: translationY)
            
            if (translationY < 0.9 && (gesture.state == .ended || gesture.state == .cancelled)) || translationY < 0.8{
//                collectionView.transform = .identity
                dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        statusBarIsHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        statusBarIsHidden = false
    }
    
    func setupCollectionView() {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        flowLayout.minimumInteritemSpacing = 20
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        collectionView.addAndConstraint(to: view)
        
        collectionView.register(OverviewCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(OverviewDetailTopCell.self, forCellWithReuseIdentifier: topIdentifier)
        collectionView.register(OverviewDetailTaskCell.self, forCellWithReuseIdentifier: taskIdentifier)
        collectionView.register(OverviewDetailMaterialCell.self, forCellWithReuseIdentifier: materialIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.backgroundColor = UIColor(hexString: "#FEFEFE")
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.layer.cornerRadius = 5
        
    }
    
    private func calculateSectionCount() -> Int{
        guard let lesson = lesson else {
            return 0
        }
        return 1 + (lesson.taskTargets.count != 0 ? 1 : 0) + (lesson.materialTargets.count != 0 ? 1 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let lesson = lesson else{
            return 0
        }
        
        switch section {
        case 0:
            return 1
        case 1:
            return lesson.taskTargets.count
        case 2:
            return lesson.materialTargets.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return calculateSectionCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let section = indexPath.section
        
        if section == 0 {
            // Header section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: topIdentifier, for: indexPath) as! OverviewDetailTopCell
            cell.backgroundColor = OverviewDetailTopCell.subjectColor
            if let lesson = lesson {
                cell.lesson = lesson
            }
            return cell
        }else if section == 1 {
            // Task section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: taskIdentifier, for: indexPath) as! OverviewDetailTaskCell
            
            if let task = lesson?.taskTargets[indexPath.row] {
                cell.task = task
            }
            return cell
        }else if section == 2 {
            // Material Section
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: materialIdentifier, for: indexPath) as! OverviewDetailMaterialCell
            
            if let material = lesson?.materialTargets[indexPath.row] {
                cell.material = material
            }
            return cell
        }
        
        // If something goes wrong
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! OverviewCollectionViewHeader
            
            let section = indexPath.section
            
            var headers = [""]
            
            if let lesson = lesson {
                if lesson.taskTargets.count != 0 {
                    headers.append(Language.translate("Tasks"))
                }
                if lesson.materialTargets.count != 0 {
                    headers.append(Language.translate("Materials"))
                }
            }
            
            header.titleLabel.text = headers[section]

            return header
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        }
        
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getSize(for: indexPath.section)
    }
    
    func getSize(for section: Int) -> CGSize {
        return CGSize(width: getWidth(for: section), height: getHeight(for: section))
    }
    
    func getWidth(for section: Int) -> CGFloat {
        return overviewSectionWidths[min(section, overviewSectionWidths.count - 1)] * view.frame.width
    }
    
    func getHeight(for section: Int) -> CGFloat {
        return overviewSectionHeights[min(section, overviewSectionHeights.count - 1)] + OverviewDetailTopCell.topOffset
    }
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < 0 {
            scrollView.contentOffset.y = 0
        }
        
    }
  
    
}
