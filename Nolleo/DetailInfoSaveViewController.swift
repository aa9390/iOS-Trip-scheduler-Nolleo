//
//  DetailInfoSaveViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 6. 16..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DetailInfoSaveViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var labelTest: UILabel!
    @IBOutlet var textPlace: UITextField!
    @IBOutlet var pickerTime: UIDatePicker!
    @IBOutlet var textMemo: UITextView!
    @IBOutlet var textCost: UITextField!
    
    var daycount: String!
    var titleTxt: String!
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let unwrappedTitle = titleTxt {
            labelTest.text = unwrappedTitle
            
        } else {
            labelTest.text = "없엉"
            
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // 임시로 Detail로 엔티티 설정.
    // Detail 엔티티에 데이터 저장
    @IBAction func savePressed() {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Detail", in: context)
        
        let object = NSManagedObject(entity: entity!, insertInto: context)
        
        object.setValue(daycount, forKey: "daycount")
        object.setValue(titleTxt, forKey: "title")
        object.setValue(textPlace.text, forKey: "place")
        object.setValue(textPlace.text, forKey: "time")
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
