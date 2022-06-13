//
//  userList.swift
//  DSU_Sharing_Taxi
//
//  Created by 박태영 on 2022/06/06.
//

import Alamofire
import Foundation
import UIKit

class userList:ViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AF.request("http://api.dsutaxi.ml:8443/api/taxi/user").responseJSON() { response in
          switch response.result {
          case .success:
            if let data = try! response.result.get() as? [String: Any] {
              print(data)
            }
          case .failure(let error):
            print("Error: \(error)")
            return
          }
        }
        
        AF.request("http://localhost:5000/test/post", method: .post, parameters: ["key": "hello!"], encoding: URLEncoding.httpBody).responseJSON() { response in
          switch response.result {
          case .success:
            if let data = try! response.result.get() as? [String: Any] {
              print(data)
            }
          case .failure(let error):
            print("Error: \(error)")
            return
          }
        }
        
        
    }
    
}
