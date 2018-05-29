//
//  BasicInfoSaveViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 5. 28..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class BasicInfoSaveViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var textTripTitle: UITextField!
    @IBOutlet var segTripArea: UISegmentedControl!
    @IBOutlet var pickerStartDate: UIDatePicker!
    @IBOutlet var pickarEndDate: UIDatePicker!
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext }
    
    // 저장 버튼을 눌렀을 경우
    @IBAction func savePressed() {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "BasicInfo", in: context)
        // basicInfo record를 새로 생성함
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(textTripTitle.text, forKey: "title")
        object.setValue(segTripArea.titleForSegment(at: segTripArea.selectedSegmentIndex), forKey: "area")
        object.setValue(pickerStartDate.date, forKey: "startdate")
        object.setValue(pickarEndDate.date, forKey: "enddate")
        object.setValue(Date(), forKey: "savedate")
        
        do {
            try context.save()
            print("저장되었습니다.")
        } catch let error as NSError {
            print("저장하지 못했습니다. \(error), \(error.userInfo)") }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
