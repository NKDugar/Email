//
//  userUseCase.swift
//  Email
//
//  Created by naveen-pt6301 on 14/02/23.
//

import Foundation

class userUseCase{
    
    func registerUser(user: User)->Bool{
        if Database.shared.registerUser(user: user){
            //            print("user registered succesfully")
            return true
        }else{
            return false
        }
    }
    
    func loginUser(emailID: String , password: String) -> User?{
        var currentUser = Database.shared.loginUser(emailId: emailID, password: password)
        return currentUser ?? nil
    }
    
    func composeMail(email: Emails)-> Emails? {
        
        if Database.shared.validateUser(toAddress: email.toAddress){
            if Database.shared.validateCC(emailCC: email.cc ){
                print("userUseCase - email was successfully composed ")
                return email
            }else{
                print("userUseCase - failed to authnticate emailCC")
                return nil
            }
        }else{
            print("userUseCase - failed to authenticate toAddress")
            return nil
        }
    }
    
    
    func sendEmail(user: inout User , email: Emails)->User?{

        Database.shared.sendMail(email: email)
        
        
        
        
        return user
    }
    
    func addFolders(user: inout User)-> User?{
        user.listOfFolders.append(Folder(name: "inbox"))
        user.listOfFolders.append(Folder(name: "sent"))
        var currentUser = Database.shared.updateUser(user: &user)
        print("user use case add folder - completed updating")
        return currentUser
    }

    
    func getUserDetails(emailId: String){
        print("user use case - getting user details")
        var user = Database.shared.getUserDetails(emailId: emailId)
        for (indez,folder) in user!.listOfFolders.enumerated(){
            print(indez+1, folder.name , "folders")
            for (index,mails) in folder.listOfMails.enumerated(){
                print(index+1 , mails.toAddress , mails.subject)
                
            }
        }
    }
    
//    func displaySendMails(user: inout User){
//        let data = Database.shared.getAllMails()
//        print("userEmailID: \(user.EmailID)")
//
//        for (index,mails) in  data.enumerated(){
//            if mails.toAddress == user.EmailID{
//                print("mails: ",mails.fromAddress , mails.subject ,mails.subject)
//            }
//        }
//    }
    
}
