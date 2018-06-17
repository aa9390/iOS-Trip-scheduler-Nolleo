//
//  DetailInfoDayViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 6. 4..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DetailInfoDayViewController: UIViewController,UITableViewDataSource, UITableViewDelegate{

    @IBOutlet var tableView: UITableView!
    @IBOutlet var labelDay: UILabel!
    @IBOutlet var labelDayCount: UILabel!
    
    @IBOutlet var labelPlace: UILabel!
    @IBOutlet var labelTime: UILabel!
    @IBOutlet var labelMemo: UILabel!
    @IBOutlet var labelCost: UILabel!
    
    var titleText: String!
    var daycount: String!
    
    // Detail Info Save View Controller의 값을 받기 위함.
    var detailInfo: [NSManagedObject] = []
//    var basicInfo: [NSManagedObject] = []
    var count: Int = 0
//    var dayInfo: NSManagedObject!
    var dayInfo: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelDayCount.text = "Day \(daycount!)"
        labelDay.text = titleText!
        
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
    
    // View가 보여질 때 자료를 Core Data에서 가져옴
    override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
        let context = self.getContext()
        let fetchRequestDetail = NSFetchRequest<NSManagedObject>(entityName: "Detail")
    do {
            detailInfo = try context.fetch(fetchRequestDetail)
        
        count = 0
        var i: Int = 0
        for i in 0...(detailInfo.count) {
            if (titleText == detailInfo[i].value(forKey: "title")as? String && daycount == detailInfo[i].value(forKey: "daycount")as? String)
            {
                dayInfo[count] = detailInfo[i]
                count = count + 1
                print("count \(count)")
            }
        }
        
        //    basicInfo = try context.fetch(fetchRequestBasic)
    } catch let error as NSError {
    print("Could not fetch. \(error), \(error.userInfo)") }
    self.tableView.reloadData()
    }

    //---------------table view 관련------------------
    func numberOfSections (in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int)->Int {
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 커스텀 셀 사용함을 명시
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Day Info Table View Cell", for: indexPath) as! DayInfoTableViewCell
//
//        let formatter: DateFormatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//
//        if (titleText == detailInfo[indexPath.row].value(forKey: "title")as? String && daycount == detailInfo[indexPath.row].value(forKey: "daycount")as? String) {
//        let dayInfos = detailInfo[indexPath.row]
//        var displayPlace: String = ""
//        var displayTime: String = ""
//        var displayMemo: String = ""
//
////        if (titleText == dayInfos.value(forKey: "title")as? String && daycount == dayInfos.value(forKey: "daycount")as? String) {
//            if let placeLabel = dayInfos.value(forKey: "place") as? String {
//            displayPlace = placeLabel }
//            if let timeLabel = dayInfos.value(forKey: "time") as? String {
//            displayTime = timeLabel }
//            if let memoLabel = dayInfos.value(forKey: "memo") as? String {
//            displayMemo = memoLabel
//            }
////        }
//        else {
//            cell.isHidden = true
////            cell.delete(indexPath.row)
//        }
//
//        cell.labelPlace?.text = displayPlace
//        cell.labelTime?.text = displayTime
//        cell.labelMemo?.text = displayMemo
//
//        return cell
//        }
//        else {  }
//        return cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Day Info Table View Cell", for: indexPath) as! DayInfoTableViewCell
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
            var displayPlace: String = ""
            var displayTime: String = ""
            var displayMemo: String = ""
        
            if let placeLabel = dayInfo[0].value(forKey: "place") as? String {
                displayPlace = placeLabel }
            if let timeLabel = dayInfo[0].value(forKey: "time") as? String {
                displayTime = timeLabel }
            if let memoLabel = dayInfo[0].value(forKey: "memo") as? String {
                displayMemo = memoLabel
            }
            
            cell.labelPlace?.text = displayPlace
            cell.labelTime?.text = displayTime
            cell.labelMemo?.text = displayMemo
            
            return cell
    }
    
    // 세부 페이지로 이동
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailSaveView" {
            if let destination = segue.destination as? DetailInfoSaveViewController {
                    destination.daycount = daycount!
                    destination.titleTxt = titleText!
            }
        }
    }
}
