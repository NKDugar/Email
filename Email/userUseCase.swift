//
//  userUseCase.swift
//  Email
//
//  Created by naveen-pt6301 on 14/02/23.
//

import Foundation

class userUseCase{
    
    func registerUser(user:  User)->Bool{
        if Database.shared.registerUser(user: user){
//         print("user registered succesfully")
            return true
        }else{
            return false
        }
    }
    
    func loginUser(emailID: String , password: String) -> User?{
        let currentUser = Database.shared.loginUser(emailId: emailID, password: password)
        return currentUser ?? nil
    }
    
    func composeMail(email: Emails)-> Emails? {
        if Database.shared.validateUser(toAddress: email.toAddress){
            if Database.shared.validateCC(email: email ){
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
        var fromAddressUser = Database.shared.getUserDetails(emailId: email.fromAddress)
        var toAddressUser = Database.shared.getUserDetails(emailId: email.toAddress)
        
        for i in 0..<fromAddressUser!.listOfFolders.count{
            if fromAddressUser?.listOfFolders.isEmpty == true {
                print("no folders there in : \(String(describing: fromAddressUser?.EmailID))")
            }else{
                if fromAddressUser?.listOfFolders[i].name == "Sent"{
                    fromAddressUser?.listOfFolders[i].listOfMails.append(email)
                    fromAddressUser?.listOfFolders[i].unreadEmails += 1
                    let currentFromAddressUser = Database.shared.updateUser(user: &fromAddressUser!)
                    user = currentFromAddressUser!
                    print("s1 : \(user.EmailID)")
                }
            }
        }
        
        for i in 0..<toAddressUser!.listOfFolders.count{
            if toAddressUser?.listOfFolders.isEmpty == true {
                print("no folders there in : \(String(describing: toAddressUser?.EmailID))")
            }else{
                if toAddressUser?.listOfFolders[i].name == "Inbox"{
                    toAddressUser?.listOfFolders[i].listOfMails.append(email)
                    toAddressUser?.listOfFolders[i].unreadEmails += 1
                    let currenttoAddressUser = Database.shared.updateUser(user: &toAddressUser!)
                    print("s2: \(String(describing: currenttoAddressUser?.EmailID))")
                }
            }
        }

        let cc = email.cc

        if cc![0] == ""{
            print("no cc provided")
        }
        else{
            for emailID in cc! {
                 var toAddressUser = Database.shared.getUserDetails(emailId: emailID)
                for i in 0..<toAddressUser!.listOfFolders.count{
                    if toAddressUser?.listOfFolders.isEmpty == true {
                        print("no folders there in : \(String(describing: toAddressUser?.EmailID ?? nil))")
                    }else{
                        if toAddressUser?.listOfFolders[i].name == "Inbox"{
                            toAddressUser?.listOfFolders[i].listOfMails.append(email)
                            toAddressUser?.listOfFolders[i].unreadEmails += 1
                            _ = Database.shared.updateUser(user: &toAddressUser!)
                            print("s3: ")
                        }
                    }
                }
            }
        }
        return user
    }
    
    func userLogout(){
        Database.shared.isUserLoggedIn = false
    }
    
    func displaySentMails(user: User){
//        let user = Database.shared.getUserDetails(emailId: user.EmailID)
        for folder in user.listOfFolders{
            if folder.name == "Sent" {
                for (index,mail) in folder.listOfMails.enumerated(){
                    print("Sno: \(index+1) , toAddress: \(mail.toAddress) , subject: \(String(describing: mail.subject)) ")
                    if let ccArray = mail.cc {
                        for cc in ccArray {
                            print("cc: ",cc)
                        }
                    }
                }
            }
        }
    }
    
    func displayInboxMails(user: User){
//        let updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
        print("userEmailID in displayInbox: \(user.EmailID)")
        for folder in user.listOfFolders{
            if folder.name == "Inbox" {
                for (index,mail) in folder.listOfMails.enumerated(){
                    print("Sno: \(index+1) , fromAddress: \(mail.fromAddress) , subject: \(String(describing: mail.subject)) ")
                    if let ccArray = mail.cc {
                        for cc in ccArray {
                            print(cc)
                        }
                    }
                }
            }
        }
    }
    
    func addFolders(user: inout User , folderName: String)->User?{
        user.listOfFolders.append(Folder(name: folderName))
        let updatedUser = Database.shared.updateUser(user: &user)
        return updatedUser
    }
    
    func displayListOfFolders(user: User){
       
        for (index,folders) in user.listOfFolders.enumerated(){
            print(index+1 , folders.name ,folders.unreadEmails)
        }
    }
    
    func deleteInboxMails(user: inout User , mailNo: Int)->User?{
//        var updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
        
        for i in 0..<user.listOfFolders.count{
            if user.listOfFolders[i].name == "Inbox"{
                for j in 0..<user.listOfFolders[i].listOfMails.count{
                    if mailNo - 1 == j {
                        user.listOfFolders[i].listOfMails.remove(at: j)
                    }
                }
            }
        }
        print("ututut",user.listOfFolders[0].listOfMails.count)
        return user
    }
    
    func deleteSentMails(user: inout User , mailNo: Int)->User?{
//        var updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
        
        for i in 0..<user.listOfFolders.count{
            if user.listOfFolders[i].name == "Sent"{
                for j in 0..<user.listOfFolders[i].listOfMails.count{
                    print(mailNo-1 , "     ---   " , j)
                    if mailNo - 1 == j {
                        user.listOfFolders[i].listOfMails.remove(at: j)
                        var updated = Database.shared.updateUser(user: &user)
                        print(updated?.EmailID , "    ",user.EmailID)
                        user = updated!
                    }
                }
            }
        }
        print("utututtyftyfytftyfty",user.listOfFolders[1].listOfMails.count)
        return user
    }
    
}
