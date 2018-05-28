//
//  MypageDetailInfoViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 5. 28..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DetailInfoViewController: UIViewController {
    @IBOutlet var textTitle: UILabel!
    @IBOutlet var textArea: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    
    var basicInfo: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let basic = basicInfo {
            textTitle.text = basic.value(forKey: "title") as? String
            textArea.text = basic.value(forKey: "area") as? String
            
//            let savedStartdate : Date? = basic.value(forKey: "startdate") as? Date
//            let savedEnddate : Date? = basic.value(forKey: "endDate") as? Date
//            let formatter: DateFormatter = DateFormatter()
//            formatter.dateFormat = "yyyy.MM.dd"
//            
//            if let unwrapStartdate = savedStartdate {
//                let displayStartDate = formatter.string(from: unwrapStartdate as Date)
//                startDate.text = displayStartDate
//            }
//
//            if let unwrapEnddate = savedEnddate {
//                let displayEndDate = formatter.string(from: unwrapEnddate as Date)
//                endDate.text = displayEndDate }

            
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
