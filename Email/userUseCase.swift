//
//  userUseCase.swift
//  Email
//
//  Created by naveen-pt6301 on 14/02/23.
//

import Foundation

class userUseCase{
    
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
    
    func sendEmail(user:  User , email: Emails)->User?{
        
        Database.shared.sendMail(email: email)
        let fromAddressUser = sendEmailFromUser(emailId: email.fromAddress, email: email)
        sendEmailToUser(emailId: email.toAddress, email: email)
        
        let cc = email.cc
        if cc![0] == ""{
            print("no cc provided")
        }
        else{
            for emailID in cc! {
                sendEmailToUser(emailId: emailID, email: email)
            }
        }
        
        return fromAddressUser
    }
    
    func sendEmailFromUser(emailId:  String , email: Emails)->User?{
        var fromAddressUser = Database.shared.getUserDetails(emailId: emailId)
        for i in 0..<fromAddressUser!.listOfFolders.count{
            if fromAddressUser?.listOfFolders.isEmpty == true {
                print("no folders there in : \(String(describing: fromAddressUser?.EmailID))")
            }else{
                if fromAddressUser?.listOfFolders[i].name == "Sent"{
                    fromAddressUser?.listOfFolders[i].listOfMails.append(email)
                    fromAddressUser?.listOfFolders[i].unreadEmails += 1
                    fromAddressUser = Database.shared.updateUser(user: &fromAddressUser!)
                }
            }
        }
        return fromAddressUser ?? nil
    }
    
    func sendEmailToUser(emailId:  String , email: Emails) {
        var toAddressUser = Database.shared.getUserDetails(emailId: email.toAddress)
        
        for i in 0..<toAddressUser!.listOfFolders.count{
            if toAddressUser?.listOfFolders.isEmpty == true {
                print("no folders there in : \(String(describing: toAddressUser?.EmailID))")
            }else{
                if toAddressUser?.listOfFolders[i].name == "Inbox"{
                    toAddressUser?.listOfFolders[i].listOfMails.append(email)
                    toAddressUser?.listOfFolders[i].unreadEmails += 1
                    toAddressUser = Database.shared.updateUser(user: &toAddressUser!)
                }
            }
        }
    }
    
    func deleteMail(user:  User , mailNo: Int, folderName: String)->User?{
        var updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
        
        for i in 0..<updatedUser!.listOfFolders.count{
            if updatedUser!.listOfFolders[i].name == folderName{
                if updatedUser!.listOfFolders[i].listOfMails.isEmpty{
                    print("NO MAILS TO DELETE ")
                }else{
                    for j in 0..<updatedUser!.listOfFolders[i].listOfMails.count{
                        if mailNo - 1 == j {
                            if updatedUser!.listOfFolders[2].name == "Bin"{
                                updatedUser!.listOfFolders[2].listOfMails.append(updatedUser!.listOfFolders[i].listOfMails[mailNo-1])
                                updatedUser!.listOfFolders[2].unreadEmails += 1
                                updatedUser!.listOfFolders[i].listOfMails.remove(at: j)
                                updatedUser?.listOfFolders[i].unreadEmails -= 1
                                _ = Database.shared.updateUser(user: &updatedUser!)
                            }
                        }
                    }
                    
                }
            }
        }
        
        //        print("ututut",user.listOfFolders[0].listOfMails.count)
        return updatedUser
    }
    
}

extension userUseCase: AuthenticationContract {
   
    func registerUser(user:  User)->Bool{
        if Database.shared.registerUser(user: user){
            //         print("user registered succesfully")
            return true
        }else{
            return false
        }
    }
    
    func loginUser(emailId emailID: String , password: String) -> User?{
        let currentUser = Database.shared.loginUser(emailId: emailID, password: password)
        return currentUser ?? nil
    }
    
    func logoutUser()->Bool{
        return Database.shared.logoutUser()
    }
}

extension userUseCase: UserDisplayContract{
    
    func displayInboxMails(user: User , folderName: String){
        print("----------------------------------------")
        //        print("userEmailId in DisplaysenTmails: \(user.EmailID)")
        let user1 = Database.shared.getUserDetails(emailId: user.EmailID)
        
        for folder in user1!.listOfFolders{
            if folder.name == folderName {
                if folder.listOfMails.isEmpty {
                    print("NO MAILS TO DISPLAY")
                }else{
                    for (index,mail) in folder.listOfMails.enumerated(){
                        print("Sno: \(index+1) , fromAddress: \(mail.fromAddress) , subject: \(mail.subject ?? " "), body: \(mail.body ?? " ") ")
                        if let ccArray = mail.cc {
                            print("CC:  ",terminator: " ")
                            for cc in ccArray {
                                print(cc,terminator: " ")
                            }
                        }
                        print()
                    }
                }
            }
        }
        print(" -------------------------------------- ")
    }
    
    func displaySentMails(user: User , folderName: String){
        print("----------------------------------------")
        //        print("userEmailId in DisplaysenTmails: \(user.EmailID)")
        let user1 = Database.shared.getUserDetails(emailId: user.EmailID)
        
        for folder in user1!.listOfFolders{
            if folder.name == folderName {
                if folder.listOfMails.isEmpty {
                    print("NO MAILS TO DISPLAY")
                }else{
                    for (index,mail) in folder.listOfMails.enumerated(){
                        print("Sno: \(index+1) , to: \(mail.toAddress) , subject: \(mail.subject ?? " "), body: \(mail.body ?? " ") ")
                        if let ccArray = mail.cc {
                            print("CC:  ",terminator: " ")
                            for cc in ccArray {
                                print(cc,terminator: " ")
                            }
                        }
                        print()
                    }
                }
            }
        }
        print(" -------------------------------------- ")
    }
    
    func displayListOfFolders(user: User){
        //        print(" -------------------------------------- ")
        print(" ----------- LIST OF FOLDERS --------- ")
        let updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
        for (index,folders) in updatedUser!.listOfFolders.enumerated(){
            print("SNo: \(index+1)  | folderName: \(folders.name)  | UnreadMails:  \(folders.unreadEmails)  | TotalMails:   \(folders.listOfMails.count)")
        }
        print(" -------------------------------------- ")
    }
    
    func displaySelectedMail(user: User , folderName: String , mailNoToOpen: Int)-> (User?,Emails?){
        print(" -------------------------------------- ")
        print("displaying MailNo: \(mailNoToOpen)")
        var updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
        var CurrentEmail = Emails()
        for i in 0..<updatedUser!.listOfFolders.count{
            if updatedUser!.listOfFolders[i].name == folderName{
                if updatedUser!.listOfFolders[i].listOfMails.isEmpty {
                    print("useCase - displaySelectedMail - no mails to display ")
                    return (updatedUser,nil)
                }else{
                    for i in 0..<updatedUser!.listOfFolders[i].listOfMails.count{
                        if mailNoToOpen - 1 == i {
                            print(" fromAddress: ",updatedUser!.listOfFolders[i].listOfMails[i].fromAddress)
                            print(" toAddress: ",updatedUser!.listOfFolders[i].listOfMails[i].toAddress)
                            print(" subject: ",updatedUser!.listOfFolders[i].listOfMails[i].subject ?? " ")
                            print(" content: ",updatedUser!.listOfFolders[i].listOfMails[i].body ?? " ")
                            
                            CurrentEmail = updatedUser!.listOfFolders[i].listOfMails[i]
                            
                            if updatedUser!.listOfFolders[i].listOfMails[i].isRead == false && updatedUser!.listOfFolders[i].unreadEmails>0 {
                                updatedUser!.listOfFolders[i].unreadEmails -= 1
                            }
                            updatedUser!.listOfFolders[i].listOfMails[i].isRead = true
                            //                        print("isReadStatus: 11111", updatedUser!.listOfFolders[i].listOfMails[i].isRead)
                            let updatedUser1 = Database.shared.updateUser(user: &updatedUser!)
                            //                        print("update complete")
                            if let cc = updatedUser!.listOfFolders[i].listOfMails[i].cc {
                                print(" cc: ",terminator: " ")
                                for user in cc {
                                    print(user,terminator: " ")
                                }
                            }
                            updatedUser = updatedUser1
                            //                        print("isReadStatus: ",updatedUser?.listOfFolders[0].listOfMails[0].isRead,updatedUser?.listOfFolders[0].listOfMails[0].subject)
                            //                        print(updatedUser?.EmailID)
                        }
                    }
                }
                
            }
        }
        print()
        print(" -------------------------------------- ")
        //        print(updatedUser?.EmailID)
        return (updatedUser ?? nil , CurrentEmail )
    }
    
    
}

extension userUseCase: FolderContract{
    func addFolders(user:  User , folderName: String)->User?{
        var updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
        updatedUser!.listOfFolders.append(Folder(name: folderName))
        let updatedUser1 = Database.shared.updateUser(user: &updatedUser!)
        return updatedUser1!
    }
   
    func copyMailToAnotherFolder(user: User , email: Emails , folderName: String)->User?{
        
        var updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
        let result = validateFolder(user: user , folderName: folderName)
        
        if result {
            for i in 0..<updatedUser!.listOfFolders.count {
                if updatedUser!.listOfFolders[i].name == folderName {
                    updatedUser!.listOfFolders[i].listOfMails.append(email)
                    updatedUser = Database.shared.updateUser(user: &updatedUser!)
                }
            }
        }else{
            updatedUser = addFolders(user: user, folderName: folderName)
            for i in 0..<updatedUser!.listOfFolders.count {
                if updatedUser!.listOfFolders[i].name == folderName {
                    updatedUser!.listOfFolders[i].listOfMails.append(email)
                    updatedUser = Database.shared.updateUser(user: &updatedUser!)
                }
            }
        }
        
        return updatedUser ?? nil
    }
    
    func validateFolder(user: User , folderName: String)->Bool{
        var result: Bool = false
        let  updateUser = Database.shared.getUserDetails(emailId: user.EmailID)
        for folder in updateUser!.listOfFolders{
            if folder.name == folderName{
                result = true
            }
        }
        return result
    }
}






