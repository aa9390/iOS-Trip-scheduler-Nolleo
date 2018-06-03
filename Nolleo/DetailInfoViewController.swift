//
//  MypageDetailInfoViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 5. 28..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DetailInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textTitle: UILabel!
    @IBOutlet var textArea: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    
    var dayInterval: Double?
    var daysInterval: Int?
    
    var count: Int = 1
    
    var basic: NSManagedObject?
    
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
        // Do any additional setup after loading the view.
    }

    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //--------table view 관련--------//
    func numberOfSections (in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int)->Int {
        return daysInterval!+1
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 커스텀 셀 사용함을 명시
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mypage Detail Info Cell", for: indexPath) as! DetailInfoTableCell

        var dayCountDisplay: String = ""
        var dayDisplay: String = ""
        var costDisplay: String = ""
    
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "MM.dd"

        dayCountDisplay = "Day \(count)"
        dayDisplay = "00.00"
        costDisplay = "0 KRW"
        
        cell.labelDayCount?.text = dayCountDisplay
        cell.labelDay?.text = dayDisplay
        cell.labelCost?.text = costDisplay
        if(count <= daysInterval!) {count += 1}

        return cell
    }


//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Core Data 내의 해당 자료 삭제
//            let context = getContext()
//            context.delete(BasicInfo[indexPath.row])
//            do {
//                try context.save()
//                print("deleted!")
//            } catch let error as NSError {
//                print("Could not delete \(error), \(error.userInfo)") }
//            // 배열에서 해당 자료 삭제
//            BasicInfo.remove(at: indexPath.row)
//            // 테이블뷰 Cell 삭제
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }


}
