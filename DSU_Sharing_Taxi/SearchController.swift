//
//  SearchController.swift
//  DSU_Sharing_Taxi
//
//  Created by 박태영 on 2022/06/12.
//

import Foundation
import UIKit
import Alamofire

class SearchController:UIViewController, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("카운트 진입")
        return need_parse_list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("셀 디자인 진입")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell else {
            return UITableViewCell() }
        
        print(indexPath.row)
        print(need_parse_list?[indexPath.row])
    
        let list:Dictionary<String,Any> = need_parse_list?[indexPath.row] as! Dictionary<String, Any>
        cell.name.text = list["name"] as? String ?? ""
        cell.location.text = list["location"] as? String ?? ""
        cell.destination.text = list["dest"] as? String ?? ""
        cell.phn_num_vl.text = list["phone_number"] as? String ?? ""
        cell.id = list["id"] as? Int ?? 0
        
        if array_cnt[indexPath.row] == true{
            cell.bottom_view.isHidden = false
        }
        else{
            cell.bottom_view.isHidden = true
        }
        
        return cell
    }
    
    @IBOutlet weak var searchType: UISegmentedControl!
    @IBOutlet weak var findText: UITextField!
    
    @IBOutlet weak var Table: UITableView!
    var detail:[String:Any]!
    var need_parse_list:Array<Any>!
    var array_cnt: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func clickedSearchButton(_ sender: Any) {
        let et_text = self.findText.text as? String ?? ""
        var Type = ""
        switch self.searchType.selectedSegmentIndex{
        case 0:
            Type = "name"
        case 1:
            Type = "location"
        case 2:
            Type = "dest"
        default:
            break;
        }
        let urlString = "http://api.dsutaxi.ml:8443/api/taxi/search?count=10&offset=0&q=\(et_text)&type=\(Type)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
        
        AF.request(url).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = try! response.result.get() as? [String: Any] {
                    print("성공")
                    print(data)
                    self.detail = data

                    print(self.detail["content"])
                    
                    let account:[String:Any]! = self.detail?["content"] as? [String : Any]
                    let list:Array<Dictionary<String,Any>> = account["rows"] as! Array<Dictionary<String, Any>>
                    
                    for cnt in 0..<list.count{
                        self.array_cnt.append(false)
                    }
                    let nib = UINib(nibName: "TableViewCell", bundle: nil)
                    
                    //self.Table.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
                    self.Table.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
                    print("check array")
                    print(self.array_cnt)
                    self.need_parse_list = list
                    self.Table.delegate = self
                    self.Table.dataSource = self
                    self.Table.estimatedRowHeight = 100
                    self.Table.rowHeight = UITableView.automaticDimension
                }
            case .failure(let error):
                print("파싱에러 1")
                print("Error: \(error)")
                return
            }
    }
    }
}
    
extension SearchController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        print(self.need_parse_list)
        if array_cnt[indexPath.row] == true{
            array_cnt[indexPath.row] = false
        }
        else{
            array_cnt[indexPath.row] = true
        }
        tableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
}
