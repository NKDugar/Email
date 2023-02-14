//
//  Emails.swift
//  Email
//
//  Created by naveen-pt6301 on 14/02/23.
//

import Foundation

struct Emails{
    
    var toAddress: String
    var fromAddress: String
    var subject: String?
    var body: String?
    var cc: [String]?
    var isRead: Bool?
    var isFavourite: Bool?
    
    init(toAddress: String, fromAddress: String, subject: String? = nil, body: String? = nil, cc: [String]? = nil, isRead: Bool? , isFavourite: Bool? ) {
        self.toAddress = toAddress
        self.fromAddress = fromAddress
        self.subject = subject
        self.body = body
        self.cc = cc
        self.isRead = isRead
        self.isFavourite = isFavourite
    }
    
}
