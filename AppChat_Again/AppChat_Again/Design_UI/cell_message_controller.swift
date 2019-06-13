//
//  cell_message_controller.swift
//  AppChat_Again
//
//  Created by HaiPhan on 6/12/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit

class cell_message_controller: UITableViewCell {
    //khởi tạo biến message
    //để bên message controller trỏ qua đay xử lý
    //cho gọn code
    var mess: Mess? {
        didSet {
            get_data_user_from_firebase()
            let second = mess!.timestamp?.doubleValue
            let timestamp_date = NSDate(timeIntervalSince1970: second!)
            let dateformat = DateFormatter()
            dateformat.dateFormat = "MMM d, h:mm a"
            self.time_label.text = dateformat.string(from: timestamp_date as Date)
        }
    }
    //lấy dữ liệu user từ firebase
    func get_data_user_from_firebase(){
        let partner_id = mess?.get_partner_id()
        let table_user = ref.child("user").child(partner_id!)
        //load dữ liệu từ table user
        table_user.observe(.value) { (snap) in
            let mangtemp = snap.value as! NSDictionary
            let avatar_url = mangtemp["avatar_url"] as? String
            let email = mangtemp["email"] as? String
            let id = mangtemp["id"] as? String
            let name = mangtemp["name"] as? String
            let pass = mangtemp["pass"] as? String
            let user: User = User(name: name!, pass: pass ?? "", email: email ?? "", avatar_url: avatar_url ?? "", id: id ?? "")
            self.textLabel?.text = user.name
            self.image_partner.load_image(text: user.avatar_url!, position_x: 40, position_y: 40)
        }
    }
    //steup img cho partner
    let image_partner : UIImageView = {
        let img = UIImageView()
        //        img.image = UIImage(named: "loading")
        img.layer.cornerRadius = 20
        img.layer.borderColor = UIColor.brown.cgColor
        img.layer.borderWidth = 2
        img.clipsToBounds = true
        return img
    }()
    
    let time_label: UILabel = {
        let text = UILabel()
        text.font = UIFont.boldSystemFont(ofSize: 13)
        text.textAlignment = NSTextAlignment.right
        //        text.backgroundColor = UIColor.red
        return text
    }()
    
    //chỉnh lại layout cho title & subtitle
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 56, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 56, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    //setup cell lại thành subtitle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(image_partner)
        addSubview(time_label)
        
        //Autolayout image - partner
        image_partner.translatesAutoresizingMaskIntoConstraints = false
        image_partner.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        image_partner.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        image_partner.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image_partner.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //Autolayout text label
        time_label.translatesAutoresizingMaskIntoConstraints = false
        time_label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        time_label.topAnchor.constraint(equalTo: textLabel!.topAnchor, constant: 0).isActive = true
        time_label.widthAnchor.constraint(equalToConstant: 120).isActive = true
        time_label.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
