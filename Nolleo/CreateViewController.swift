//
//  CreateViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 5. 26..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var imageCreateProfile: UIImageView!
    @IBOutlet var segCreateGender: UISegmentedControl!
    @IBOutlet var textCreateId: UITextField!
    @IBOutlet var textCreatePw: UITextField!
    @IBOutlet var textCreatePwRe: UITextField!
    @IBOutlet var textCreateName: UITextField!
    @IBOutlet var pickerCreateDate: UIDatePicker!
    @IBOutlet var labelCreateStatus: UILabel!
    
    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        if textField == self.textCreateId { textField.resignFirstResponder()
            self.textCreatePw.becomeFirstResponder()
        }
        else if textField == self.textCreatePw {
            textField.resignFirstResponder()
            self.textCreateName.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelCreateStatus.text = ""
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 제출 버튼을 눌렀을 때
    // id, pw, 이름이 모두 입력되었는지를 확인
    // 프로필사진, 성별, 생일은 추후 입력하게 할 예정
    @IBAction func buttonSavePressed() {
        if textCreateId.text == "" {
            labelCreateStatus.text = "아이디를 입력하세요."
            return;
        }
        
        if textCreatePw.text == "" {
            labelCreateStatus.text = "비밀번호를 입력하세요."
            return;
        }
            
        if textCreatePwRe.text != textCreatePw.text {
            labelCreateStatus.text = "비밀번호를 확인해 주세요"
            return;
        }
        
        if textCreateName.text == "" {
            labelCreateStatus.text = "이름을 입력하세요."
            return;
        }
        
        let gender = segCreateGender.titleForSegment(at: segCreateGender.selectedSegmentIndex)
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"

        let birth : String
        birth = formatter.string(from: pickerCreateDate.date)
        
        // insertUser.php의 Uri String 선언
//        let urlString: String = "http://localhost:8888/nolleo/login/insertUser.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T03nolleo/insertUser.php"

        // guard let? null이면 else부분 실행.
        // null이 아니면 참인 부분 실행.
        // 여기서는 참인 부분이 없으므로 아무것도 실행하지 않음.
        guard let requestURL = URL(string: urlString) else {
            return
        }
        
        var request = URLRequest(url: requestURL)
        
        // POST 메소드를 사용하여 사용자 정보 전송
        request.httpMethod = "POST"

        let restString: String
            = "&gender=" + gender!
            + "&id=" + textCreateId.text!
            + "&password=" + textCreatePw.text!
            + "&name=" + textCreateName.text!
            + "&birth=" + birth
        
//        restString = restString + "&birth=" + birth
        
        request.httpBody = restString.data(using: .utf8)

        self.executeRequest(request: request)
        
        // 회원가입 성공 시 이전 화면으로 이동
        self.dismiss(animated: true, completion: nil)
    }
    
    func executeRequest (request: URLRequest) -> Void {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST")
                return }
            guard let receivedData = responseData else { print("Error: not receiving Data")
                return }
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                DispatchQueue.main.async { // for Main Thread Checker
                self.labelCreateStatus.text = utf8Data
                print(utf8Data) // php에서 출력한 echo data가 debug 창에 표시됨
                }
            }
        }
            task.resume()
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
