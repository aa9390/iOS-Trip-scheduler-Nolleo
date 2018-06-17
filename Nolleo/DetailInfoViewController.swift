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

class DetailInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textTitle: UILabel!
    @IBOutlet var textArea: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    @IBOutlet var recommendReason: UITextView!
    
    var dayCountDisplay: String = ""
    var dayDisplay: String = ""
    var costDisplay: String = ""
    
    var dayInterval: Double?
    var daysInterval: Int?
    
    var count: Int = 1
    
    var basic: NSManagedObject?
    
    // Detail Info Day View Controller로 값을 넘길 때 필요
    var deptVC: UITableViewController? = nil
    
    var detailInfo: [NSManagedObject] = []
    var dayInfo: NSManagedObject!
    
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
            
//            textTitle.text = "\(daysInterval!)"
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.title = self.textTitle.text!
        
        
        let context = self.getContext()
        let fetchRequestDetail = NSFetchRequest<NSManagedObject>(entityName: "Detail")
        do {
            detailInfo = try context.fetch(fetchRequestDetail)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)") }
        
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
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
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
                }
                else {
                    cell.labelDay?.text = dayDisplay
                    cell.labelCost?.text = costDisplay
                }
            }
        }
        return cell
    }
    
    // -------------------공유-------------------
    // 아직은 기본 정보만 공유되도록 구현.
    @IBAction func shareButtonPressed() {
        // 데이터베이스 insert
//        let urlString: String = "http://localhost:8888/nolleo/insertBasicInfo.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T03nolleo/insertBasicInfo.php"
        guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // DB에 들어갈 변수 설정
        guard let userID = appDelegate.ID else { return }
        let title = textTitle.text!
        let area = textArea.text!
        let startdate = startDate.text!
        let enddate = endDate.text!
        let recommendText = recommendReason.text!
        
        // DB에 insert
        var restString: String = "title=" + title + "&user_id=" + userID
        restString = restString + "&area=" + area
        restString = restString + "&start_date=" + startdate + "&end_date=" + enddate
        restString = restString + "&recommend_reason=" + recommendText
        
        request.httpBody = restString.data(using: .utf8)
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { return }
            guard let receivedData = responseData else { return }
            if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
        }
        task2.resume()
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    // 세부 페이지로 이동
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDetailDayView" {
//            if let destination = segue.destination as? DetailInfoDayViewController {
//
//                if self.tableView.indexPathForSelectedRow != nil {
////                    destination.daycount = dayCountDisplay
//                    destination.daycount = "\(self.tableView.indexPathForSelectedRow!.row + 1)"
//                    destination.titleText = textTitle.text!
//                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                    appDelegate.dayCount = self.tableView.indexPathForSelectedRow!.row + 1
//                }
//            }
//        }
//    }
    
    // 세부 페이지로 이동
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
    }
}
