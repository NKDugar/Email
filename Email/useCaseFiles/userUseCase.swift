//
//  userUseCase.swift
//  Email
//
//  Created by naveen-pt6301 on 14/02/23.
//

import Foundation

class userUseCase: MailContract{
   
    
    func composeMail(email: Emails)-> Emails? {
        
        if Database.shared.validateUser(toAddress: email.toAddress) {
            if Database.shared.validateCC(email: email) {
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
    
    func sendEmail(email: Emails)->User?{
        
        Database.shared.sendMail(email: email)
        
        var fromAddressUser = sendEmailFromUser(emailId: email.fromAddress, email: email)
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
    
    private func sendEmailFromUser(emailId:  String , email: Emails)->User?{
        var fromAddressUser = Database.shared.getUserDetails(emailId: emailId)
        for i in 0..<fromAddressUser!.listOfFolders.count{
            if fromAddressUser?.listOfFolders.isEmpty == true {
                print("no folders there in : \(String(describing: fromAddressUser?.EmailID))")
            }else{
                if fromAddressUser?.listOfFolders[i].name == "Sent"{
                    fromAddressUser?.listOfFolders[i].listOfMails.append(email)
                    fromAddressUser?.listOfFolders[i].unreadEmailsCount += 1
                    fromAddressUser = Database.shared.updateUser(user: fromAddressUser!)
                }
            }
        }
        return fromAddressUser
    }
    
    private func sendEmailToUser(emailId:  String , email: Emails) {
        
        var toAddressUser = Database.shared.getUserDetails(emailId: emailId)
        
        for i in 0..<toAddressUser!.listOfFolders.count{
            if toAddressUser?.listOfFolders.isEmpty == true {
                print("no folders there in : \(String(describing: toAddressUser?.EmailID))")
            }else{
                if toAddressUser?.listOfFolders[i].name == "Inbox"{
                    toAddressUser?.listOfFolders[i].listOfMails.append(email)
                    toAddressUser?.listOfFolders[i].unreadEmailsCount += 1
                    toAddressUser = Database.shared.updateUser(user: toAddressUser!)
                }
            }
        }
    }
    
    func markAsFavourite(mailId: Int){
        var user = Database.shared.getUserDetails(emailId: currentUser.EmailID)
        let folderName = "Starred"
        guard let folder = user?.listOfFolders.first(where: {$0.name == folderName}) else{
            user = self.addFolders(user: currentUser, folderName: folderName)!
            print("folders count : ",user!.listOfFolders.count)
            for i in 0..<user!.listOfFolders.count{
                if user!.listOfFolders[i].name == folderName{
                    currentEmail.isFavourite = true
                    user!.listOfFolders[i].listOfMails.append(currentEmail)
                    user!.listOfFolders[i].unreadEmailsCount += 1
                    currentUser = Database.shared.updateUser(user: user!)!
                }
            }
            return
        }
       
        for i in 0..<user!.listOfFolders.count{
            if user!.listOfFolders[i].name == folderName{
                currentEmail.isFavourite = true
                user!.listOfFolders[i].listOfMails.append(currentEmail)
                user!.listOfFolders[i].unreadEmailsCount += 1
                currentUser = Database.shared.updateUser(user: user!)!
            }
        }
        return
    }
    
    func openMail(mailId: Int, folderName: String)->Bool{
        let  user = Database.shared.getUserDetails(emailId: currentUser.EmailID)
        var result: Bool = false
        
        if var folder = user?.listOfFolders.first(where: {$0.name == folderName}){
            if folder.listOfMails.isEmpty{
                print("NO MAILS TO DISPLAY")
                result = false
            }else{
                if mailId <= folder.listOfMails.count && mailId > 0{
                    for (index, mail) in folder.listOfMails.enumerated(){
                        if index == mailId - 1{
//                            print(String(repeating: "-", count: 40))
                            print(" ------MAIL DETAILS--------- ")
                            print(" fromAddress: ",mail.fromAddress)
                            print(" toAddress: ",mail.toAddress)
                            if let cc = mail.cc  {
                                print(" CC: ",terminator: " ")
                                for user in cc {
                                    print(user,terminator: " ")
                                }
                                print(" ")
                            }
                            print(" subject: ",mail.subject ?? "nil")
                            print(" content: ",mail.body ?? "nil")
                            
                            self.markAsRead(mailId: mailId, folderName: currentFolder)
                            print(String(repeating: "-", count: 40))
                            
                            currentMailId = mailId
                            result =  true
                        }
                            }
                }else{
                    print("enter a number in range")
                    print(String(repeating: "-", count: 30))
                    result = false
                }
            }
        }
        return result
    }
    
    func markAsRead(mailId: Int , folderName: String){
        var  user = Database.shared.getUserDetails(emailId: currentUser.EmailID)
        currentUser = user!
        if user!.listOfFolders.count > 0{
            
            for i in  0..<user!.listOfFolders.count{
                if user?.listOfFolders[i].name == folderName {
                    if user!.listOfFolders[i].listOfMails.count > 0 {
                        for j in 0..<user!.listOfFolders[i].listOfMails.count{
                            if j == mailId - 1 && user!.listOfFolders[i].listOfMails[j].isRead == false{
                                print("x1: ")
                                user!.listOfFolders[i].listOfMails[j].isRead = true
                                user!.listOfFolders[i].unreadEmailsCount -= 1
                                currentEmail = user!.listOfFolders[i].listOfMails[j]
                                print("current email",terminator: "\(currentEmail)")
                                currentUser = Database.shared.updateUser(user: user!)!
                                return
                            }else{
                                print("mail is already read")
                                return
                            }
                        }
                    }else{
                            print("NO MAILS TO DISPLAY")
                            return
                        }
                }
            }
        }else{
            print("no folders to display ")
            return
        }
        
    }
    
    func deleteMail( mailId: Int, folderName: String)  {
        var user = Database.shared.getUserDetails(emailId: currentUser.EmailID)
        guard mailId > 0 else {
            print("INVALID MAILID NUMBER")
            return
        }
        
        guard let folderIndex = user!.listOfFolders.firstIndex(where: { $0.name == folderName }) else {
            // Throw an error if folderName is invalid
            return
        }
        
        let mailIndex = mailId - 1
        let binIndex = user?.listOfFolders.firstIndex(where: { $0.name == "Bin" }) ?? 2
        currentUser = user!
        
        guard var user = user else{
            print("user is nil ")
            return
        }
        
        if user.listOfFolders[folderIndex].listOfMails.isEmpty {
            print("NO MAILS TO DELETE")
        } else if mailIndex < user.listOfFolders[folderIndex].listOfMails.count && mailIndex >= 0 {
            user.listOfFolders[binIndex].listOfMails.append(currentUser.listOfFolders[folderIndex].listOfMails[mailIndex])
            if user.listOfFolders[folderIndex].listOfMails[mailIndex].isRead == false {
                user.listOfFolders[binIndex].unreadEmailsCount += 1
            }
            user.listOfFolders[folderIndex].listOfMails.remove(at: mailIndex)
            if user.listOfFolders[folderIndex].unreadEmailsCount > 0 {
                user.listOfFolders[folderIndex].unreadEmailsCount -= 1
            }
            guard let updatedUser = Database.shared.updateUser(user: user) else{
                print("failed to retrieve updated user")
               return
            }
            currentUser = updatedUser
            print("MAIL DELETED SUCCESFULLY")
            
        } else {
            print("INVALID MAILID NUMBER")
        }
        return
    }
    
}

extension userUseCase: AuthenticationContract  {
   
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

extension userUseCase: DisplayContract {

    func displayListOfFolders(user: User){
        //        print(" -------------------------------------- ")
        print(" ----------- LIST OF FOLDERS --------- ")
        let updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
        for (index,folders) in updatedUser!.listOfFolders.enumerated(){
            print("SNo: \(index+1)  | folderName: \(folders.name)  | UnreadMails:  \(folders.unreadEmailsCount)  | TotalMails:   \(folders.listOfMails.count)")
        }
        print(" -------------------------------------- ")
    }
    
    func displayMails(folderName: String)->Bool{
        let user = Database.shared.getUserDetails(emailId: currentUser.EmailID)
        var flag: Bool = false
        if let folder = user?.listOfFolders.first(where: {$0.name == folderName} ) {
            guard folder.listOfMails.count > 0 else{
                print("no mails to display")
                return false
            }
            currentFolder = folderName
            print("display mail - current folder name: \(currentFolder)")
            for (index,mail) in folder.listOfMails.enumerated(){
                print("SNo: \(index+1) , sender: \(mail.fromAddress)  , to: \(mail.toAddress) , subject: \(String(describing: mail.subject))")
                flag = true
            }
            
        }else{
            print("no  folder with the name: \(folderName) , enter a valid name ")
           flag = false
        }
        return flag
    }
}

extension userUseCase: FolderContract {
    
    func addFolders(user:  User , folderName: String)->User?{
        var updatedUser = Database.shared.getUserDetails(emailId: user.EmailID)
        updatedUser!.listOfFolders.append(Folder(name: folderName))
        let updatedUser1 = Database.shared.updateUser(user: updatedUser!)
        
        return updatedUser1!
        
    }
   
    func moveMailToAnotherFolder(user: User , folderName: String)->User?{
        
        let result = validateFolder(user: user , folderName: folderName)
        print("is folder present: ",result)
        
        guard var user1 =  Database.shared.getUserDetails(emailId: user.EmailID) else{
            print("failed to retrieve user ")
            return currentUser
        }
        
        if result {
        outerloop1: for i in 0..<user1.listOfFolders.count {
                if user1.listOfFolders[i].name == folderName {
                    print("1 folderName: \(folderName)")
                    print("2 current email",currentEmail)
                    user1.listOfFolders[i].listOfMails.append(currentEmail)
                    
                outerloop: for j in 0..<user1.listOfFolders.count{
                        if user1.listOfFolders[j].name == currentFolder {
                        innerloop: for k in 0..<user1.listOfFolders[j].listOfMails.count{
                                if currentMailId - 1 == k {
                                    print("000000", i , j ,k)
                                    user1.listOfFolders[j].listOfMails.remove(at: k)
                                    
                                    if user1.listOfFolders[j].unreadEmailsCount > 0 {
                                        user1.listOfFolders[j].unreadEmailsCount -= 1
                                    }
                                    
                                    currentUser = Database.shared.updateUser(user: user1)!
                                    print(currentUser," current user ")
                                    print(currentEmail," current email ")
                                    break outerloop1
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
        }else{
            guard var user1 = addFolders(user: user1, folderName: folderName) else{
                print("failed to retrieve user")
                return currentUser
            }
        outerloop1: for i in 0..<user1.listOfFolders.count {
                if user1.listOfFolders[i].name == folderName {
                    print("1 folderName: \(folderName)")
                    print("2 current email",currentEmail)
                    user1.listOfFolders[i].listOfMails.append(currentEmail)
                    
                outerloop: for j in 0..<user1.listOfFolders.count{
                        if user1.listOfFolders[j].name == currentFolder {
                        innerloop: for k in 0..<user1.listOfFolders[j].listOfMails.count{
                                if currentMailId - 1 == k {
                                    print("000000", i , j ,k)
                                    user1.listOfFolders[j].listOfMails.remove(at: k)
                                    
                                    if user1.listOfFolders[j].unreadEmailsCount > 0 {
                                        user1.listOfFolders[j].unreadEmailsCount -= 1
                                    }
                                    
                                    currentUser = Database.shared.updateUser(user: user1)!
                                    print(currentUser," current user ")
                                    print(currentEmail," current email ")
                                    break outerloop1
                                    
                                }
                            }
                        }
                    }
                    
                }
            }
        }
        return currentUser
    }
    
    private func subMoveMailFunction(user: User , folderName: String ){
        
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






