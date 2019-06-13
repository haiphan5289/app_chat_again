//
//  User.swift
//  AppChat_Again
//
//  Created by HaiPhan on 6/11/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import Foundation
import UIKit

class User {
    var id: String!
    var name: String!
    var email: String!
    var pass: String!
    var avatar_url: String?
    init() {
        self.avatar_url = ""
        self.email = ""
        self.pass = ""
        self.name = ""
        self.id = ""
    }
    init(name: String, pass: String, email: String, avatar_url: String, id: String) {
        self.avatar_url = avatar_url
        self.email = email
        self.pass = pass
        self.name = name
        self.id = id
    }
}
