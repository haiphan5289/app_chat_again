//
//  cell_chat_message.swift
//  AppChat_Again
//
//  Created by HaiPhan on 6/12/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import UIKit

class cell_chat_message: UICollectionViewCell {
    //set up bubble
    var chat_collect_delegate: chat_collect!
    let buble_view: UIView = {
        let buble = UIView()
        buble.backgroundColor = UIColor.init(red: 61, green: 91, blue: 151)
        buble.layer.cornerRadius = 10
        buble.clipsToBounds = true
        buble.layer.borderColor = UIColor.darkGray.cgColor
        buble.layer.borderWidth = 2
        return buble
    }()
    let text_label: UITextView = {
        let t = UITextView()
//        t.text = "Aa"
        t.font = UIFont.boldSystemFont(ofSize: 16)
        t.textColor = UIColor.white
        t.backgroundColor = UIColor.clear
        return t
    }()
    
    //setup image_profile_partner
    let image_profile_partner: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "loading")
        img.layer.cornerRadius = 20
        img.clipsToBounds = true
        img.layer.borderColor = UIColor.darkGray.cgColor
        img.layer.borderWidth = 2
        return img
    }()
    
    //setup image chat
    //đổi biển let sang lazy var để có thể sử dụng addGestureRecognizer
    lazy var image_chat: UIImageView = {
        let img = UIImageView()
        //        img.image = UIImage(named: "loading")
        img.layer.cornerRadius = 15
        img.layer.borderColor = UIColor.darkGray.cgColor
        img.layer.borderWidth = 5
        img.clipsToBounds = true
        img.contentMode = UIImageView.ContentMode.scaleAspectFill
        img.isUserInteractionEnabled = true
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chat_zoom)))
        return img
    }()
    
    //setup scale or zoom image
    @objc func chat_zoom(tap: UITapGestureRecognizer){
        if let image_view = tap.view as? UIImageView {
            self.chat_collect_delegate?.image_chat_zoom(starting_image_view: image_view)
        }
    }
    
    
    var width_buble: NSLayoutConstraint?
    var left_buble: NSLayoutConstraint?
    var right_buble: NSLayoutConstraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(buble_view)
        addSubview(image_profile_partner)
        addSubview(text_label)
        buble_view.addSubview(image_chat)
        
        //add contrainst buble view
        buble_view.translatesAutoresizingMaskIntoConstraints = false
        left_buble = buble_view.leftAnchor.constraint(equalTo: image_profile_partner.rightAnchor, constant: 8)
        //        left_buble!.isActive = true
        right_buble = buble_view.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        right_buble!.isActive = false
        
        //        buble_view.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        width_buble = buble_view.widthAnchor.constraint(equalToConstant: 200)
        width_buble!.isActive = true
        buble_view.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        //add contrainst text
        text_label.translatesAutoresizingMaskIntoConstraints = false
        //        text_label.leftAnchor.constraint(equalTo: buble_view.leftAnchor, constant: 0).isActive = true
        //        text_label.rightAnchor.constraint(equalTo: buble_view.rightAnchor, constant: 0).isActive = true
        text_label.centerYAnchor.constraint(equalTo: buble_view.centerYAnchor, constant: 0).isActive = true
        text_label.centerXAnchor.constraint(equalTo: buble_view.centerXAnchor, constant: 0).isActive = true
        text_label.widthAnchor.constraint(equalTo: buble_view.widthAnchor, constant: 0).isActive = true
        text_label.heightAnchor.constraint(equalTo: buble_view.heightAnchor, constant: 0).isActive = true
        //        text_label.bottomAnchor.constraint(equalTo: buble_view.bottomAnchor, constant: 0).isActive = true
        //        text_label.topAnchor.constraint(equalTo: buble_view.topAnchor, constant: 0).isActive = true
        
        //add constraint image profile
        image_profile_partner.translatesAutoresizingMaskIntoConstraints = false
        image_profile_partner.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        //        image_profile_partner.rightAnchor.constraint(equalTo: buble_view.leftAnchor, constant: -8).isActive = true
        //        image_profile_partner.bottomAnchor.constraint(equalTo: buble_view.bottomAnchor, constant: 0).isActive = true
        image_profile_partner.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        image_profile_partner.widthAnchor.constraint(equalToConstant: 40).isActive = true
        image_profile_partner.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //add constraint image chat
        image_chat.translatesAutoresizingMaskIntoConstraints = false
        //        image_chat.leftAnchor.constraint(equalTo: buble_view.leftAnchor, constant: 0).isActive = true
        image_chat.centerXAnchor.constraint(equalTo: buble_view.centerXAnchor, constant: 0).isActive = true
        image_chat.centerYAnchor.constraint(equalTo: buble_view.centerYAnchor, constant: 0).isActive = true
        image_chat.widthAnchor.constraint(equalTo: buble_view.widthAnchor, constant: 0).isActive = true
        image_chat.heightAnchor.constraint(equalTo: buble_view.heightAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
