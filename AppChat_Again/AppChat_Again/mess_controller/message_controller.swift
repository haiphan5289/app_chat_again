//
//  message_controller.swift
//  AppChat_Again
//
//  Created by HaiPhan on 6/10/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit
import Firebase

class message_controller: UITableViewController {
    
    @IBOutlet var tb_message_controller: UITableView!
    let current_user = Auth.auth().currentUser
    var array_user: [User] = [User]()
    var array_message: [Mess] = [Mess]()
    private let CellReuseIdentifier = "cell"
    override func viewDidLoad() {
        super.viewDidLoad()
        //khơi tạo cell, truyền tham chiếu UItableviewcell
        tb_message_controller.register(cell_message_controller.self, forCellReuseIdentifier: CellReuseIdentifier)
        implement_code()
    }
    func implement_code(){
        get_current_user_from_firebase()
        get_data_current_user_to_firebase()
        get_data_table_user_mess_from_firebase()
    }
    
    //setup navigatiom view title item
    func navigation_setup(user: User){
        left_bar_button()
        navigationItem.title = current_user?.displayName
        
        //Setup title view
        let title_view = UIView()
        //        title_view.backgroundColor = UIColor.brown
        title_view.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        
        //setup title view
        let title = UILabel()
        title.text = user.name
        title_view.addSubview(title)
        
        //setup image title
        let image_title = UIImageView()
        image_title.image = UIImage(named: "loading")
        title_view.addSubview(image_title)
        
        //Add contrainst cho title
        title.translatesAutoresizingMaskIntoConstraints = false
        title.leftAnchor.constraint(equalTo: image_title.rightAnchor, constant: 8).isActive = true
        title.topAnchor.constraint(equalTo: title_view.topAnchor, constant: 0).isActive = true
        title.bottomAnchor.constraint(equalTo: title_view.bottomAnchor, constant: 0).isActive = true
        title.rightAnchor.constraint(equalTo: title_view.rightAnchor, constant: 0).isActive = true
        
        
        
        //add constraints cho image
        image_title.translatesAutoresizingMaskIntoConstraints = false
        image_title.leftAnchor.constraint(equalTo: title_view.leftAnchor, constant: 0).isActive = true
        image_title.centerYAnchor.constraint(equalTo: title_view.centerYAnchor, constant: 0).isActive = true
        //        image_title.bottomAnchor.constraint(equalTo: title_view.bottomAnchor, constant: 0).isActive = true
        //        image_title.rightAnchor.constraint(equalTo: title.leftAnchor, constant: 8).isActive = true
        image_title.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image_title.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        navigationItem.titleView = title_view
    }
    
    //lấy dữ liệu current user từ firebase
    func get_current_user_from_firebase(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let table_user = ref.child("user").child(uid)
        table_user.observe(.value, with: { (snap) in
            let mangtemp = snap.value as! NSDictionary
            let avatar_url = mangtemp["avatar_url"] as? String
            let email = mangtemp["email"] as? String
            let id = mangtemp["id"] as? String
            let name = mangtemp["name"] as? String
            let pass = mangtemp["pass"] as? String
            let user: User = User(name: name!, pass: pass ?? "", email: email ?? "", avatar_url: avatar_url ?? "", id: id ?? "")
            self.navigation_setup(user: user)
        })
        
    }
    
    //khai báo mảng có key là to_id (partner id)
    var message_dictionary: [String:Any] = [String:Any]()
    //get data from table user - mess
    func get_data_table_user_mess_from_firebase(){
        guard let current_user = Auth.auth().currentUser else {
            return
        }
        //lấy key của partner
        let table_user = ref.child("usermess").child(current_user.uid)
        table_user.observe(.childAdded) { (snap) in
            let key_partner = snap.key
            //lấy dữ liệu của partner
            let table_user_partner = ref.child("usermess").child(current_user.uid).child(key_partner)
            table_user_partner.observe(.childAdded, with: { (snap) in
                let key_mess = snap.key
                //lấy dữ liệ cuta table mess
                let table_mess = ref.child("mess").child(key_mess)
                table_mess.observe(.value, with: { (snap) in
                    let mangtemp = snap.value as? NSDictionary
                    let from_id = mangtemp?["from_id"] as? String
                    let mess = mangtemp?["mess"] as? String
                    let timestamp = mangtemp?["timestamp"] as? NSNumber
                    let toid = mangtemp?["to_id"] as? String
                    let image_url = mangtemp?["image_url"] as? String
                    let width_image = mangtemp?["width_image"] as? NSNumber
                    let height_image = mangtemp?["height_image"] as? NSNumber
                    let mess_user: Mess = Mess(fromid: from_id ?? "", mess: mess ?? "", timestamp: timestamp ?? 0, toid: toid ?? "", image_url: image_url ?? "", width_image: width_image ?? 0, height_image: height_image ?? 0)
                    self.array_message.append(mess_user)
                    //detect toid từ mess_user
                    //Group các dữ liệu mess cugnf ID lại với nhau
                    let key_to_id = mess_user.get_partner_id()
                    self.message_dictionary[key_to_id] = mess_user
                    //truyegn giái trị cho mảng array_ message
                    self.array_message = Array(self.message_dictionary.values) as! [Mess]
                    //sắp xếp mess theo thứ tụw lớn nhât >>> nhỏ nhất
                    self.array_message.sort(by: { (mess1, mess2) -> Bool in
                        return mess1.timestamp!.intValue > mess2.timestamp!.intValue
                    })
                    self.tb_message_controller.reloadData()
                })
            })
            //lấy dữ liệu user
            //            let table_user = ref.child("user").child(key_partner)
            //            table_user.observe(.value, with: { (snap) in
            //                let mangtemp = snap.value as! NSDictionary
            //                let avatar_url = mangtemp["avatar_url"] as? String
            //                let email = mangtemp["email"] as? String
            //                let id = mangtemp["id"] as? String
            //                let name = mangtemp["name"] as? String
            //                let pass = mangtemp["pass"] as? String
            //                let user: User = User(name: name!, pass: pass ?? "", email: email ?? "", avatar_url: avatar_url ?? "", id: id ?? "")
            //                self.array_user.append(user)
            //                self.tb_message_controller.reloadData()
            //            })
            
        }
    }
    
    //get data của current user
    func get_data_current_user_to_firebase(){
        guard let current_user = Auth.auth().currentUser else {
            return
        }
        navigationItem.title = "loading..."
        let table_user = ref.child("user").child(current_user.uid)
        table_user.observe(.value) { (snap) in
            let mangtemp = snap.value as? NSDictionary
            let avatar_url = mangtemp?["avatar_url"] as? String
            let email = mangtemp?["email"] as? String
            let id = mangtemp?["id"] as? String
            let name = mangtemp?["name"] as? String
            let pass = mangtemp?["pass"] as? String
            let user: User = User(name: name ?? "", pass: pass ?? "", email: email ?? "", avatar_url: avatar_url ?? "", id: id ?? "")
            self.navigationItem.title = user.name
        }
    }
    //setup left button
    func left_bar_button(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handle_logout))
        let image = UIImage(named: "new")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handle_new))
    }
    
    @objc func handle_new(){
        self.move_to_screen_by_navi(text: "new_message")
    }
    
    //logout acc và move về màn hình login
    @objc func handle_logout(){
        do {
            try Auth.auth().signOut()
        }catch let err as NSError{
            print(err)
        }
        self.move_to_screen_by_navi(text: "login")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return array_message.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellReuseIdentifier, for: indexPath) as! cell_message_controller
        let partner_object = self.array_message[indexPath.row]
        cell.detailTextLabel?.text = self.array_message[indexPath.row].mess
        //trở qua biến mess để xử lý dữ liệu
        // cho view nầy gọn code
        //khai báo biến mess là Mess bên cell, để delegate cho nó gọn code
        cell.mess = partner_object
        return cell
        //        let table_user = ref.child("user").child(partner_object.toid!)
        //load dữ liệu từ table user
        //        table_user.observe(.value) { (snap) in
        //            let mangtemp = snap.value as! NSDictionary
        //            let avatar_url = mangtemp["avatar_url"] as? String
        //            let email = mangtemp["email"] as? String
        //            let id = mangtemp["id"] as? String
        //            let name = mangtemp["name"] as? String
        //            let pass = mangtemp["pass"] as? String
        //            let user: User = User(name: name!, pass: pass ?? "", email: email ?? "", avatar_url: avatar_url ?? "", id: id ?? "")
        //            cell.textLabel?.text = user.name
        //            cell.image_partner.load_image(text: user.avatar_url!, position_x: 40, position_y: 40)
        //        }
        //đổi timestamp thành format
        //        let second = partner_object.timestamp?.doubleValue
        //        let timestamp_date = NSDate(timeIntervalSince1970: second!)
        //        let dateformat = DateFormatter()
        //        dateformat.dateFormat = "MMM d, h:mm a"
        //        cell.time_label.text = dateformat.string(from: timestamp_date as Date)
    }
    //get dữ liệu của partner id, để truyền qua màn hình chat_collect
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let screen = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "chat_collect") as! chat_collect
        let partner_id = self.array_message[indexPath.row].get_partner_id()
        let table_user = ref.child("user").child(partner_id)
        table_user.observe(.value) { (snap) in
            let mangtemp = snap.value as! NSDictionary
            let avatar_url = mangtemp["avatar_url"] as? String
            let email = mangtemp["email"] as? String
            let id = mangtemp["id"] as? String
            let name = mangtemp["name"] as? String
            let pass = mangtemp["pass"] as? String
            let user: User = User(name: name!, pass: pass ?? "", email: email ?? "", avatar_url: avatar_url ?? "", id: id ?? "")
            screen.user = user
        }
        navigationController?.pushViewController(screen, animated: true)
    }
    //setup lại chiều cao cho cell
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56
    }
    
    
}
