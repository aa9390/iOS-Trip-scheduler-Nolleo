//
//  DayViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 6. 17..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DayViewController: UIViewController, NMapViewDelegate, NMapPOIdataOverlayDelegate, MMapReverseGeocoderDelegate, NMapLocationManagerDelegate {
    
    @IBOutlet var viewWithNMap: UIView!
    @IBOutlet var textPlace: UITextField!
    @IBOutlet var textTime: UITextField!
    @IBOutlet var textMemo: UITextView!
    @IBOutlet var textCost: UITextField!
    @IBOutlet var labelDayCount: UILabel!
    @IBOutlet var labelResult: UILabel!
    
    var mapView: NMapView?
    var changeStateButton: UIButton?
    
    var titleText: String!
    var daycount: String!
    var dayCount: Int!
    
    // Detail Info Save View Controller의 값을 받기 위함.
    var detailInfo: [NSManagedObject] = []
    var dayInfo: NSManagedObject!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    enum state {
        case disabled
        case tracking
        case trackingWithHeading
    }
    
    var currentState: state = .disabled
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewWithNMap 안에 지도 설정
        mapView = NMapView(frame: self.viewWithNMap.frame)
        if let mapView = mapView {
            // set the delegate for map view
            mapView.delegate = self
            mapView.reverseGeocoderDelegate = self
            
            // set the application api key for Open MapViewer Library
            mapView.setClientId("VzFN7JYE7dUDYEh6EgZa")
            mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.viewWithNMap.addSubview(mapView)
        }
        
        // Add Controls.
        changeStateButton = createButton()
        
        if let button = changeStateButton {
            self.viewWithNMap.addSubview(button)
        }

//        let coco = appDelegate.dayCount!
        labelDayCount.text = "Day \(daycount!)"
        // Do any additional setup after loading the view.
        
        let context = self.getContext()
        let fetchRequestDetail = NSFetchRequest<NSManagedObject>(entityName: "Detail")
        do {
            detailInfo = try context.fetch(fetchRequestDetail)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)") }
        
        var count: Int = 0
        if(detailInfo.count >= 1) {
        for i in 0...(detailInfo.count - 1) {
            if (titleText == detailInfo[i].value(forKey: "title")as? String && daycount == detailInfo[i].value(forKey: "daycount")as? String)
            {
                dayInfo = detailInfo[i]
                count = count + 1
                print("count \(count)")
                textPlace.text = dayInfo.value(forKey: "place")as? String
                textTime.text = dayInfo.value(forKey: "time")as? String
                textCost.text = dayInfo.value(forKey: "cost")as? String
                textMemo.text = dayInfo.value(forKey: "memo")as? String
            }
        }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let context = self.getContext()
        let fetchRequestDetail = NSFetchRequest<NSManagedObject>(entityName: "Detail")
        do {
            detailInfo = try context.fetch(fetchRequestDetail)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)") }
    }
    
    // ---------------- NMap 관련 -----------------
    // 내 위치 버튼 클릭 시 보여질 메시지 설정
    func locationManager(_ locationManager: NMapLocationManager!, didFailWithError errorType: NMapLocationManagerErrorType) {
        var message: String = ""
        
        switch errorType {
        case .unknown: fallthrough
        case .canceled: fallthrough
        case .timeout:
            message = "일시적으로 내위치를 확인 할 수 없습니다."
        case .denied:
            message = "위치 정보를 확인 할 수 없습니다.\n사용자의 위치 정보를 확인하도록 허용하시려면 위치서비스를 켜십시오."
        case .unavailableArea:
            message = "현재 위치는 지도내에 표시할 수 없습니다."
        case .heading:
            message = "나침반 정보를 확인 할 수 없습니다."
        }
        
        if (!message.isEmpty) {
            let alert = UIAlertController(title:"현재 위치 찾기", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK", style:.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        if let mapView = mapView, mapView.isAutoRotateEnabled {
            mapView.setAutoRotateEnabled(false, animate: true)
        }
    }
    
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
            requestAddressByCoordination(mapView.fromPoint(scrPoint))
        }
    }
    
    // MARK: - NMapPOIdataOverlayDelegate Methods
    
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
    
    
    // MARK: - MMapReverseGeocoderDelegate Methods
    open func location(_ location: NGeoPoint, didFind placemark: NMapPlacemark!) {
        
        // 클릭한 위치의 주소
        let address = placemark.address
        self.title = address
        
        labelResult.text = "\(address!)"
        textPlace.text = textPlace.text! + ", \(placemark.dongName!)"
    }
    
    open func location(_ location: NGeoPoint, didFailWithError error: NMapError!) {
        print("location:경도 : (\(location.longitude), 위도 :\(location.latitude)) didFailWithError: \(error.description)")
        //        labelResult.text = "\(location.longitude)"
    }
    
    // MARK: -
    func requestAddressByCoordination(_ point: NGeoPoint) {
        mapView?.findPlacemark(atLocation: point)
        setMarker(point)
    }
    
    let UserFlagType: NMapPOIflagType = NMapPOIflagTypeReserved + 1
    
    func setMarker(_ point: NGeoPoint) {
        
        clearOverlay()
        
        if let mapOverlayManager = mapView?.mapOverlayManager {
            
            // create POI data overlay
            if let poiDataOverlay = mapOverlayManager.newPOIdataOverlay() {
                
                poiDataOverlay.initPOIdata(1)
                
                poiDataOverlay.addPOIitem(atLocation: point, title: "마커 1", type: UserFlagType, iconIndex: 0, with: nil)
                
                poiDataOverlay.endPOIdata()
            }
        }
    }
    
    func clearOverlay() {
        if let mapOverlayManager = mapView?.mapOverlayManager {
            mapOverlayManager.clearOverlay()
        }
    }
    
    // 현재 위치 받아오기
    func locationManager(_ locationManager: NMapLocationManager!, didUpdateTo location: CLLocation!) {
        let coordinate = location.coordinate
        
        let myLocation = NGeoPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
        let locationAccuracy = Float(location.horizontalAccuracy)
        
        mapView?.mapOverlayManager.setMyLocation(myLocation, locationAccuracy: locationAccuracy)
        mapView?.setMapCenter(myLocation)
    }
    
    
    func enableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.locationServiceEnabled() == false {
                locationManager(lm, didFailWithError: .denied)
                return
            }
            
            if lm.isUpdateLocationStarted() == false {
                // set delegate
                lm.setDelegate(self)
                // start updating location
                lm.startContinuousLocationInfo()
            }
        }
    }
    
    func disableLocationUpdate() {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            if lm.isUpdateLocationStarted() {
                // start updating location
                lm.stopUpdateLocationInfo()
                // set delegate
                lm.setDelegate(nil)
            }
        }
        
        mapView?.mapOverlayManager.clearMyLocationOverlay()
    }
    
    // MARK: - Compass
    
    func enableHeading() -> Bool {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                
                mapView?.setAutoRotateEnabled(true, animate: true)
                
                lm.startUpdatingHeading()
            } else {
                return false
            }
        }
        
        return true;
    }
    
    func disableHeading() {
        if let lm = NMapLocationManager.getSharedInstance() {
            
            let isAvailableCompass = lm.headingAvailable()
            
            if isAvailableCompass {
                lm.stopUpdatingHeading()
            }
        }
        
        mapView?.setAutoRotateEnabled(false, animate: true)
    }
    
    
    func createButton() -> UIButton? {
        
        let button = UIButton(type: .custom)
        
        button.frame = CGRect(x: 8, y: 25, width: 36, height: 36)
        button.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
        return button
    }
    
    func stopLocationUpdating() {
        
        disableHeading()
        disableLocationUpdate()
    }
    
    @objc func buttonClicked(_ sender: UIButton!) {
        
        if let lm = NMapLocationManager.getSharedInstance() {
            
            switch currentState {
            case .disabled:
                enableLocationUpdate()
                updateState(.tracking)
            case .tracking:
                let isAvailableCompass = lm.headingAvailable()
                
                if isAvailableCompass {
                    enableLocationUpdate()
                    if enableHeading() {
                        updateState(.trackingWithHeading)
                    }
                } else {
                    stopLocationUpdating()
                    updateState(.disabled)
                }
            case .trackingWithHeading:
                stopLocationUpdating()
                updateState(.disabled)
            }
        }
    }
    
    func updateState(_ newState: state) {
        
        currentState = newState
        
        switch currentState {
        case .disabled:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_normal"), for: .normal)
        case .tracking:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_selected"), for: .normal)
        case .trackingWithHeading:
            changeStateButton?.setImage(#imageLiteral(resourceName: "v4_btn_navi_location_my"), for: .normal)
        }
    }
    // -------------------------------------
    
    // 임시로 Detail로 엔티티 설정.
    // Detail 엔티티에 데이터 저장
    @IBAction func savePressed() {
        
        if textPlace.text == "" {
            let alert = UIAlertController(title: "장소를 입력하세요",message: "Save Failed!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in alert.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true)
            return
        }
        
        if textCost.text == "" {
            let alert = UIAlertController(title: "비용을 입력해 주세요",message: "Save Failed!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in alert.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true)
            return
        }
        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Detail", in: context)
        
        let object = NSManagedObject(entity: entity!, insertInto: context)
        
        object.setValue(daycount, forKey: "daycount")
        object.setValue(titleText, forKey: "title")
        object.setValue(textPlace.text, forKey: "place")
        object.setValue(textTime.text, forKey: "time")
        object.setValue(textMemo.text, forKey: "memo")
        object.setValue(textCost.text, forKey: "cost")
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)") }
        
        // 현재의 View를 없애고 이전 화면으로 복귀
        self.dismiss(animated: true, completion: nil)
    }

}
