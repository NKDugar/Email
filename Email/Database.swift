//
//  Database.swift
//  Email
//
//  Created by naveen-pt6301 on 14/02/23.
//

import Foundation

class Database{
    
    static let shared  = Database()
    private init(){}
    
    private var emailAndUser: [String:User] = [ : ]
    private var AllEmails: [Emails] = [ ]
    var isUserLoggedIn: Bool = false
    
    func registerUser(user: inout User)->Bool{
        if emailAndUser[user.EmailID] == nil {
            user.listOfFolders.append(Folder(name: "Inbox"))
            user.listOfFolders.append(Folder(name: "Sent"))
            emailAndUser[user.EmailID] = user
            return true
        }else{
            return false
        }
    }
    
    func loginUser(emailId: String , password: String)->User? {
        
        if isUserLoggedIn == false{
            if password == emailAndUser[emailId]?.password  {
                print("user logged in succesfully")
                isUserLoggedIn = true
                return emailAndUser[emailId]
            }else{
                return nil
            }
        }else{
            print("logout current user to login ")
            return nil
        }
    }
    
    
    func validateUser(toAddress: String) -> Bool{
        if emailAndUser[toAddress] != nil{
            return true
        }else{
            return false
        }
    }
    
    
//    func validateCC(emailCC: [String]?) -> Bool {
//        var result: Bool = true
//
//        guard let cc = emailCC else{
//            print("no cc provided")
//            result = true
//            return true
//        }
//        if emailCC?.isEmpty == nil {
//            print("no cc")
//            result = true
//            return true
//        }else{
//            for emailId in emailCC!{
//                if emailId == ""{
//                    print("c1")
//                    result = true
//                    return true
//                }
//                if emailAndUser[emailId] == nil {
//                    print("no such user found: \(emailId)")
//                    result = false
//                    return false
//                }
//            }
//        }
//        print(result)
//        return result
//    }
    
    func validateCC(email: Emails) -> Bool {
        guard let cc = email.cc else {
            print("Authentication - All mails are empty.")
            return true
        }
        
        for mailID in cc {
            if mailID == "" {
                print("Authentication - no cc provided")
                return true
            }
            
            guard let _ = emailAndUser[mailID] else {
                print("Authentication - User is not registered with mail ID: \(mailID)")
                return false
            }
            
            if mailID == email.toAddress || mailID == email.fromAddress {
                print("Authentication - CC cannot have the same email ID as the fromAddress or toAddress: \(mailID)")
                return false
            }
        }
        
        return true
    }

    func sendMail(email: Emails){
        AllEmails.append(email)
        print("database - adding ail to allmails: ")
    }
    
    func updateUser(user: inout User)->User?{
        emailAndUser[user.EmailID] = user
        print("database - updating")
        return emailAndUser[user.EmailID]
    }
    
    func getUserDetails(emailId: String)->User?{
        print("getting user details : ")
        return emailAndUser[emailId]
    }
    
    func getAllMails()->[Emails]{
        return self.AllEmails
    }
}
