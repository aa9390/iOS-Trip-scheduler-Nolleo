//
//  ShareViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 6. 18..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class ShareViewController: UIViewController {
    
    @IBOutlet var textTitle: UILabel!
    @IBOutlet var textArea: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    @IBOutlet var recommendReason: UITextView!

    var titleText: String!
    var areaText: String!
    var startText: String!
    var endText: String!
    
    // Detail Info Day View Controller로 값을 넘길 때 필요
    var deptVC: UITableViewController? = nil
    
    var detailInfo: [NSManagedObject] = []
    var dayInfo: NSManagedObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textTitle.text = titleText
        textArea.text = areaText
        startDate.text = startText
        endDate.text = endText
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // -------------------공유-------------------
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

}
