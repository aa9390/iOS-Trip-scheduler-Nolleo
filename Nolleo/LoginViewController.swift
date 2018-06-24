//
//  ViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 5. 26..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var loginUserid: UITextField!
    @IBOutlet var loginUserpw: UITextField!
    @IBOutlet var labelLoginStatus: UILabel!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { if textField == self.loginUserid {
            textField.resignFirstResponder()
            self.loginUserpw.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    // 로그인 버튼 눌렀을 시
    @IBAction func loginPressed() {
        // 입력값 검증
        if loginUserid.text == "" {
            labelLoginStatus.text = "ID를 입력하세요"
            return
        }
        if loginUserpw.text == "" {
            labelLoginStatus.text = "PW를 입력하세요"
            return
        }
        self.labelLoginStatus.text = " "
        
//        let urlString: String = "http://localhost:8888/nolleo/login/loginUser.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T03nolleo/loginUser.php"
        guard let requestURL = URL(string: urlString) else {
            return
        }
        
        self.labelLoginStatus.text = " "
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        
        let restString: String = "id=" + loginUserid.text! + "&password=" + loginUserpw.text!
        request.httpBody = restString.data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST")
                return }
            guard let receivedData = responseData else { print("Error: not receiving Data")
                return }
            do {
                // 응답 상태 코드가 성공이 아니면 에러 메시지 리턴
                let response = response as! HTTPURLResponse
                if !(200...299 ~= response.statusCode)
                {
                    print ("HTTP Error!")
                    return
                }
                guard let jsonData = try JSONSerialization.jsonObject(with: receivedData, options:.allowFragments) as? [String: Any] else {
                    print("JSON Serialization Error!")
                    return
                }
                
                guard let success = jsonData["success"] as! String! else {
                    print("Error: PHP failure(success)")
                    return
                }
                
                // 로그인에 성공했을 경우
                // Main 화면으로 이동
                if success == "YES" {
//                    if let name = jsonData["name"] as! String! {
                        DispatchQueue.main.async {
//                            self.labelLoginStatus.text = name + "님 안녕하세요?"
            
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.ID = self.loginUserid.text
//                            appDelegate.userName = name
//                            appDelegate.profile_img =
                            self.performSegue(withIdentifier: "toLoginSuccess", sender: self)
                        }
//                    }
                } else {
                    if let errMessage = jsonData["error"] as! String! {
                        DispatchQueue.main.async {
                        self.labelLoginStatus.text = errMessage }
                    }
                }
            } catch {
                print("Error: \(error)") }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelLoginStatus.text = ""
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

