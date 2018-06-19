//
//  MainpageViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 6. 3..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class MainpageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var tableView: UITableView!
    
    var fetchedArray: [BasicInfoData] = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
//         테이블 뷰 높이 지정
        tableView.rowHeight = 70
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        // 서버에서 데이터 가져옴
        self.downloadDataFromServer()
        
    }
    
    // 서버에서 데이터 로드
    func downloadDataFromServer() -> Void {
//        let urlString: String = "http://localhost:8888/favorite/favoriteTable.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T03nolleo/selectBasicInfo.php"
        
        guard let requestURL = URL(string: urlString) else { return }
        let request = URLRequest(url: requestURL)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST"); return; }
            guard let receivedData = responseData else {
                print("Error: not receiving Data"); return; }
            
            let response = response as! HTTPURLResponse
            if !(200...299 ~= response.statusCode) { print("HTTP response Error!"); return }
            do {
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData,options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        let newData: BasicInfoData = BasicInfoData()
                        var jsonElement = jsonData[i]
                        newData.index = jsonElement["index"] as! String
                        newData.title = jsonElement["title"] as! String
                        newData.user_id = jsonElement["user_id"] as! String
                        newData.area = jsonElement["area"] as! String
                        newData.start_date = jsonElement["start_date"] as! String
                        newData.end_date = jsonElement["end_date"] as! String
                        newData.recommend_reason = jsonElement["recommend_reason"] as! String
                        newData.recommend_cost = jsonElement["recommend_cost"]as! String
                        newData.recommend_when_where = jsonElement["recommend_when_where"]as! String
                        newData.recommend_img = jsonElement["recommend_img"]as! String
                        self.fetchedArray.append(newData)
                    }
                    DispatchQueue.main.async { self.tableView.reloadData() } }
            } catch { print("Error:") } }
        task.resume()
    }
    
    // Table view 관련
    func numberOfSections (in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mainpage Basic Info Cell", for: indexPath) as! MainpageTableViewCell
        
        let item = fetchedArray[indexPath.row]
        
        cell.labelId?.text = item.user_id
        cell.labelTripTitle?.text = item.title
        cell.labelTripArea?.text = item.area
        cell.labelStartDate?.text = item.start_date
        cell.labelEndDate?.text = item.end_date
        
        return cell
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { // Get the new view controller using segue.destinationViewController. // Pass the selected object to the new view controller.
        if segue.identifier == "toSharedInfoView" {
            if let destination = segue.destination as? SharedInfoViewController {
                if let selectedIndex = self.tableView.indexPathsForSelectedRows?.first?.row {
                    let data = fetchedArray[selectedIndex]
                    destination.selectedData = data
                }
                
            }
        }
    }
}
