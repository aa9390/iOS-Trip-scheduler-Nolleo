//
//  DayViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 6. 17..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DayViewController: UIViewController {


    @IBOutlet var textPlace: UITextField!
    @IBOutlet var textTime: UITextField!
    @IBOutlet var textMemo: UITextField!
    @IBOutlet var textCost: UITextField!
    @IBOutlet var labelDayCount: UILabel!
    
    var titleText: String!
    var daycount: String!
    var dayCount: Int!
    
    // Detail Info Save View Controller의 값을 받기 위함.
    var detailInfo: [NSManagedObject] = []
    var dayInfo: NSManagedObject!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    // 임시로 Detail로 엔티티 설정.
    // Detail 엔티티에 데이터 저장
    @IBAction func savePressed() {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
