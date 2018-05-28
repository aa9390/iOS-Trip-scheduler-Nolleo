//
//  MypageTableViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 5. 27..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class MypageTableViewController: UITableViewController {
    
    var BasicInfo: [NSManagedObject] = []
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext }

    // back 버튼을 눌렀을 때
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // View가 보여질 때 자료를 DB에서 가져옴
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BasicInfo")
        
        do {
            BasicInfo = try context.fetch(fetchRequest)
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)") }
        self.tableView.reloadData()
    }
    
    override func numberOfSections (in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int)->Int {
        return BasicInfo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mypage Basic Info Cell", for: indexPath) as! BasicInfoTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Mypage Basic Info Cell") as! BasicInfoTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Basic Info Cell", for: indexPath)
//        let basicInfo = BasicInfo[indexPath.row]
//
//        var titledisplay: String = ""
//        var zonedisplay: String = ""
//
//        if let titleLabel = basicInfo.value(forKey: "title") as? String {
//            titledisplay = titleLabel }
//
//        if let zoneLabel = basicInfo.value(forKey: "area") as? String {
//            zonedisplay = zoneLabel }
//        cell.textLabel?.text = titledisplay
//        cell.detailTextLabel?.text = zonedisplay
//
//        return cell
        
        let basicInfo = BasicInfo[indexPath.row]
        
        var titleDisplay: String = ""
        var areaDisplay: String = ""
//        var startDateDisplay: Date
//        var endDateDisplay: Date
        
        if let labelTitle = basicInfo.value(forKey: "title") as? String {
            titleDisplay = labelTitle
        }
        
        if let labelArea = basicInfo.value(forKey: "area") as? String {
            areaDisplay = labelArea
        }
        
//        if let labelStartDate = basicInfo.value(forKey: "startdate") as? Date {
//            startDateDisplay = labelStartDate
//        }
//
//        if let labelEndDate = basicInfo.value(forKey: "enddate") as? Date {
//            endDateDisplay = labelEndDate
//        }
        
        cell.labelArea?.text = areaDisplay
        cell.labelTitle?.text = titleDisplay
//        cell.labelStartDate?.text = (String)startDateDisplay
//        cell.labelEndDate?.text = (String)endDateDisplay
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
