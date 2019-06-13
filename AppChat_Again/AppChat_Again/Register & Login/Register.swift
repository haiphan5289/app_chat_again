//
//  Register.swift
//  AppChat_Again
//
//  Created by HaiPhan on 6/10/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit
import Firebase

var ref = Database.database().reference(fromURL: "https://appchatagain.firebaseio.com/")
var folder = Storage.storage().reference()

class Register: UIViewController {

    @IBOutlet weak var view_register: UIView!
    @IBOutlet weak var view_txt_name: UIView!
    @IBOutlet weak var txt_name: UITextField!
    @IBOutlet weak var view_email: UIView!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var view_txt_password: UIView!
    @IBOutlet weak var txt_password: UITextField!
    @IBOutlet weak var register_button: UIButton!
    @IBOutlet weak var register_image: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 61, green: 91, blue: 151)
        implement_code()
    }
    func implement_code(){
        view_register_autolayout()
        view_txt_name_setup_autolayout()
        txt_name_setup_autolayout()
        view_txt_email_setup_autolayout()
        txt_email_setup_autolayout()
        view_txt_pass_setup_autolayout()
        txt_password_setup_autolayout()
        register_button_setup_autolayout()
        register_image_setup_autolayout()
    }
    //Select image cho register
    @IBAction func select_image(_ sender: UITapGestureRecognizer) {
        let alert: UIAlertController = UIAlertController(title: "thông báo", message: "Chọn dịch vụ", preferredStyle: .alert)
        let photo_bt: UIAlertAction = UIAlertAction(title: "Photo", style: .default) { (photo) in
            self.image_source_type(type: .photoLibrary)
        }
        let camera_bt: UIAlertAction = UIAlertAction(title: "Camera", style: .default) { (camera) in
            self.image_source_type(type: .camera)
        }
        let cancel_bt: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(photo_bt)
        alert.addAction(camera_bt)
        alert.addAction(cancel_bt)
        present(alert, animated: true, completion: nil)
    }
    //select source type
    func image_source_type(type: UIImagePickerController.SourceType){
        let image_picker: UIImagePickerController = UIImagePickerController()
        image_picker.delegate = self
        image_picker.allowsEditing = true
        image_picker.sourceType = type
        present(image_picker, animated: true, completion: nil)
    }
    //tạo user & move to chat mess
    @IBAction func register_to_firebase(_ sender: UIButton) {
        //un-wrap cho các biến
        guard let email = txt_email.text, let pass = txt_password.text, let name = txt_name.text else {
            return
        }
        //create UIActivityIndicatorView để user dễ nhìn
        let alert: UIAlertController = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        let activities: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activities.color = .brown
        //khởi tao cgrect cho activities
        activities.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activities.startAnimating()
        //khỏi tạo width cho alert
        let width:NSLayoutConstraint = NSLayoutConstraint(item: alert.view ?? "hihi", attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 50)
        alert.view.addSubview(activities)
        alert.view.addConstraint(width)
        //Autolayout activities cho alert
        activities.translatesAutoresizingMaskIntoConstraints = false
        activities.widthAnchor.constraint(equalTo: alert.view.widthAnchor, multiplier: 1).isActive = true
        activities.heightAnchor.constraint(equalTo: alert.view.heightAnchor, multiplier: 1).isActive = true
        present(alert, animated: true, completion: nil)
        
        Auth.auth().createUser(withEmail: email, password: pass) { (data, err) in
            if err != nil {
                print(err?.localizedDescription ?? "hihi")
                return
            }
            //tạo 1 đường dẫn lưu avatar trên storage
            let avatar_folder = folder.child("avatar_image:/\(email).jpg")
            //up dữ liêu avatar lên
            let image_data = self.register_image.image?.pngData()
            _ = avatar_folder.putData(image_data!, metadata: nil, completion: { (medata, err) in
                if err != nil {
                    print(err?.localizedDescription ?? "hihi")
                    return
                }
                //dowload link url của avatar
                avatar_folder.downloadURL(completion: { (url, err) in
                    if err != nil {
                        print(err?.localizedDescription ?? "hihi")
                    }
                    //add dữ liệu cho user
                    let avatar_url = url?.absoluteString
                    let uid = Auth.auth().currentUser?.uid
                    let table_user = ref.child("user").child(uid!)
                    let user = ["name":name, "email": email, "pass": pass, "avatar_url": avatar_url, "id": uid]
                    table_user.setValue(user)
                    activities.stopAnimating()
                    self.dismiss(animated: true, completion: nil)
                    self.move_to_screen_by_navi(text: "message_controller")
                })

            }).resume()
        }
    }
        //Setup & Autolayout image Register
    func register_image_setup_autolayout(){
        register_image.image = UIImage(named: "register")
//        register_image.layer.cornerRadius = self.register_image.frame.size.width / 2
        register_image.layer.cornerRadius = 75
        register_image.clipsToBounds = true
        register_image.layer.borderColor = UIColor.darkGray.cgColor
        register_image.layer.borderWidth = 5
        register_image.contentMode = .scaleAspectFill
        register_image.translatesAutoresizingMaskIntoConstraints = false
        register_image.bottomAnchor.constraint(equalTo: view_register.topAnchor, constant: -20).isActive = true
        register_image.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        register_image.widthAnchor.constraint(equalToConstant: 150).isActive = true
        register_image.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    //Setup & Autolayout button Register
    func register_button_setup_autolayout(){
        register_button.backgroundColor = UIColor.init(red: 80, green: 101, blue: 161)
        register_button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        register_button.tintColor = UIColor.white
        register_button.alpha = 0.8
        register_button.layer.cornerRadius = 15
        register_button.clipsToBounds = true
        register_button.translatesAutoresizingMaskIntoConstraints = false
        register_button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        register_button.topAnchor.constraint(equalTo: view_register.bottomAnchor, constant: 8).isActive = true
//        register_button.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
//        register_button.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -16).isActive = true
        register_button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        register_button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //setup & autolayout txt password
    func txt_password_setup_autolayout(){
        txt_password.isSecureTextEntry = true
        txt_password.placeholder = "Enter Your Password..."
        txt_password.translatesAutoresizingMaskIntoConstraints = false
        txt_password.leftAnchor.constraint(equalTo: view_txt_password.leftAnchor, constant: 8).isActive = true
        txt_password.topAnchor.constraint(equalTo: view_txt_password.topAnchor, constant: 0).isActive = true
        txt_password.rightAnchor.constraint(equalTo: view_txt_password.rightAnchor, constant: 0).isActive = true
        txt_password.heightAnchor.constraint(equalTo: view_txt_password.heightAnchor, multiplier: 1).isActive = true
    }
    //setup & Autolayout view txt password
    func view_txt_pass_setup_autolayout(){
//        view_txt_password.layer.borderColor = UIColor.init(red: 61, green: 91, blue: 151).cgColor
        view_email.layer.borderColor = UIColor.darkGray.cgColor
        view_txt_password.layer.borderWidth = 0.5
        view_txt_password.translatesAutoresizingMaskIntoConstraints = false
        view_txt_password.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        view_txt_password.topAnchor.constraint(equalTo: view_email.bottomAnchor, constant: 0).isActive = true
        view_txt_password.widthAnchor.constraint(equalTo: view_email.widthAnchor, multiplier: 1).isActive = true
        view_txt_password.heightAnchor.constraint(equalTo: view_email.heightAnchor, multiplier: 1).isActive = true
    }
    //Autolayout view_register
    func view_register_autolayout(){
        view_register.translatesAutoresizingMaskIntoConstraints = false
        view_register.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        view_register.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        view_register.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        view_register.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    //setup & autolayout cho view_txt_name
    func view_txt_name_setup_autolayout(){
//        view_txt_name.backgroundColor = UIColor.darkGray
//        view_txt_name.layer.borderColor = UIColor.init(red: 61, green: 91, blue: 151).cgColor
        view_email.layer.borderColor = UIColor.darkGray.cgColor
        view_txt_name.layer.borderWidth = 0.5
        view_txt_name.translatesAutoresizingMaskIntoConstraints = false
        view_txt_name.leftAnchor.constraint(equalTo: view_register.leftAnchor).isActive = true
        view_txt_name.topAnchor.constraint(equalTo: view_register.topAnchor, constant: 0).isActive = true
        view_txt_name.widthAnchor.constraint(equalTo: view_register.widthAnchor).isActive = true
        view_txt_name.heightAnchor.constraint(equalTo: view_register.heightAnchor, multiplier: 1/3).isActive = true
    }
    
    //setup & autolayout cho txt_name
    func txt_name_setup_autolayout(){
        txt_name.keyboardType = .emailAddress
        txt_name.placeholder = "Enter Your Name..."
        txt_name.translatesAutoresizingMaskIntoConstraints = false
        txt_name.leftAnchor.constraint(equalTo: view_txt_name.leftAnchor, constant: 8).isActive = true
        txt_name.topAnchor.constraint(equalTo: view_txt_name.topAnchor, constant: 0).isActive = true
        txt_name.rightAnchor.constraint(equalTo: view_txt_name.rightAnchor, constant: 0).isActive = true
        txt_name.heightAnchor.constraint(equalTo: view_txt_name.heightAnchor, constant: 0).isActive = true
    }
    //setup & autolayout cho view_txtemail
    func view_txt_email_setup_autolayout(){
//        view_email.backgroundColor = UIColor.darkGray
//        view_email.layer.borderColor = UIColor.init(red: 61, green: 91, blue: 151).cgColor
        view_email.layer.borderColor = UIColor.darkGray.cgColor
        view_email.layer.borderWidth = 0.5
        view_email.translatesAutoresizingMaskIntoConstraints = false
        view_email.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        view_email.topAnchor.constraint(equalTo: view_txt_name.bottomAnchor, constant: 0).isActive = true
        view_email.widthAnchor.constraint(equalTo: view_txt_name.widthAnchor, multiplier: 1).isActive = true
        view_email.heightAnchor.constraint(equalTo: view_txt_name.heightAnchor, multiplier: 1).isActive = true
    }
    //setup & autolayout cho txtemail
    func txt_email_setup_autolayout(){
        txt_email.placeholder = "Enter Your Email...."
        txt_email.translatesAutoresizingMaskIntoConstraints = false
        txt_email.leftAnchor.constraint(equalTo: view_email.leftAnchor, constant: 8).isActive = true
        txt_email.rightAnchor.constraint(equalTo: view_email.rightAnchor, constant: 0).isActive = true
        txt_email.topAnchor.constraint(equalTo: view_email.topAnchor, constant: 0).isActive = true
        txt_email.heightAnchor.constraint(equalTo: view_email.heightAnchor, multiplier: 1).isActive = true
    }

}
extension Register: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosse_image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        register_image.image = chosse_image
        dismiss(animated: true, completion: nil)
    }
}
extension UIViewController {
    func move_to_screen_by_navi(text: String){
        let screen = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: text)
        navigationController?.pushViewController(screen, animated: true)
    }
}
