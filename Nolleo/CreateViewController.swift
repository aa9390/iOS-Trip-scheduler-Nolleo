//
//  CreateViewController.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 5. 26..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
    
    // 선택 버튼 클릭
    @IBAction func btnProfilePic(_ sender: UIButton) {
        // 갤러리에서 이미지 선택
            let myPicker = UIImagePickerController()
            myPicker.delegate = self;
            myPicker.sourceType = .photoLibrary
            self.present(myPicker, animated: true, completion: nil)
    }
    
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.imageCreateProfile.image = image
            }
            self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel (_ picker: UIImagePickerController) {
            self.dismiss(animated: true, completion: nil)
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
        
        //-------------이미지 전송 관련-----------------
        guard let myImage = imageCreateProfile.image else {
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
        
        // insertUser.php의 Uri String 선언
//        let urlString: String = "http://localhost:8888/nolleo/login/insertUser.php"
        let urlString: String = "http://condi.swu.ac.kr/student/T03nolleo/insertUser.php"

        // guard let? null이면 else부분 실행.
        // null이 아니면 참인 부분 실행.
        // 여기서는 참인 부분이 없으므로 아무것도 실행하지 않음.
        guard let requestURL = URL(string: urlString) else {
            return
        }
        
        request = URLRequest(url: requestURL)
        
        // POST 메소드를 사용하여 사용자 정보 전송
        request.httpMethod = "POST"

        let restString: String
            = "&gender=" + gender!
            + "&id=" + textCreateId.text!
            + "&password=" + textCreatePw.text!
            + "&name=" + textCreateName.text!
            + "&birth=" + birth
            + "&profile_img=" + imageFileName
        
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
