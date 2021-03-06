//
//  ETViewController.swift
//  HyzeCalendarForWWDC
//
//  Created by Niklas Bülow on 28.09.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//

import UIKit

enum ETViewState {
    case expanded
    case normal
    case minimal
}


class ETViewController: UIViewController {
    
    public var startColor: UIColor = .white {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            self.view.setNeedsDisplay()
        }
    }
    
    public var endColor: UIColor = .white {
        didSet {
            gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
            self.view.backgroundColor = endColor
            self.view.setNeedsDisplay()
        }
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [self.startColor.cgColor, self.endColor.cgColor]
        gradientLayer.frame = UIScreen.main.bounds
        return gradientLayer
    }()
    
    var state: ETViewState = .normal
    var isCalendarView = true
    
    @IBOutlet weak var gestureBar: UIView!
    @IBOutlet var rightTapGestureRecognizer: UITapGestureRecognizer!
    
    var collectionViewTransitioningLayout: UICollectionViewTransitionLayout?
    
    @IBOutlet weak var toolBar: UIView!
    
    var calendarViewController: ViewController? { didSet{ isCalendarView = true }}
    var dayViewController: DayViewUIVViewController? { didSet{ isCalendarView = false }}
    var eventList: EventListTableViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 20
        self.view.clipsToBounds = true
        self.view.layer.insertSublayer(gradientLayer, at: 0)
        setUpGestureBar()
        setUpToolbar()
        updateDesign()
    }
    
    func setUpGestureBar() {
        gestureBar.layer.cornerRadius = gestureBar.bounds.height / 2
        gestureBar.backgroundColor = Color.black.withAlphaComponent(0.75)
    }
    
    func setUpToolbar() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        self.toolBar.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        if let superController = calendarViewController {
            handlePanForCalendarView(superController, recognizer: recognizer)
            return
        }
        if let superController = dayViewController {
            handlePanForDayView(superController, recognizer: recognizer)
            return
        }
    }
    
    func handlePanForCalendarView(_ vc: ViewController, recognizer: UIPanGestureRecognizer) {
        let superController = vc
        let touchPoint = recognizer.translation(in: superController.view)
        let animator = superController.topChange
        switch recognizer.state {
        case .began:
            Design.shared.currentETViewHeight = superController.eventListHeightConstraint.constant
            if animator.isRunning {
                animator.stopAnimation(true)
            }
            superController.calendarViewAspectRatio.isActive = false
            superController.calendarViewToETListConstraint.constant = 0
        case .changed:
            
            guard let visibleView = superController.navigationController?.visibleViewController?.view else { return }
            var translatedCenterY = touchPoint.y + Design.shared.currentETViewHeight
            let minHeight = visibleView.frame.height - 20
            if translatedCenterY > minHeight {
                translatedCenterY = minHeight
            } else if translatedCenterY < 0  {
                translatedCenterY = 0
            }
            superController.eventListHeightConstraint.constant = translatedCenterY
            superController.view.layoutIfNeeded()
            
        case .ended, .cancelled:
            guard let maxHeight = superController.navigationController?.visibleViewController?.view.frame.height else { return }
            switch superController.eventListHeightConstraint.constant {
//            case 0...maxHeight/3:
//                superController.calendarViewAspectRatio.isActive = true
//                superController.calendarViewToETListConstraint.constant = superController.loadedViewControllerToBottomConstant ?? 0
//                superController.eventListHeightConstraint.constant = superController.calendarViewToTopConstraint.constant + 10 + ((superController.calendarView.bounds.width / 7) - 2)
//                eventList?.tableView.isScrollEnabled = true
//                superController.calendarViewController?.collectionView?.isScrollEnabled = false
//                superController.calendarViewController?.collectionView?.allowsSelection = true
//                changeState(to: .expanded)
//
            case 3*maxHeight/4...maxHeight:
                superController.eventListHeightConstraint.constant = maxHeight - 95
                eventList?.tableView.isScrollEnabled = false
                eventList?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                superController.calendarViewController?.collectionView?.isScrollEnabled = true
                superController.calendarViewController?.collectionView?.allowsSelection = false
                changeState(to: .minimal)
            default:
                superController.calendarViewToETListConstraint.constant = superController.loadedViewControllerToBottomConstant ?? 0
                superController.calendarViewAspectRatio.isActive = true
                superController.calendarViewController?.scrollToSection(yearID: Selection.shared.currentYearID, monthID: Selection.shared.currentMonthID - 1, animated: true)
                
                let basicHeight = superController.calendarViewToTopConstraint.constant + (self.view.bounds.width / 7 * 6) - 10
                let expandedValue = Design.shared.currentETViewIsExpandedByNumOfRows * (superController.calendarView.bounds.width / 7)
                let height = basicHeight - expandedValue
                superController.eventListHeightConstraint.constant = height
                
                eventList?.tableView.isScrollEnabled = true
                superController.calendarViewController?.collectionView?.isScrollEnabled = false
                superController.calendarViewController?.collectionView?.allowsSelection = true
                changeState(to: .normal)
            }
            animator.addAnimations {
                superController.view.layoutIfNeeded()
            }
            animator.startAnimation()
        default:
            break
        }
    }
    
    func handlePanForDayView(_ vc: DayViewUIVViewController, recognizer: UIPanGestureRecognizer) {
        let superController = vc
        let touchPoint = recognizer.translation(in: superController.view)
        let animator = superController.topChange
        switch recognizer.state {
        case .began:
            Design.shared.currentETViewHeight = superController.eventListTopConstraint.constant
            if animator.isRunning {
                animator.stopAnimation(true)
            }
        case .changed:
            guard let visibleView = superController.navigationController?.visibleViewController?.view else { return }
            var translatedCenterY = touchPoint.y + Design.shared.currentETViewHeight
            let minHeight = visibleView.frame.height - 20
            if translatedCenterY > minHeight {
                translatedCenterY = minHeight
            } else if translatedCenterY < 0  {
                translatedCenterY = 0
            }
            superController.eventListTopConstraint.constant = translatedCenterY
            superController.view.layoutIfNeeded()
        case .ended, .cancelled:
            guard let maxHeight = superController.navigationController?.visibleViewController?.view.frame.height else { return }
            switch superController.eventListTopConstraint.constant {
            case 0...maxHeight/3:
                superController.eventListTopConstraint.constant = 0
                eventList?.tableView.isScrollEnabled = true
                changeState(to: .expanded)
            case 3*maxHeight/4...maxHeight:
                superController.eventListTopConstraint.constant = maxHeight - 95
                eventList?.tableView.isScrollEnabled = false
                eventList?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                changeState(to: .minimal)
            default:
                superController.eventListTopConstraint.constant = 2 * superController.dayTopConstraint.constant + superController.day.bounds.height
                eventList?.tableView.isScrollEnabled = true
                changeState(to: .normal)
            }
            animator.addAnimations {
                superController.view.layoutIfNeeded()
            }
            animator.startAnimation()
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateDesign(_ shouldReload: Bool = false) {
        guard let isToday = Selection.shared.selectedIsToday else { return }
        guard let isWeekend = Selection.shared.selectedIsOnWeekend else { return }
        UIView.animate(withDuration: 0.2) {
            if isToday {
                self.startColor = Color.red
                self.endColor = Color.darkRed
            } else if isWeekend {
                self.startColor = Color.green
                self.endColor = Color.darkGreen
            } else{
                self.startColor = Color.blue
                self.endColor = Color.darkBlue
            }
            self.toolBar.backgroundColor = UIColor.clear
        }
        guard let eList = eventList else { return }
        eList.reloadList(onlyDesign: !shouldReload)
    }
    
    func updateGeneralDesign() {
        guard let eList = eventList else { return }
        guard let cell = eList.tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ELAddEventTableViewCell else { return }
        cell.updateDesign()
    }
    
    func changeState(to state: ETViewState) {
        Design.shared.currentETViewState = state
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "embed" {
            guard let vc = segue.destination as? EventListTableViewController else { return }
            self.eventList = vc
            if let _ = self.dayViewController {
                vc.isEmbededInDayView = true
            }
        }
    }

}
