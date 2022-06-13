//
//  TableViewCell.swift
//  DSU_Sharing_Taxi
//
//  Created by 박태영 on 2022/06/06.
//

import UIKit
import Alamofire

class TableViewCell: UITableViewCell {

    @IBOutlet weak var phn_num_vl: UILabel!
    @IBOutlet weak var phn_num: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var bottom_view: UIStackView!{
        didSet{
            bottom_view.isHidden = true
        }
    }
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var pwd_tf: UITextField!
    var reportButtonAction : (() -> ())?
    var id:Int = 0
    
    @IBAction func clickedDeleteButton(_ sender: Any) {
        print("클릭 버튼 눌러짐")
        var pwd:String = pwd_tf.text as? String ?? ""
        
        AF.request("http://api.dsutaxi.ml:8443/api/taxi/user/\(id)?pw=\(pwd)", method: .delete, parameters: nil, headers: nil).validate(statusCode: 200 ..< 299).responseJSON { AFdata in
                do {
                    guard let jsonObject = try JSONSerialization.jsonObject(with: AFdata.data!) as? [String: Any] else {
                        print("Error: Cannot convert data to JSON object")
                        return
                    }
                    guard let prettyJsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
                        print("Error: Cannot convert JSON object to Pretty JSON data")
                        return
                    }
                    guard let prettyPrintedJson = String(data: prettyJsonData, encoding: .utf8) else {
                        print("Error: Could print JSON in String")
                        return
                    }

                    print(prettyPrintedJson)
                } catch {
                    print("Error: Trying to convert JSON data to string")
                    return
                }
            }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.deleteButton.addTarget(self, action: #selector(clickedDeleteButton(_:)), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
