//
//  new_message.swift
//  AppChat_Again
//
//  Created by HaiPhan on 6/11/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit
import Firebase

class new_message: UITableViewController {
    
    @IBOutlet var tb_new_message: UITableView!
    private let CellReuseIdentifier = "cell"
    var array_User: [User] = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        implement_code()
    }
    func implement_code(){
        navigation_setup()
        get_data_from_firebase()
    }
    
    //Láy dữ liêu jtuwf firebase
    func get_data_from_firebase(){
        let table_user = ref.child("user")
        table_user.observe(.childAdded) { (snap) in
            let mangtemp = snap.value as! NSDictionary
            let name = mangtemp["name"] as! String
            let pass = mangtemp["pass"] as! String
            let email = mangtemp["email"] as! String
            let avatar_url = mangtemp["avatar_url"] as? String
            let id = mangtemp["id"] as? String
            let user = User(name: name , pass: pass , email: email , avatar_url: avatar_url ?? "", id: id ?? "")
            self.array_User.append(user)
            self.tb_new_message.reloadData()
        }
    }
    
    //set up navigation item
    func navigation_setup(){
        self.navigationItem.title = "New message"
        self.tb_new_message.register(User_cell.self, forCellReuseIdentifier: CellReuseIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array_User.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:CellReuseIdentifier, for: indexPath) as! User_cell
        let user_object = self.array_User[indexPath.row]
        cell.textLabel?.text = self.array_User[indexPath.row].name
        cell.detailTextLabel?.text = self.array_User[indexPath.row].email
        //load hình từ firebase
        cell.image_new.load_image(text: user_object.avatar_url!, position_x: 20, position_y: 20 )
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let screen = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chat_collect") as! chat_collect
        screen.user = self.array_User[indexPath.row]
        navigationController?.pushViewController(screen, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    
}
class User_cell: UITableViewCell {
    let image_new : UIImageView = {
        let image_avatar = UIImageView()
        image_avatar.image = UIImage(named: "loading")
        
        image_avatar.layer.cornerRadius = 20
        image_avatar.clipsToBounds = true
        image_avatar.layer.borderColor = UIColor.brown.cgColor
        image_avatar.contentMode = UIImageView.ContentMode.scaleAspectFill
        image_avatar.layer.borderWidth = 2
        return image_avatar
    }()
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 56, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 56, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(image_new)
        image_new.translatesAutoresizingMaskIntoConstraints = false
        image_new.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        //        image_avtar.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        image_new.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        image_new.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image_new.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



