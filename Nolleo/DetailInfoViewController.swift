//
//  MypageDetailInfoViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 5. 28..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class DetailInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NMapViewDelegate, NMapPOIdataOverlayDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var textTitle: UILabel!
    @IBOutlet var textArea: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    @IBOutlet var labelTotal: UILabel!
    @IBOutlet var viewWithNMap: UIView!
    
    //    @IBOutlet var recommendReason: UITextView!
    
    var dayCountDisplay: String = ""
    var dayDisplay: String = ""
    var costDisplay: String = ""
    
    var dayInterval: Double?
    var daysInterval: Int?
    
    var count: Int = 1
    
    var basic: NSManagedObject?
    var total: Int = 0
    
    // Detail Info Day View Controller로 값을 넘길 때 필요
    var deptVC: UITableViewController? = nil
    
    var detailInfo: [NSManagedObject] = []
    var dayInfo: NSManagedObject!
    
    var mapView: NMapView?
    var changeStateButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let basicToDetail = basic {
            textTitle.text = basicToDetail.value(forKey: "title") as? String
            textArea.text = basicToDetail.value(forKey: "area") as? String
            let savedStartdate : Date? = basicToDetail.value(forKey: "startdate") as? Date
            let savedEnddate : Date? = basicToDetail.value(forKey: "enddate") as? Date
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            
            if let unwrapStartdate = savedStartdate {
                let displayStartDate = formatter.string(from: unwrapStartdate as Date)
                startDate.text = displayStartDate
            }

            if let unwrapEnddate = savedEnddate {
                let displayEndDate = formatter.string(from: unwrapEnddate as Date)
                endDate.text = displayEndDate }
            
            dayInterval = savedEnddate!.timeIntervalSince(savedStartdate!)
            daysInterval = Int(dayInterval! / 86400)
            
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.title = self.textTitle.text!
        
        
        let context = self.getContext()
        let fetchRequestDetail = NSFetchRequest<NSManagedObject>(entityName: "Detail")
        do {
            detailInfo = try context.fetch(fetchRequestDetail)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)") }
        
        
        mapView = NMapView(frame: view.frame)
        if let mapView = mapView {
            // set the delegate for map view
            mapView.delegate = self
            
            // set the application api key for Open MapViewer Library
            mapView.setClientId("VzFN7JYE7dUDYEh6EgZa")
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.viewWithNMap.addSubview(mapView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        mapView?.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView?.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mapView?.viewWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        mapView?.viewDidDisappear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let context = self.getContext()
        let fetchRequestDetail = NSFetchRequest<NSManagedObject>(entityName: "Detail")
        do {
            detailInfo = try context.fetch(fetchRequestDetail)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)") }
        self.tableView.reloadData()
        
        total = 0
        
        mapView?.viewDidAppear()
//        requestAddressByCoordination(NGeoPoint(longitude: 126.978371, latitude: 37.5666091))
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getTotal() {
        if(detailInfo.count >= 1) {
            for i in 0...(detailInfo.count - 1) {
                if (textTitle.text == detailInfo[i].value(forKey: "title")as? String
                    && "\(i + 1)"
                    == detailInfo[i].value(forKey: "daycount")as? String)
                {
                    dayInfo = detailInfo[i]
                    costDisplay = (dayInfo.value(forKey: "cost")as? String)!
                    total = total + Int(costDisplay)!
                }
            }
        }
        print ("\(total)")
        labelTotal.text = "\(total)"
    }
    
    
    //---------------table view 관련------------------
    func numberOfSections (in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int)->Int {
        return daysInterval!+1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 커스텀 셀 사용함을 명시
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mypage Detail Info Cell", for: indexPath) as! DetailInfoTableCell

        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        
        dayCountDisplay = "Day \(indexPath.row + 1)"
        dayDisplay = ""
        costDisplay = ""
        cell.labelDayCount?.text = dayCountDisplay
        
        var count: Int = 0
        
        if(detailInfo.count >= 1) {
            for i in 0...(detailInfo.count - 1) {
                if (textTitle.text == detailInfo[i].value(forKey: "title")as? String
                    && "\(indexPath.row + 1)"
                    == detailInfo[i].value(forKey: "daycount")as? String)
                {
                    dayInfo = detailInfo[i]
                    
                    dayDisplay = (dayInfo.value(forKey: "place")as? String)!
                    costDisplay = (dayInfo.value(forKey: "cost")as? String)!
                    
                    count = count + 1
                    print("count \(count)")
                    
                    cell.labelDay?.text = dayDisplay
                    cell.labelCost?.text = costDisplay
                    
                    total = total + Int(costDisplay)!
                }
                else {
                    cell.labelDay?.text = dayDisplay
                    cell.labelCost?.text = costDisplay
                }
            }
        }
        
        
        labelTotal.text = "Total : \(total)  "
        
        return cell
    }
    // ---------------------------------------
    
    // ------------- NMap 관련 ----------------
    // MARK: - NMapViewDelegate Methods
    open func onMapView(_ mapView: NMapView!, initHandler error: NMapError!) {
        if (error == nil) { // success
            // set map center and level
            mapView.setMapCenter(NGeoPoint(longitude:126.978371, latitude:37.5666091), atLevel:11)
            // set for retina display
            mapView.setMapEnlarged(true, mapHD: true)
            // set map mode : vector/satelite/hybrid
            mapView.mapViewMode = .vector
        } else { // fail
            print("onMapView:initHandler: \(error.description)")
        }
    }
    
    open func onMapView(_ mapView: NMapView!, touchesEnded touches: Set<AnyHashable>!, with event: UIEvent!) {
        
        if let touch = event.allTouches?.first {
            // Get the specific point that was touched
            let scrPoint = touch.location(in: mapView)
            
            print("scrPoint: \(scrPoint)")
            print("to: \(mapView.fromPoint(scrPoint))")
//            requestAddressByCoordination(mapView.fromPoint(scrPoint))
        }
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForOverlayItem poiItem: NMapPOIitem!, selected: Bool) -> UIImage! {
        return NMapViewResources.imageWithType(poiItem.poiFlagType, selected: selected);
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, anchorPointWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return NMapViewResources.anchorPoint(withType: poiFlagType)
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, calloutOffsetWithType poiFlagType: NMapPOIflagType) -> CGPoint {
        return CGPoint.zero
    }
    
    open func onMapOverlay(_ poiDataOverlay: NMapPOIdataOverlay!, imageForCalloutOverlayItem poiItem: NMapPOIitem!, constraintSize: CGSize, selected: Bool, imageForCalloutRightAccessory: UIImage!, calloutPosition: UnsafeMutablePointer<CGPoint>!, calloutHit calloutHitRect: UnsafeMutablePointer<CGRect>!) -> UIImage! {
        return nil
    }
    // ------------------------------------
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 세부 페이지로 이동
        if segue.identifier == "toDetailDayView" {
            if let destination = segue.destination as? DayViewController {
                
                if self.tableView.indexPathForSelectedRow != nil {
                    //                    destination.daycount = dayCountDisplay
                    destination.daycount = "\(self.tableView.indexPathForSelectedRow!.row + 1)"
                    destination.titleText = textTitle.text!
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.dayCount = self.tableView.indexPathForSelectedRow!.row + 1
                }
            }
        }
        // 공유 페이지로 이동
        if segue.identifier == "toShareView" {
            if let destination = segue.destination as? ShareViewController {
                    destination.titleText = textTitle.text!
                    destination.areaText = textArea.text!
                    destination.startText = startDate.text!
                    destination.endText = endDate.text!
            }
        }
    }
}
