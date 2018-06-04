//
//  MainpageViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 6. 3..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class MainpageViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    class BasicInfoData: NSObject {
        var index: String = ""
        var title: String = ""
        var user_id: String = ""
        var area: String = ""
        var start_date: String = ""
        var end_date: String = ""
    }

    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 테이블 뷰 높이 지정
//        tableView.rowHeight = 80
    }
    
    var fetchedArray: [BasicInfoData] = Array()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchedArray = [] // 배열을 초기화하고 서버에서 자료를 다시 가져옴
        // 서버에서 데이터 가져옴
        self.downloadDataFromServer()
        
    }
    
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
                if let jsonData = try JSONSerialization.jsonObject (with: receivedData,
                                                                    options:.allowFragments) as? [[String: Any]] {
                    for i in 0...jsonData.count-1 {
                        let newData: BasicInfoData = BasicInfoData()
                        var jsonElement = jsonData[i]
                        newData.index = jsonElement["index"] as! String
                        newData.title = jsonElement["title"] as! String
                        newData.user_id = jsonElement["user_id"] as! String
                        newData.area = jsonElement["area"] as! String
                        newData.start_date = jsonElement["start_date"] as! String
                        newData.end_date = jsonElement["end_date"] as! String
                        self.fetchedArray.append(newData)
                    }
                    DispatchQueue.main.async { self.tableView.reloadData() } }
            } catch { print("Error:") } }
        task.resume()
    }
    
    
    func numberOfSections (in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Favorite Cell", for: indexPath)
        let item = fetchedArray[indexPath.row]
//        cell.textLabel?.text = item.name
//        cell.detailTextLabel?.text = item.date // ----> Right Detail 설정 return cell
        
        return cell
    }
}
