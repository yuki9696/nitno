//
//  Message.swift
//  FireChat-Swift
//
//  Created by Katherine Fang on 8/20/14.
//  Copyright (c) 2014 Firebase. All rights reserved.
//

import Foundation

struct Message {
    var text:String = "Hello this is long text comming from server\n self.textView.layoutIfNeeded()self.textView.layoutIfNeeded()self.textView.layoutIfNeeded()"
    var sender:String!
    var timeInterval:TimeInterval! = 0
    var url:URL! = URL(string: "www.google.co.in")!
    var id:Int = -1
    
    init(withId id:Int = 0,_ sender:String = "",_ timeInterval:TimeInterval = Date().timeIntervalSince1970) {
        self.id = id
        self.timeInterval = timeInterval
        self.sender = sender
    }
}

//class Message : {
//    /**
//     *  @return The date that the message was sent.
//     *  @warning You must not return `nil` from this method.
//     */
//   
//
//    var text_: String
//    var sender_: String
//    var date_: NSDate
//    var imageUrl_: String?
//    
//    convenience init(text: String?, sender: String?) {
//        self.init(text: text, sender: sender, imageUrl: nil)
//    }
//    
//    init(text: String?, sender: String?, imageUrl: String?) {
//        self.text_ = text!
//        self.sender_ = sender!
//        self.date_ = NSDate()
//        self.imageUrl_ = imageUrl
//    }
//    
//    func text() -> String! {
//        return text_;
//    }
//    
//    func sender() -> String! {
//        return sender_;
//    }
//    
//    func date() -> Date! {
//        return date_ as Date!;
//    }
//    
//    func imageUrl() -> String? {
//        return imageUrl_;
//    }
//}
