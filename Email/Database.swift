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
    
    private var emailAndPassword: [String : String] = [ : ]
    private var emailAndUser: [String:User] = [ : ]
     private var AllEmails: [Emails] = [ ]
    
    func registerUser(user: User)->Bool{
        if emailAndPassword[user.EmailID] == nil {
            emailAndPassword[user.EmailID] = user.password
            emailAndUser[user.EmailID] = user
            return true
        }else{
            return false
        }
    }
    
    func loginUser(emailId: String , password: String)->User? {
        if emailAndPassword[emailId] == password{
            print("user logged in succesfully")
            return emailAndUser[emailId]
        }else{
            return nil
        }
    }
    
    
    func validateUser(toAddress: String) -> Bool{
        if emailAndPassword[toAddress] != nil{
            return true
        }else{
            return false
        }
    }
    
    
    func validateCC(emailCC: [String]?) -> Bool {
        var result: Bool = true
        
        guard let cc = emailCC else{
            print("no cc provided")
            result = true
            return true
        }
        if emailCC?.isEmpty == nil {
            print("no cc")
            result = true
            return true
        }else{
            for emailId in emailCC!{
                if emailId == ""{
                    print("c1")
                    result = true
                    return true
                }
                if emailAndPassword[emailId] == nil {
                    print("no such user found: \(emailId)")
                    result = false
                    return false
                }
            }
        }
        print(result)
        return result
    }
    
    
  
    func sendMail(email: Emails){
        AllEmails.append(email)
        print("database - adding ail to allmails: ")
    }
    
    func updateUserAfterSent(user: inout User)->User?{
        
        
        return nil
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
