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

    @IBOutlet var labelPlace: UILabel!
    @IBOutlet var labelTime: UILabel!
    @IBOutlet var labelMemo: UILabel!
    @IBOutlet var labelCost: UILabel!
    @IBOutlet var labelDay: UILabel!
    @IBOutlet var labelDayCount: UILabel!
    
    var titleText: String!
    var daycount: String!
    
    // Detail Info Save View Controller의 값을 받기 위함.
    var detailInfo: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelDayCount.text = "Day \(daycount!)"
        labelDay.text = titleText!
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
