//
//  chat_collect.swift
//  AppChat_Again
//
//  Created by HaiPhan on 6/11/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

private let reuseIdentifier = "Cell"

class chat_collect: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var user: User? {
        didSet{
            navigationItem.title = user?.name
        }
    }
    @IBOutlet var collect: UICollectionView!
    var view_chat: UIView = UIView()
    var send_button: UIButton = UIButton()
    var txt_mess: UITextField = UITextField()
    var image_chat: UIImageView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        //cách top của view_chat = 60
        collect.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 60, right: 0)
        collect.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 60, right: 0)
        collect.alwaysBounceVertical = true
        self.collect!.register(cell_chat_message.self, forCellWithReuseIdentifier: reuseIdentifier)
        implement_code()
        
    }
    func implement_code(){
        //        set_up_navigation_item()
        view_chat_setup_autolayout()
        image_chat_setup_autolayout()
        send_button_setup_autolayout()
        txt_mess_setup_autolayout()
        get_mess_from_firebase()
    }
    var array_mess: [Mess] = [Mess]()
    //get mess từ fiebase
    func get_mess_from_firebase(){
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let table_mess = ref.child("usermess").child(uid)
        table_mess.observe(.childAdded) { (snap) in
            let key_partner = snap.key
            let table_mess_partner = ref.child("usermess").child(uid).child(key_partner)
            table_mess_partner.observe(.childAdded, with: { (snap) in
                let key_mess = snap.key
                let table_mess = ref.child("mess").child(key_mess)
                table_mess.observe(.value, with: { (snap) in
                    let mangtemp = snap.value as? NSDictionary
                    let from_id = mangtemp!["from_id"] as! String
                    let mess = mangtemp?["mess"] as? String
                    let timestamp = mangtemp!["timestamp"] as! NSNumber
                    let to_id = mangtemp!["to_id"] as! String
                    let image_url = mangtemp?["image_url"] as? String
                    let width_image = mangtemp?["width_image"] as? NSNumber
                    let height_image = mangtemp?["height_image"] as? NSNumber
                    let mess_data : Mess = Mess(fromid: from_id, mess: mess ?? "", timestamp: timestamp, toid: to_id, image_url: image_url ?? "", width_image: width_image ?? 0, height_image: height_image ?? 0)
                    self.array_mess.append(mess_data)
                    self.collect.reloadData()
                    let indexPath = NSIndexPath(item: self.array_mess.count - 1, section: 0)
                    self.collect.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
                })
            })
        }
    }
    
    //setup image upload
    func image_chat_setup_autolayout(){
        image_chat.image = UIImage(named: "gallery")
        image_chat.isUserInteractionEnabled = true
        image_chat.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handle_select_image)))
        view_chat.addSubview(image_chat)
        
        //autolayout image chat
        image_chat.translatesAutoresizingMaskIntoConstraints = false
        image_chat.leftAnchor.constraint(equalTo: view_chat.leftAnchor, constant: 8).isActive = true
        image_chat.centerYAnchor.constraint(equalTo: view_chat.centerYAnchor, constant: 0).isActive = true
        image_chat.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image_chat.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    //handle khi user click vào image
    @objc func handle_select_image(){
        let image_picker : UIImagePickerController = UIImagePickerController()
        image_picker.delegate = self
        image_picker.allowsEditing = true
        image_picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        present(image_picker, animated: true, completion: nil)
        
    }
    
    //setup & autolayout txt mess cho view chat
    func txt_mess_setup_autolayout(){
        txt_mess.placeholder = "Enter your message..."
        txt_mess.translatesAutoresizingMaskIntoConstraints = false
        view_chat.addSubview(txt_mess)
        txt_mess.leftAnchor.constraint(equalTo: image_chat.rightAnchor, constant: 8).isActive = true
        txt_mess.centerYAnchor.constraint(equalTo: view_chat.centerYAnchor, constant: 0).isActive = true
        txt_mess.rightAnchor.constraint(equalTo: send_button.leftAnchor, constant: -10).isActive = true
        txt_mess.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //setup & autolayout  button send cho view chat
    func send_button_setup_autolayout(){
        send_button = UIButton(type: .contactAdd)
        //        send_button.backgroundColor = .blue
        //        send_button.setImage(UIImage(named: "send"), for: .normal)
        send_button.addTarget(self, action: #selector(send_mess_to_firebase), for: .touchUpInside)
        view_chat.addSubview(send_button)
        send_button.translatesAutoresizingMaskIntoConstraints = false
        send_button.rightAnchor.constraint(equalTo: view_chat.rightAnchor, constant: -8).isActive = true
        send_button.centerYAnchor.constraint(equalTo: view_chat.centerYAnchor, constant: 0).isActive = true
        send_button.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    //func gửi send lên firebase
    @objc func send_mess_to_firebase(){
        //tạo bảng mess
        let uid = Auth.auth().currentUser?.uid
        let user_id = user?.id!
        let text_mess = txt_mess.text!
        let table_mess = ref.child("mess").childByAutoId()
        let fromid = uid
        let toid = user_id
        let mess = text_mess
        let timestamp: NSNumber = NSNumber(value: Int(Date().timeIntervalSince1970))
        let data = ["from_id": fromid ?? "", "to_id": toid ?? "", "mess": mess, "timestamp": timestamp] as [String : Any]
        //setvalue chỉ có thềm vào thôi nếu muốn sau khi thểm mà lấy được key thì dung updatechildvaue
        //        table_mess.setValue(data)
        table_mess.updateChildValues(data) { (err, data) in
            if err != nil {
                print(err?.localizedDescription ?? "hihi")
                return
            }
            let table_user_mess = ref.child("usermess").child(fromid!).child(toid!)
            let data_from_id = ["\(table_mess.key!)": 1]
            table_user_mess.updateChildValues(data_from_id)
            let table_user_mess_toid = ref.child("usermess").child(toid!).child(fromid!)
            table_user_mess_toid.updateChildValues(data_from_id)
        }
    }
    
    //setup & autolayout view chat
    func view_chat_setup_autolayout(){
        view_chat.backgroundColor = .white
        view_chat.layer.borderColor = UIColor.darkGray.cgColor
        view_chat.layer.borderWidth = 2
        self.view.addSubview(view_chat)
        view_chat.translatesAutoresizingMaskIntoConstraints = false
        view_chat.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        view_chat.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        view_chat.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        view_chat.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //set-up & autolayout view_chat
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.array_mess.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! cell_chat_message
        cell.text_label.text = self.array_mess[indexPath.row].mess
        //        let message = self.array_mess[indexPath.row]
        //        print(message.toid)
        let message = self.array_mess[indexPath.row]
        //Customize width của buddle with
        //dùng cell để delegate tới  cell_chat_message
        cell.chat_collect_delegate = self
        //set up hiển thị cho from id & to id
        if message.fromid == Auth.auth().currentUser?.uid{
            cell.buble_view.backgroundColor = UIColor.init(red: 61, green: 91, blue: 151)
            //            cell.buble_view.backgroundColor = .green
            cell.text_label.textColor = UIColor.white
            cell.image_profile_partner.isHidden = true
            cell.left_buble?.isActive = false
            cell.right_buble?.isActive = true
            
        }
        else {
            cell.buble_view.backgroundColor = UIColor.init(red: 240, green: 240, blue: 240)
            cell.image_profile_partner.isHidden = false
            cell.text_label.textColor = UIColor.black
            cell.buble_view.backgroundColor = UIColor.clear
            cell.left_buble?.isActive = true
            cell.right_buble?.isActive = false
            //            cell.image_profile_partner.load_image(text: user!.avatar_url!, position_x: 20, position_y: 20)
        }
        //        if message.image_url != "" {
        //            //            cell.width_buble?.constant = 300
        //            cell.image_chat.load_image(text: message.image_url!, position_x: 40, position_y: 40)
        //            cell.image_chat.isHidden = false
        //            cell.buble_view.backgroundColor = UIColor.clear
        //        }
        //        else {
        //            cell.image_chat.isHidden = false
        //        }
        
        //setup hiển thị khi mess khác "" và image_url khác ""
        if  message.mess != ""{
            cell.width_buble?.constant = estimate_frame_for_text(text: message.mess!).width + 32
            cell.text_label.isHidden = false
            cell.image_chat.isHidden = true
            //            cell.buble_view.isHidden = false
        }
        else if message.image_url != "" {
            cell.image_chat.load_image(text: message.image_url!, position_x: 40, position_y: 40)
            cell.image_chat.isHidden = false
            cell.buble_view.backgroundColor = UIColor.clear
            cell.width_buble?.constant = 300
            cell.text_label.isHidden = true
        }
        return cell
    }
    //customiz width & height của cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height : CGFloat = 80
        let message = self.array_mess[indexPath.row]
        let width_image = message.width_image!.floatValue
        let height_image = message.height_image!.floatValue
        if message.mess != "" {
            height = estimate_frame_for_text(text: self.array_mess[indexPath.row].mess!).height + 10
        }else if message.image_url != "", width_image != 0, height_image != 0 {
            height = CGFloat(height_image / width_image * 300)
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    //height của cell sẽ phụ thuộc vào chiều dài của text
    private func estimate_frame_for_text(text: String) -> CGRect {
        let size = CGSize(width: self.view.frame.size.width - 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)], context: nil)
    }
    
    //upload image to firebase
    func upload_image_to_firebase(image: UIImage){
        let random_image = Int.random(in: 0...10000)
        let folder_chat = folder.child("Chat:/\(random_image).jpg")
        let image_data = image.pngData()
        _ = folder_chat.putData(image_data!, metadata: nil) { (metadata, err) in
            if err != nil {
                print(err?.localizedDescription ?? "hihi")
                return
            }
            folder_chat.downloadURL(completion: { (url, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "hihi")
                    return
                }
                let image_url = url?.absoluteString
                let uid = Auth.auth().currentUser?.uid
                let user_id = self.user?.id!
                let table_mess = ref.child("mess").childByAutoId()
                let fromid = uid
                let toid = user_id
                let width_image = image.size.width
                let height_image = image.size.height
                let timestamp: NSNumber = NSNumber(value: Int(Date().timeIntervalSince1970))
                let data = ["from_id": fromid ?? "", "to_id": toid ?? "", "image_url": image_url ?? "", "timestamp": timestamp, "width_image": width_image, "height_image": height_image] as [String : Any]
                //setvalue chỉ có thềm vào thôi nếu muốn sau khi thểm mà lấy được key thì dung updatechildvaue
                //        table_mess.setValue(data)
                table_mess.updateChildValues(data) { (err, data) in
                    if err != nil {
                        print(err?.localizedDescription ?? "hihi")
                        return
                    }
                    let table_user_mess = ref.child("usermess").child(fromid!).child(toid!)
                    let data_from_id = ["\(table_mess.key!)": 1]
                    table_user_mess.updateChildValues(data_from_id)
                    let table_user_mess_toid = ref.child("usermess").child(toid!).child(fromid!)
                    table_user_mess_toid.updateChildValues(data_from_id)
                }
            })
            }.resume()
    }
    
    //khơi tạo biên stảting view đê zooom ou lại
        var starting_view_frame: CGRect?
    //đêm back ground ra ngoai để khi zoom out thi chỉnh lại alpha
        var background: UIView?
        var zoom_view: UIImageView?
    //func scale & zoom image khi click
    func image_chat_zoom(starting_image_view: UIImageView){
        //tạo 1 biến để convert image frame
        //lấy toạ độ của iamge
        //Xác đinh toạ độ image
        starting_view_frame = starting_image_view.superview?.convert(starting_image_view.frame, to: nil)
        ////        //tạo biến zoom view để lây image ra
        zoom_view = UIImageView(frame: starting_view_frame!)
        zoom_view!.backgroundColor = UIColor.red
        zoom_view!.image = starting_image_view.image
        zoom_view?.isUserInteractionEnabled = true
        zoom_view?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handle_zoom_out)))
        ////        //khởi tạo key window
        if let key_window = UIApplication.shared.keyWindow {
            background = UIView()
            background = UIImageView(frame: CGRect(x: 0, y: 0, width: key_window.frame.width, height: key_window.frame.height))
            background!.backgroundColor = UIColor.black
            background!.alpha = 0
            background?.isUserInteractionEnabled = true
            background?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handle_zoom_out)))
            key_window.addSubview(background!)
            key_window.addSubview(zoom_view!)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                //tính chiều cao của image
                let height = self.zoom_view!.frame.height / self.zoom_view!.frame.width * key_window.frame.width
                //set lại toạ độ zoom view
                self.zoom_view!.frame = CGRect(x: 0, y: 0, width: key_window.frame.width, height: height)
                //cho zoom view ở giữa key window
                self.zoom_view!.center = key_window.center
                //đm vì caí này mà thanh navigation bả k mất
                self.background!.alpha = 1
                key_window.backgroundColor = UIColor.black
                self.collect.isHidden = true
                self.view_chat.isHidden = true
            }, completion: nil)
        }
        
    }
    
    //zoom out image
    @objc func handle_zoom_out(tap: UITapGestureRecognizer){
                if let zoom_view_out = tap.view as? UIImageView {
                    //quay lại vị trí ban đầu
                    zoom_view_out.frame = starting_view_frame!
                    UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                        self.background!.alpha = 0
                        self.view_chat.alpha = 1
                    }) { (completion: Bool) in
                        self.zoom_view?.removeFromSuperview()
                        self.collect.isHidden = false
                        self.view_chat.isHidden = false
                    }
                }
    }
    
}
extension chat_collect: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choose_image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        dismiss(animated: true, completion: nil)
        upload_image_to_firebase(image: choose_image)
    }
}
