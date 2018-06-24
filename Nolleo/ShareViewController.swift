//
//  ShareViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 6. 18..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit
import CoreData

class ShareViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var textTitle: UILabel!
    @IBOutlet var textArea: UILabel!
    @IBOutlet var startDate: UILabel!
    @IBOutlet var endDate: UILabel!
    @IBOutlet var recommendReason: UITextView!
    @IBOutlet var recommendCost: UITextField!
    @IBOutlet var recommendWhenWhere: UITextField!
    @IBOutlet var recommendImg1: UIImageView!
    @IBOutlet var btnGallery: UIButton!
    
    var titleText: String!
    var areaText: String!
    var startText: String!
    var endText: String!
    
    // Detail Info Day View Controller로 값을 넘길 때 필요
    var deptVC: UITableViewController? = nil
    
    var detailInfo: [NSManagedObject] = []
    var dayInfo: NSManagedObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textTitle.text = titleText
        textArea.text = areaText
        startDate.text = startText
        endDate.text = endText
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 갤러리에서 이미지 선택
    @IBAction func selectPicture (_ sender: UIButton) {
        let myPicker = UIImagePickerController()
        myPicker.delegate = self;
        myPicker.sourceType = .photoLibrary
        self.present(myPicker, animated: true, completion: nil)
    }
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.recommendImg1.image = image
        }
        self.dismiss(animated: true, completion: nil) }
    
    func imagePickerControllerDidCancel (_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil) }


    // -------------------공유-------------------
    @IBAction func shareButtonPressed() {
        
        // 데이터베이스 insert
        //-------------이미지 전송 관련-----------------
        guard let myImage = recommendImg1.image else {
            let alert = UIAlertController(title: "이미지를 선택하세요",message: "Save Failed!!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in alert.dismiss(animated: true, completion: nil) }))
            self.present(alert, animated: true)
            return
        }
        
        let myUrl = URL(string: "http://condi.swu.ac.kr/student/T03nolleo/uploadImg.php");
        
        var request = URLRequest(url:myUrl!);
        request.httpMethod = "POST";
        let boundary = "Boundary-\(NSUUID().uuidString)"
        
        // multipart - 여러 종류 파일을 올릴 수 있음.
        // 그 자료의 시작과 끝을 알려줘야함.
        request.setValue("multipart/form-data; boundary=\(boundary)",forHTTPHeaderField: "Content-Type")
        guard let imageData = UIImageJPEGRepresentation(myImage, 1)
            else { return }
        
        // 보낼 데이터의 body 설정
        var body = Data()
        var dataString = "--\(boundary)\r\n"
        dataString += "Content-Disposition: form-data; name=\"userfile\";filename=\".jpg\"\r\n"
        dataString += "Content-Type: application/octet-stream\r\n\r\n"
        
        // 옵셔널 바인딩을 통해 dataString이 null이 아니면 append
        if let data = dataString.data(using: .utf8) {
            body.append(data)
        }
        // imageData 위 아래로 boundary 정보 추가
        body.append(imageData)
        dataString = "\r\n"
        dataString += "--\(boundary)--\r\n"
        if let data = dataString.data(using: .utf8) { body.append(data) }
        request.httpBody = body
        var imageFileName: String = ""
        
        // 세마포어를 사용하여 동기화 작업 구현
        let semaphore = DispatchSemaphore(value: 0)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil
                else {
                    print("Error: calling POST"); return; }
            // 받은 데이터가 null이면 error 메시지 발생
            guard let receivedData = responseData else {
                print("Error: not receiving Data")
                return;
            }
            if let utf8Data = String(data: receivedData, encoding: .utf8) { // 서버에 저장한 이미지 파일 이름
                imageFileName = utf8Data
                print(imageFileName)
                semaphore.signal()
            } }
        task.resume()
        
        // 이미지 파일 이름을 서버로 부터 받은 후 해당 이름을 DB에 저장하기 위해 wait()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        //-----------------------------------------
        
        let urlString: String = "http://condi.swu.ac.kr/student/T03nolleo/insertBasicInfo.php"

        guard let requestURL = URL(string: urlString) else { return }
        request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        guard let userID = appDelegate.ID else { return }
        
                // DB에 들어갈 변수 설정
                let title = textTitle.text!
                let area = textArea.text!
                let startdate = startDate.text!
                let enddate = endDate.text!
                let recommendText = recommendReason.text!
                let recommendwhenwhere = recommendWhenWhere.text!
                let recommendcost = recommendCost.text!
        
                var restString: String = "title=" + title + "&user_id=" + userID
                restString = restString + "&area=" + area
                restString = restString + "&start_date=" + startdate + "&end_date=" + enddate
                restString = restString + "&recommend_reason=" + recommendText
                restString = restString + "&recommend_when_where=" + recommendwhenwhere
                restString = restString + "&recommend_cost=" + recommendcost
                restString = restString + "&recommend_img=" + imageFileName
        
        request.httpBody = restString.data(using: .utf8)
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { return }
            guard let receivedData = responseData else { return }
            if let utf8Data = String(data: receivedData, encoding: .utf8) { print(utf8Data) }
        }
        task2.resume()
        _ = self.navigationController?.popViewController(animated: true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
