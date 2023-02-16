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
    
    func sendEmail(user:  User , email: Emails)->User?{
        //        print(" -------------------------------------- ")
        //        print("userEmailId in sent mail: \(user.EmailID)")
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
                    fromAddressUser = Database.shared.updateUser(user: &fromAddressUser!)
                    
                    //                    print("s1 : \(user.EmailID)")
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
                    toAddressUser = Database.shared.updateUser(user: &toAddressUser!)
                    //                    print("s2: \(String(describing: currenttoAddressUser?.EmailID))")
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
                            toAddressUser = Database.shared.updateUser(user: &toAddressUser!)
                            //                            print("s3: ")
                        }
                    }
                }
            }
        }
        //        print("userEmailId in sent mail: \(user.EmailID)")
        //        print(" -------------------------------------- ")
        return fromAddressUser
    }
    
    func userLogout(){
        Database.shared.isUserLoggedIn = false
    }
    
    //    func displaySentMails(user: User ){
    //        print("----------------------------------------")
    ////        print("userEmailId in DisplaysenTmails: \(user.EmailID)")
    //        let user1 = Database.shared.getUserDetails(emailId: user.EmailID)
    //
    //        for folder in user1!.listOfFolders{
    //            if folder.name == "Sent" {
    //                if folder.listOfMails.isEmpty {
    //                    print("NO MAILS TO DISPLAY")
    //                }else{
    //                    for (index,mail) in folder.listOfMails.enumerated(){
    //                        print("Sno: \(index+1) , toAddress: \(mail.toAddress) , subject: \(mail.subject ?? " "), body: \(mail.body ?? " ") ")
    //                        if let ccArray = mail.cc {
    //                            print("CC:  ",terminator: " ")
    //                            for cc in ccArray {
    //                                print(cc,terminator: " ")
    //                            }
    //                        }
    //                        print()
    //                    }
    //                }
    //            }
    //        }
    //        print(" -------------------------------------- ")
    //    }
    //
    //    func displayInboxMails(user: User){
    ////        let updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
    ////        print(" -------------------------------------- ")
    ////        print("userEmailID in displayInbox: \(user.EmailID)")
    //        for folder in user.listOfFolders{
    //            if folder.name == "Inbox" {
    //                if folder.listOfMails.isEmpty {
    //                    print("NO MAILS TO DISPLAY")
    //                }else{
    //                    for (index,mail) in folder.listOfMails.enumerated(){
    //                        print("Sno: \(index+1) , fromAddress: \(mail.fromAddress) , subject: \(mail.subject ?? " ") ")
    //                        if let ccArray = mail.cc {
    //                            print(" CC  : ",terminator: " ")
    //                            for cc in ccArray {
    //                                print(cc,terminator: "  ")
    //                            }
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //        print()
    //        print(" -------------------------------------- ")
    //    }
    
    func displayMails(user: User , folderName: String){
        print("----------------------------------------")
        //        print("userEmailId in DisplaysenTmails: \(user.EmailID)")
        let user1 = Database.shared.getUserDetails(emailId: user.EmailID)
        
        for folder in user1!.listOfFolders{
            if folder.name == folderName {
                if folder.listOfMails.isEmpty {
                    print("NO MAILS TO DISPLAY")
                }else{
                    for (index,mail) in folder.listOfMails.enumerated(){
                        print("Sno: \(index+1) , toAddress: \(mail.toAddress) , subject: \(mail.subject ?? " "), body: \(mail.body ?? " ") ")
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
    
    //    func deleteInboxMails(user:  User , mailNo: Int)->User?{
    //        var updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
    //
    //        for i in 0..<updatedUser!.listOfFolders.count{
    //            if updatedUser!.listOfFolders[i].name == "Inbox"{
    //                for j in 0..<updatedUser!.listOfFolders[i].listOfMails.count{
    //                    if mailNo - 1 == j {
    //                        if updatedUser!.listOfFolders[2].name == "Bin"{
    //                            updatedUser!.listOfFolders[2].listOfMails.append(updatedUser!.listOfFolders[i].listOfMails[mailNo-1])
    //                            updatedUser!.listOfFolders[2].unreadEmails += 1
    //                                    updatedUser!.listOfFolders[i].listOfMails.remove(at: j)
    //                                    updatedUser?.listOfFolders[i].unreadEmails -= 1
    //                                    _ = Database.shared.updateUser(user: &updatedUser!)
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //
    ////        print("ututut",user.listOfFolders[0].listOfMails.count)
    //        return updatedUser
    //    }
    //
    //    func deleteSentMails(user:  User , mailNo: Int)->User?{
    //        var updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
    //
    //        for i in 0..<updatedUser!.listOfFolders.count{
    //            if updatedUser!.listOfFolders[i].name == "Sent"{
    //                for j in 0..<updatedUser!.listOfFolders[i].listOfMails.count{
    //                    if mailNo - 1 == j {
    //                        if updatedUser!.listOfFolders[2].name == "Bin"{
    //                            updatedUser!.listOfFolders[2].listOfMails.append(updatedUser!.listOfFolders[i].listOfMails[mailNo-1])
    //                            updatedUser!.listOfFolders[2].unreadEmails += 1
    //                                    updatedUser!.listOfFolders[i].listOfMails.remove(at: j)
    //                                    updatedUser?.listOfFolders[i].unreadEmails -= 1
    //                                    _ = Database.shared.updateUser(user: &updatedUser!)
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //
    ////        print("ututut",user.listOfFolders[0].listOfMails.count)
    //        return updatedUser
    //    }
    //
    
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
    
    func addFolders(user:  User , folderName: String)->User?{
        var updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
        updatedUser!.listOfFolders.append(Folder(name: folderName))
        let updatedUser1 = Database.shared.updateUser(user: &updatedUser!)
        return updatedUser1!
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
    
    func displaySelectedMail(user: User , folderName: String , mailNoToOpen: Int)-> User?{
        print(" -------------------------------------- ")
        print("displaying MailNo: \(mailNoToOpen)")
        var updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
        
        for i in 0..<updatedUser!.listOfFolders.count{
            if updatedUser!.listOfFolders[i].name == folderName{
                if updatedUser!.listOfFolders[i].listOfMails.isEmpty {
                    print("useCase - displaySelectedMail - no mails to display ")
                    return updatedUser
                }else{
                    for i in 0..<updatedUser!.listOfFolders[i].listOfMails.count{
                        if mailNoToOpen - 1 == i {
                            print(" fromAddress: ",updatedUser!.listOfFolders[i].listOfMails[i].fromAddress)
                            print(" toAddress: ",updatedUser!.listOfFolders[i].listOfMails[i].toAddress)
                            print(" subject: ",updatedUser!.listOfFolders[i].listOfMails[i].subject ?? " ")
                            print(" content: ",updatedUser!.listOfFolders[i].listOfMails[i].body ?? " ")
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
        return updatedUser ?? nil
    }
    
    
}
