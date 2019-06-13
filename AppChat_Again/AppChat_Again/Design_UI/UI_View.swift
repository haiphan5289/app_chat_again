//
//  UI_View.swift
//  AppChat_Again
//
//  Created by HaiPhan on 6/10/19.
//  Copyright © 2019 HaiPhan. All rights reserved.
//

import Foundation
import UIKit

var iamge_cache = NSCache<AnyObject, AnyObject>()

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat){
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
//Hàm hiển thị loading cho hình
extension UIImageView {
    func load_image(text: String, position_x: CGFloat, position_y: CGFloat){
        if let image_object = iamge_cache.object(forKey: text as NSObject){
            self.image = image_object as? UIImage
            return
        }
        let activities: UIActivityIndicatorView = UIActivityIndicatorView(style: .white)
        activities.color = .brown
        activities.frame = CGRect(x: 0, y: 0, width: position_x, height: position_y)
        activities.startAnimating()
        addSubview(activities)
        //phải có async, thi image nó mới hiển thị, nếu không thì nó sẽ load xong mới hiển
        let queue = DispatchQueue(label: "queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        queue.async {
            let str = text
            let url = URL(string: str)
            let data = try? Data(contentsOf: url!)
            let image_data = UIImage(named: "loading")?.pngData()
            if let image_dowload = UIImage(data: data ?? image_data!){
                iamge_cache.setObject(image_dowload, forKey: text as AnyObject)
                activities.stopAnimating()
                self.image = UIImage(data: data!)
            }
        }
    }
}
extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
