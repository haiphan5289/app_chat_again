//
//  login.swift
//  AppChat_Again
//
//  Created by HaiPhan on 6/11/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit
import Firebase

class login: UIViewController {
    
    @IBOutlet weak var view_login: UIView!
    @IBOutlet weak var view_txt_email: UIView!
    @IBOutlet weak var txt_email: UITextField!
    @IBOutlet weak var view_txt_pass: UIView!
    @IBOutlet weak var txt_pass: UITextField!
    @IBOutlet weak var image_login: UIImageView!
    @IBOutlet weak var login_bt: UIButton!
    @IBOutlet weak var register_bt: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(red: 61, green: 91, blue: 151)
        implement_code()
    }
    func implement_code(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        view_login_setup_autolayout()
        view_txt_email_setup_autolayout()
        txt_email_setup_autolayout()
        view_txt_pass_setup_autolayout()
        txt_pass_setup_autolayout()
        image_login_setup_autolayout()
        login_button_setup_autolayout()
        register_button_setup_autolayout()
        is_logined()
    }
    
    
    @IBAction func logim(_ sender: UIButton) {
        guard let email = txt_email.text, let pass = txt_pass.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: pass) { (data, err) in
            if err != nil {
                print(err?.localizedDescription ?? "hihi")
                return
            }
//            self.move_to_screen_by_navi(text: "message_controller")
        }
    }
    
    //setup & Autolayout register_button
    func register_button_setup_autolayout(){
        register_bt.backgroundColor = UIColor.init(red: 80, green: 101, blue: 161)
        register_bt.alpha = 0.8
        register_bt.tintColor = UIColor.white
        register_bt.layer.cornerRadius = 15
        register_bt.clipsToBounds = true
        register_bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        register_bt.translatesAutoresizingMaskIntoConstraints = false
        
        register_bt.topAnchor.constraint(equalTo: login_bt.bottomAnchor, constant: 8).isActive = true
        register_bt.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        register_bt.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        register_bt.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    @IBAction func move_to_register(_ sender: UIButton) {
        self.move_to_screen_by_navi(text: "register")
    }
    
    //setup & Autolayout login_button
    func login_button_setup_autolayout(){
        login_bt.backgroundColor = UIColor.init(red: 80, green: 101, blue: 161)
        login_bt.alpha = 0.8
        login_bt.tintColor = UIColor.white
        login_bt.layer.cornerRadius = 15
        login_bt.clipsToBounds = true
        login_bt.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        login_bt.translatesAutoresizingMaskIntoConstraints = false
        login_bt.topAnchor.constraint(equalTo: view_login.bottomAnchor, constant: 8).isActive = true
        login_bt.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
        login_bt.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -8).isActive = true
        login_bt.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    //sẽ move to màn hình message_controller nếu đã login rồi
    //Nếu hàm login cũng co move thì sẽ hiển thị move 2 lần
    func is_logined(){
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                self.move_to_screen_by_navi(text: "message_controller")
            }
            
        }
    }
    
    //Setup & Autolayout image_login
    func image_login_setup_autolayout(){
        image_login.image = UIImage(named: "login")
        image_login.layer.cornerRadius = 75
        image_login.clipsToBounds = true
        image_login.layer.borderColor = UIColor.darkGray.cgColor
        image_login.layer.borderWidth = 5
        image_login.contentMode = .scaleAspectFill
        
        image_login.translatesAutoresizingMaskIntoConstraints = false
        image_login.bottomAnchor.constraint(equalTo: view_login.topAnchor, constant: -20).isActive = true
        image_login.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        image_login.widthAnchor.constraint(equalToConstant: 150).isActive = true
        image_login.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    //setup & Autolayout txt_pass
    func txt_pass_setup_autolayout(){
        txt_pass.isSecureTextEntry = true
        txt_pass.placeholder = "Enter Your Password..."
        txt_pass.translatesAutoresizingMaskIntoConstraints = false
        txt_pass.leftAnchor.constraint(equalTo: view_txt_pass.leftAnchor, constant: 8).isActive = true
        txt_pass.topAnchor.constraint(equalTo: view_txt_pass.topAnchor, constant: 0).isActive = true
        txt_pass.rightAnchor.constraint(equalTo: view_txt_pass.rightAnchor, constant: 0).isActive = true
        txt_pass.heightAnchor.constraint(equalTo: txt_email.heightAnchor, multiplier: 1).isActive = true
    }
    
    //setup & Autolayout view_txt_pass
    func view_txt_pass_setup_autolayout(){
        view_txt_pass.layer.borderColor = UIColor.darkGray.cgColor
        view_txt_pass.layer.borderWidth = 0.5
        //        view_txt_pass.backgroundColor = UIColor.brown
        view_txt_pass.translatesAutoresizingMaskIntoConstraints = false
        view_txt_pass.leftAnchor.constraint(equalTo: view_login.leftAnchor, constant: 0).isActive = true
        view_txt_pass.topAnchor.constraint(equalTo: view_txt_email.bottomAnchor, constant: 0).isActive = true
        view_txt_pass.widthAnchor.constraint(equalTo: view_txt_email.widthAnchor, multiplier: 1).isActive = true
        view_txt_pass.heightAnchor.constraint(equalTo: view_txt_email.heightAnchor, multiplier: 1).isActive = true
    }
    
    //setup & Autolayout txt_email
    func txt_email_setup_autolayout(){
        txt_email.placeholder = "Enter Your Email..."
        txt_email.translatesAutoresizingMaskIntoConstraints = false
        txt_email.topAnchor.constraint(equalTo: view_txt_email.topAnchor, constant: 0).isActive = true
        txt_email.leftAnchor.constraint(equalTo: view_txt_email.leftAnchor, constant: 8).isActive = true
        txt_email.rightAnchor.constraint(equalTo: view_txt_email.rightAnchor, constant: 0).isActive = true
        txt_email.bottomAnchor.constraint(equalTo: view_txt_email.bottomAnchor, constant: 0).isActive = true
    }
    
    //setup & Autolayout view txt email
    func view_txt_email_setup_autolayout(){
        //        view_txt_email.backgroundColor = UIColor.brown
        view_txt_email.layer.borderColor = UIColor.darkGray.cgColor
        view_txt_email.layer.borderWidth = 0.5
        view_txt_email.translatesAutoresizingMaskIntoConstraints = false
        view_txt_email.leftAnchor.constraint(equalTo: view_login.leftAnchor, constant: 0).isActive = true
        view_txt_email.topAnchor.constraint(equalTo: view_login.topAnchor, constant: 0).isActive = true
        view_txt_email.widthAnchor.constraint(equalTo: view_login.widthAnchor, constant: 0).isActive = true
        view_txt_email.heightAnchor.constraint(equalTo: view_login.heightAnchor, multiplier: 1/2).isActive = true
    }
    
    //setup & Autolayout View Login
    func view_login_setup_autolayout(){
        view_login.translatesAutoresizingMaskIntoConstraints = false
        view_login.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0).isActive = true
        view_login.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 0).isActive = true
        view_login.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        view_login.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    
}
