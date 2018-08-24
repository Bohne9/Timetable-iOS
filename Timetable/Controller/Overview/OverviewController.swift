//
//  ViewController.swift
//  Timetable
//
//  Created by Jonah Schueller on 31.07.18.
//  Copyright © 2018 Jonah Schueller. All rights reserved.
//

import UIKit

let hightlightColor = UIColor(hexString: "#3780C7")
extension UINavigationController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}


class OverviewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIViewControllerTransitioningDelegate {
    
//    var segment: UISegmentedControl!
    var collectionView: UICollectionView!
    
    var navBarTitle: UILabel = {
        let label = UILabel()
        
        label.textColor = UIColor.gray
        label.font = .robotoBold(20)
        label.textAlignment = .center
        return label
    }()
    
    lazy var navBarSection: UILabel = {
        let label = UILabel()
        
        label.textColor = appBlueColor
        label.font = .robotoBold(30)
        label.textAlignment = .center
        return label
    }()
    
    let cellIdentifier = "OverviewAllCellIdentifier"
    let headerIdentifier = "HeaderIdentifer"
    let headerNavBarIdentifier = "HeaderNavBarIdentifer"
    
    var lessons = [TimetableLesson]()
    
    var transition = PopAnimator()
    
    // Add View Controllers (Lesson, Task, Material)
    lazy var lessonAddController = LessonAddViewController()
    
    lazy var lessonAddNavigationController: UINavigationController = {
        let controller = UINavigationController(rootViewController: lessonAddController)
        controller.navigationBar.isTranslucent = false
        return controller
    }()
    
    
    lazy var materialAddController = MaterialAddViewController()
    
    lazy var materialAddNavigationController: UINavigationController = {
        let controller = UINavigationController(rootViewController: materialAddController)
        controller.navigationBar.isTranslucent = false
        return controller
    }()
    
    
    lazy var taskAddController = TaskAddViewController()
    
    lazy var taskAddNavigationController: UINavigationController = {
        let controller = UINavigationController(rootViewController: taskAddController)
        controller.navigationBar.isTranslucent = false
        return controller
    }()
    
    
    
    
    
    
    
    /// Array with tuples with a String (section header) and an TimetableLesson array
    /// - sectionHeader: Title for the header in the collectionView
    /// - lessons: collection of lessons for the section
    private var data: [(sectionHeader: String, lessons: [TimetableLesson])] = []
    
    lazy var interactionController: DragDownInteraction = {
        return  DragDownInteraction(for: detailController)
    }()
    
    lazy var detailController = OverviewDetailController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.layoutIfNeeded()
        
        setupTableView()
        
//        title = "Overview"
//        navBarTitle.text = "Overview"
        
        collectionView.reloadData()
    }
    
    /*
     ++++++++++++++++++++++++++++++++++++++++++++++++++++++
     +                                                    +
     +               Setup user interface                 +
     +                                                    +
     ++++++++++++++++++++++++++++++++++++++++++++++++++++++
     */
    
    private func setupTitle(){
        
        navigationController!.navigationBar.addSubview(navBarTitle)
        navBarTitle.translatesAutoresizingMaskIntoConstraints = false

        // Constraint the segment control to the nav bar
        navBarTitle.widthAnchor.constraint(equalTo: navigationController!.navigationBar.widthAnchor, multiplier: 0.75).isActive = true
        navBarTitle.centerXAnchor.constraint(equalTo: navigationController!.navigationBar.centerXAnchor).isActive = true
        navBarTitle.topAnchor.constraint(equalTo: navigationController!.navigationBar.topAnchor, constant: 10).isActive = true
        navBarTitle.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func setupSectionTitle(){
        
        navigationController!.navigationBar.addSubview(navBarSection)
        navBarSection.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint the segment control to the nav bar
        navBarSection.widthAnchor.constraint(equalTo: navigationController!.navigationBar.widthAnchor, multiplier: 0.75).isActive = true
        navBarSection.centerXAnchor.constraint(equalTo: navigationController!.navigationBar.centerXAnchor).isActive = true
        navBarSection.topAnchor.constraint(equalTo: navBarTitle.bottomAnchor, constant: 10).isActive = true
        navBarSection.heightAnchor.constraint(equalToConstant: 35).isActive = true
    }
    
    
    /// Setups up the collectionView
    /// UI Layout constraints + delegate + data-source, ...
    private func setupTableView(){
        // Setup flow layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 20
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = 20
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraint collectionView
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        // Register Cell class for collectionView
        collectionView.register(OverviewCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.register(OverviewCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        collectionView.register(OverviewCollectionViewNavBarHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerNavBarIdentifier)
        
        // Set tableview datasource + delegate
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor(hexString: "#FEFEFE")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
    }
    
    
    /*
     ++++++++++++++++++++++++++++++++++++++++++++++++++++++
     +                                                    +
     +      COLLECTION VIEW DELEGATE - DATA SOURCE        +
     +                                                    +
     +                                                    +
     ++++++++++++++++++++++++++++++++++++++++++++++++++++++
    */
    
    /// Specifys the Number of sections in the collectionView.
    /// Number of days.
    /// - Parameter collectionView: OverviewController.collectionView
    /// - Returns: numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    
    /// Specifies the number of lessons in each section
    ///
    /// - Parameters:
    /// - Returns: data[section].lessons.count
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].lessons.count
    }
    
    
    /// Dequeues collectionView cells (class: OverviewCollectionViewCell) and
    /// sets the lesson for  the cell
    /// - Parameters
    ///   - collectionView: OverviewController.collectionView
    ///   - indexPath: indexPath for the lesson
    /// - Returns: Deququed cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! OverviewCollectionViewCell
        
        cell.lesson = data[indexPath.section].lessons[indexPath.row]
        
        return cell
    }
    
    
    /// Specifies the size for a UICollectionViewCell
    ///
    /// - Returns: Size for cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width * 0.9, height: 200)
    }
    
    /// Specifies the size for a UICollectionViewHeader
    ///
    /// - Returns: Size for header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.frame.width, height: 120)
        }
        
        return CGSize(width: view.frame.width, height: 50)
    }
    
    
    /// Behaviour for touch event on a CollectionViewCell
    ///
    /// - Parameters:
    ///   - collectionView: OverviewController.collectionView
    ///   - indexPath: touched cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        detailController = OverviewDetailController()
        selectedCell = collectionView.cellForItem(at: indexPath) as! OverviewCollectionViewCell
        detailController.lesson = selectedCell.lesson
        
        detailController.transitioningDelegate = self
        self.present(detailController, animated: true, completion: nil)
    }

    
    /// Dequeues a header view
    ///
    /// - Parameters:
    ///   - collectionView: OverviewController.collectionView
    ///   - kind: Kind of Header or footer
    ///   - indexPath: section index
    /// - Returns: Header View
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let navBar = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerNavBarIdentifier, for: indexPath) as! OverviewCollectionViewNavBarHeader
            navBar.plusButton.addTarget(self, action: #selector(onAddAction), for: .touchUpInside)
            navBar.titleLabel.text = data[indexPath.section].sectionHeader
            return navBar
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! OverviewCollectionViewHeader
        
        header.titleLabel.text = data[indexPath.section].sectionHeader
        return header
    }
    
    
    /// Specifies the insets for a section
    ///
    /// - Parameters:
    ///   - collectionView: OverviewController.collectionView
    ///   - collectionViewLayout: UICollectionViewFlowLayout
    ///   - section: sectionIndex
    /// - Returns: EdgeInsets for section (top: 10, left: 0, bottom: 20, right: 0)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 0, 20, 0)
    }
    
    
    lazy var actionSheet: UIAlertController = {
        let ctn = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("cancel")
        })
        
        let lessonAction = UIAlertAction(title: "Lesson", style: .default, handler: { (action) in
            self.present(self.lessonAddNavigationController, animated: true, completion: nil)
            print("Lesson")
        })
        
        let taskAction = UIAlertAction(title: "Task", style: .default, handler: { (action) in
            self.present(self.taskAddNavigationController, animated: true, completion: nil)
            print("Task")
        })
        
        let material = UIAlertAction(title: "Material", style: .default, handler: { (action) in
            self.present(MaterialPickerViewController(), animated: true, completion: nil)
            print("Material")
        })
        
        
        ctn.addAction(lessonAction)
        ctn.addAction(taskAction)
        ctn.addAction(material)
        
        ctn.addAction(cancelAction)
        
        return ctn
    }()
    
    @objc func onAddAction(){
        present(actionSheet, animated: true, completion: nil)
    }

    
    
    /// Variable for a touch event on a collectionView Cell
    private var selectedCell: OverviewCollectionViewCell!
    
//  UIViewControllerTransitioningDelegate Methods Begin
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = selectedCell.superview!.convert(selectedCell.frame, to: nil)
        
        OverviewDetailTopCell.subjectColor = selectedCell.backgroundColor!
        
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        transition.presenting = false
//        return transition
        return DragAnimator(interaction: interactionController)
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    
    
//  UIViewControllerTransitioningDelegate Methods End
    
    
    /// Reloading the entire Overview View
    ///
    /// - Parameter lessons: lessons array with the new information
    
    func reload(_ lessons: [TimetableLesson]){
        self.lessons = lessons
        sortLessons()
        collectionView.reloadData()
        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }
    
    
    /// Sorts the self.lessons array based on their startTimeValue
    /// The lessons which are closest in the future are up front
    /// Further: Separates the lessons into day based sections.
    func sortLessons(){
      
        let currentValue = Database.database.getCurrentTimeValue()
        lessons.sort { (l1, l2) -> Bool in
            var l1StartValue = l1.startValue
            var l2StartValue = l2.startValue
            
            let l1EndValue = l1.endValue
            let l2EndValue = l2.endValue
            
            // If start- and endTime are in the past
            if l1StartValue - currentValue < 0 && l1EndValue - currentValue < 0 {
                // Add an entire week of value
                l1StartValue += 7 * 24
            }
            // If start- and endTime are in the past
            if l2StartValue - currentValue < 0 && l2EndValue - currentValue < 0 {
                // Add an entire week of value
                l2StartValue += 7 * 24
            }
            
            return l1StartValue < l2StartValue
        }
        
        
        if lessons.count != 0 {
            // Remove the old data from the data array
            data = []
            // Get the day of the first timetableLesson in the lessons array
            var currentDay = lessons.first!.day
            // Create a new empty array
            var section = [TimetableLesson]()
            
            // For every element in the sorted lessons array
            for lesson in lessons {
                // If days are equal -> append to current section array
                if lesson.day.rawValue == currentDay.rawValue {
                    section.append(lesson)
                }else {
                    // Otherwise append the section array with the previous elements to the data array
                    data.append((sectionHeader: Language.translate("Day_\(currentDay)"), lessons: section))
                    // Reset variables
                    currentDay = lesson.day
                    section = [lesson]
                }
                // If the current lesson is the last in the array -> append the section to the data array
                if lesson == lessons.last {
                    data.append((sectionHeader: Language.translate("Day_\(currentDay)"), lessons: section))
                }
            }
        }
    }
    
}
