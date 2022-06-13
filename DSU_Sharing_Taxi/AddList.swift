//
//  AddList.swift
//  DSU_Sharing_Taxi
//
//  Created by 박태영 on 2022/06/10.
//

import Foundation
import UIKit
import Alamofire

class AddList:UIViewController{
    
    @IBOutlet weak var name: UITextField!
    
    @IBOutlet weak var phn: UITextField!
    @IBOutlet weak var passwd: UITextField!
    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var destination: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clickedSubmitButton(_ sender: Any) {
        self.postTest()
    }
    
    func postTest() {
        let url = "http://api.dsutaxi.ml:8443/api/taxi/user"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 10
        // POST 로 보낼 정보
        var user = [:] as Dictionary
        user["name"] = self.name.text as? String ?? ""
        user["password"] = self.passwd.text as? String ?? ""
        user["phone"] = self.phn.text as? String ?? ""
        var loc = [:] as Dictionary
        loc["dest"] = self.destination.text as? String ?? ""
        loc["location"] = self.location.text as? String ?? ""
        var params = [:] as Dictionary
        
        params["user"] = user
        params["loc"] = loc
        // httpBody 에 parameters 추가
        do {
            try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        } catch {
            print("http Body Error")
        }
        AF.request(request).responseString { (response) in
            switch response.result {
            case .success:
                print("POST 성공")
            case .failure(let error):
                print("🚫 Alamofire Request Error\nCode:\(error._code), Message: \(error.errorDescription!)")
            }
        }
    }
}
