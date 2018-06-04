//
//  MypageDetailInfoViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 5. 28..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class DetailInfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var textTitle: UILabel!
    @IBOutlet var textArea: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    
    var dayInterval: Double?
    var daysInterval: Int?
    
    var count: Int = 1
    
    var basic: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let basicToDetail = basic {
            textTitle.text = basicToDetail.value(forKey: "title") as? String
            textArea.text = basicToDetail.value(forKey: "area") as? String
            let savedStartdate : Date? = basicToDetail.value(forKey: "startdate") as? Date
            let savedEnddate : Date? = basicToDetail.value(forKey: "enddate") as? Date
            let formatter: DateFormatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            
            if let unwrapStartdate = savedStartdate {
                let displayStartDate = formatter.string(from: unwrapStartdate as Date)
                startDate.text = displayStartDate
            }

            if let unwrapEnddate = savedEnddate {
                let displayEndDate = formatter.string(from: unwrapEnddate as Date)
                endDate.text = displayEndDate }
            
            dayInterval = savedEnddate!.timeIntervalSince(savedStartdate!)
            daysInterval = Int(dayInterval! / 86400)
            
//            textTitle.text = "\(daysInterval!)"
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //---------------table view 관련------------------
    func numberOfSections (in tableView: UITableView) -> Int {
        return 1
    }


    func tableView(_ tableView:UITableView, numberOfRowsInSection section: Int)->Int {
        return daysInterval!+1
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 커스텀 셀 사용함을 명시
        let cell = tableView.dequeueReusableCell(withIdentifier: "Mypage Detail Info Cell", for: indexPath) as! DetailInfoTableCell

        var dayCountDisplay: String = ""
        var dayDisplay: String = ""
        var costDisplay: String = ""
    
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "MM.dd"

        dayCountDisplay = "Day \(count)"
        dayDisplay = "00.00"
        costDisplay = "0 KRW"
        
        cell.labelDayCount?.text = dayCountDisplay
        cell.labelDay?.text = dayDisplay
        cell.labelCost?.text = costDisplay
        if(count <= daysInterval!) {count += 1}

        return cell
    }
    
    // -------------------공유-------------------
    // 주석 처리한 부분은 필요없는 부분이며, 아직은 기본 정보만 공유되도록 구현.
    @IBAction func shareButtonPressed() {
        // 입력값 검증 부분
//        let name = textName.text!
//        let description = textDescription.text!
//        if (name == "" || description == "") {
//            let alert = UIAlertController(title: "제목/설명을 입력하세요",
//                                          message: "Save Failed!!", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                alert.dismiss(animated: true, completion: nil) }))
//            self.present(alert, animated: true)
//            return }
//        guard let myImage = imageView.image else {
//            let alert = UIAlertController(title: "이미지를 선택하세요",
//                                          message: "Save Failed!!", preferredStyle: .alert) alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//                                            alert.dismiss(animated: true, completion: nil) }))
//            self.present(alert, animated: true)
//            return }
        
        // 이미지 추가 부분
//        let myUrl = URL(string: "http://localhost:8888/favorite/upload.php");
//        var request = URLRequest(url:myUrl!);
//        request.httpMethod = "POST";
//        let boundary = "Boundary-\(NSUUID().uuidString)"
//        request.setValue("multipart/form-data; boundary=\(boundary)",forHTTPHeaderField: "Content-Type")
//        guard let imageData = UIImageJPEGRepresentation(myImage, 1) else { return } var body = Data()
//        var dataString = "--\(boundary)\r\n"
//        dataString += "Content-Disposition: form-data; name=\"userfile\";
//        filename=\".jpg\"\r\n"
//        dataString += "Content-Type: application/octet-stream\r\n\r\n" if let data = dataString.data(using: .utf8) { body.append(data) }
//        
//        // imageData 위 아래로 boundary 정보 추가 body.append(imageData)
//        dataString = "\r\n"
//        dataString += "--\(boundary)--\r\n"
//        if let data = dataString.data(using: .utf8) { body.append(data) }
//        request.httpBody = body
        
        // 이미지 전송 부분
//        var imageFileName: String = ""
//        let semaphore = DispatchSemaphore(value: 0)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { (responseData, response, responseError) in
//            guard responseError == nil else { print("Error: calling POST"); return; }
//            guard let receivedData = responseData else {
//                print("Error: not receiving Data")
//                return; }
//            if let utf8Data = String(data: receivedData, encoding: .utf8) { // 서버에 저장한 이미지 파일 이름
//                imageFileName = utf8Data
//                print(imageFileName)
//                semaphore.signal()
//            } }
//        task.resume()
//        // 이미지 파일 이름을 서버로 부터 받은 후 해당 이름을 DB에 저장하기 위해 wait()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        
        // 데이터베이스 insert
//        let urlString: String = "http://localhost:8888/nolleo/insertBasicInfo.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T03nolleo/insertBasicInfo.php"
        guard let requestURL = URL(string: urlString) else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // DB에 들어갈 변수 설정
        guard let userID = appDelegate.ID else { return }
        let title = textTitle.text!
        let area = textArea.text!
        let startdate = startDate.text!
        let enddate = endDate.text!
        
//        var restString: String = "id=" + userID + "&name=" + name
//        restString += "&description=" + description
//        restString += "&image=" + imageFileName + "&date=" + myDate
        
        // DB에 insert
        var restString: String = "title=" + title + "&user_id=" + userID
        restString = restString + "&area=" + area
        restString = restString + "&start_date=" + startdate + "&end_date=" + enddate
        
        request.httpBody = restString.data(using: .utf8)
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { return }
            guard let receivedData = responseData else { return }
            if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
        }
        task2.resume()
        _ = self.navigationController?.popViewController(animated: true)
    }
    

//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            // Core Data 내의 해당 자료 삭제
//            let context = getContext()
//            context.delete(BasicInfo[indexPath.row])
//            do {
//                try context.save()
//                print("deleted!")
//            } catch let error as NSError {
//                print("Could not delete \(error), \(error.userInfo)") }
//            // 배열에서 해당 자료 삭제
//            BasicInfo.remove(at: indexPath.row)
//            // 테이블뷰 Cell 삭제
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }


}
