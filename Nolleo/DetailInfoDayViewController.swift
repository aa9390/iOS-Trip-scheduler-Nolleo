//
//  DetailInfoDayViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 6. 4..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class DetailInfoDayViewController: UIViewController {

    @IBOutlet var labelDay: UILabel!
    @IBOutlet var labelDayCount: UILabel!
    
    var daycount: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelDayCount.text = "Day \(daycount!)"

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
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
