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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블 뷰 높이 지정
        tableView.rowHeight = 80
    }
    
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
        // 커스텀 셀 사용함을 명시
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mypage Basic Info Cell", for: indexPath) as! BasicInfoTableViewCell
        
        let basicInfo = BasicInfo[indexPath.row]
        
        var titleDisplay: String = ""
        var areaDisplay: String = ""
        var startDisplay: String = ""
        var endDisplay: String = ""
        var saveDisplay: String = ""
        
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        let saveformatter: DateFormatter = DateFormatter()
        saveformatter.dateFormat = "MM.dd"
        
        if let labelTitle = basicInfo.value(forKey: "title") as? String {
            titleDisplay = labelTitle
        }
        
        if let labelArea = basicInfo.value(forKey: "area") as? String {
            areaDisplay = labelArea
        }
        
        if let labelStartDate = basicInfo.value(forKey: "startdate") as? Date {
            startDisplay = formatter.string(from: labelStartDate)
        }
        
        if let labelEndDate = basicInfo.value(forKey: "enddate") as? Date {
            endDisplay = formatter.string(from: labelEndDate)
        }
        
        if let labelEndDate = basicInfo.value(forKey: "enddate") as? Date {
            endDisplay = formatter.string(from: labelEndDate)
        }
        
        if let labelSaveDate = basicInfo.value(forKey: "savedate") as? Date {
            saveDisplay = saveformatter.string(from: labelSaveDate)
        }
        
        cell.labelTitle?.text = titleDisplay
        cell.labelArea?.text = areaDisplay
        cell.labelStartDate.text = startDisplay
        cell.labelEndDate.text = endDisplay
        cell.labelSaveDate.text = saveDisplay
        
        return cell
    }


    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Core Data 내의 해당 자료 삭제
            let context = getContext()
            context.delete(BasicInfo[indexPath.row])
            do {
                try context.save()
                print("deleted!")
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)") }
            // 배열에서 해당 자료 삭제
            BasicInfo.remove(at: indexPath.row)
            // 테이블뷰 Cell 삭제
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetailView", sender: nil)
    }
    
    // Detail view로 넘어갈 때 기본 사항을 배열로 넘김
//    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDetailInfoView" {
//            if let destination = segue.destination as? DetailInfoViewController {
//                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
//                    destination.basic = BasicInfo[0] }
//            } }
//    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            if let destination = segue.destination as? DetailInfoViewController {
                if let indexPath = self.tableView.indexPathForSelectedRow {
                    destination.basic = BasicInfo[indexPath.row]
                }
            } }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDetailInfoView"
//    }
    
    // 로그아웃
    @IBAction func logoutPressed(_ sender: Any) {
        let alert = UIAlertController(title:"로그아웃 하시겠습니까?",message: "",preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {
            //            action in let urlString: String = "http://localhost:8888/login/logoutUser.php"
            action in let urlString: String = "http://condi.swu.ac.kr/student/T03nolleo/logout.php"
            guard let requestURL = URL(string: urlString) else { return }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let session = URLSession.shared
            let task = session.dataTask(with: request) { (responseData, response, responseError) in
                guard responseError == nil else { return } }
            task.resume()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginView = storyboard.instantiateViewController(withIdentifier: "LoginView")
            self.present(loginView, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}
