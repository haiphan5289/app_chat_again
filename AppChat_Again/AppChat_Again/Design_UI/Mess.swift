//
//  Mess.swift
//  AppChat_Again
//
//  Created by HaiPhan on 6/12/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import Foundation
import Firebase

class Mess {
    var fromid: String?
    var mess: String?
    var timestamp: NSNumber?
    var toid: String?
    var image_url: String?
    var width_image: NSNumber?
    var height_image: NSNumber?
    init() {
        self.fromid = ""
        self.mess = ""
        self.timestamp = 0
        self.toid = ""
        self.image_url = ""
        self.width_image = 0
        self.height_image = 0
    }
    init(fromid: String, mess: String, timestamp: NSNumber, toid: String, image_url: String, width_image: NSNumber, height_image: NSNumber) {
        self.fromid = fromid
        self.mess = mess
        self.timestamp = timestamp
        self.toid = toid
        self.image_url = image_url
        self.width_image = width_image
        self.height_image = height_image
    }
    func get_partner_id() -> String{
//        let partner_id: String?
        if Auth.auth().currentUser?.uid == fromid {
            return toid!
        }
        else {
            return fromid!
        }
    }
}
