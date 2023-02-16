//
//  main.swift
//  Email
//
//  Created by naveen-pt6301 on 14/02/23.
//

import Foundation

private var useCase = userUseCase()
private var currentUser = User()

var acc1 = User(Name: "naveen",  EmailID: "naveen@gmail.com" , password: "12345")
var acc2 = User(Name: "guhan", EmailID: "guhan@gmail.com" , password: "12345")
var acc3 = User(Name: "deepak", EmailID: "deepak@gmail.com", password: "12345")
var acc4 = User(Name: "arun", EmailID: "arun@gmail.com", password: "12345")

let result1 = useCase.registerUser(user: acc1)
let result2 = useCase.registerUser(user: acc2)
let result3 = useCase.registerUser(user: acc3)
let result4 = useCase.registerUser(user: acc4)


while true{
    func registerAndLoginPage(){
        print("welcome to email ")
        print("1. register")
        print("2. login")
        
        let selectedOption = readLine()
        let selectedoption = Int(selectedOption!)
        print("selected option: ",selectedoption ?? -1)
        switch selectedoption{
        case 1:
           
            print("register : ")
            print("enter userName: ",terminator: " ")
            let userName = readLine()!
            print("enter emailID: ",terminator: " ")
            let emailID = readLine()!
            print("enter password: ",terminator: " ")
            let password = readLine()!
            print(" -------------------------------------- ")
            var newUser = User(Name: userName, EmailID: emailID, password: password)
            if useCase.registerUser(user: newUser){
                print("user registration successfull ")
            }
        case 2:
            print(" -------------------------------------- ")
            print("LOGIN - ")
            
            print("emailID: ",terminator: " ")
            let emailID = readLine()!
            print("password: ",terminator: " ")
            let password = readLine()!
            print(" -------------------------------------- ")
            guard let loginUser = useCase.loginUser(emailID: emailID, password: password)else{
                return
            }
            print("LOGIN successfull : \(String(describing: loginUser.EmailID))")
            print(" -------------------------------------- ")
            currentUser = loginUser
            afterLogin(user: currentUser)
            
        default:
            print("invalid option entered")
        }
    }
    
    func afterLogin(user:  User){
//        print(" -------------------------------------- ")
        print("1. compose mail")
        print("2. inboxMails")
        print("3. sentMails")
        print("4. addFolders")
        print("5. listOffolders")
        print("6. logout")
        
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        print(" -------------------------------------- ")
        
        switch optionselected{
        case 1:
            print("--------  composing a email -------")
//            print("emailId: \(user.EmailID)")
            composeMailView(user: currentUser)
        case 2:
            print("----------  inbox -  --------")
//            print("emailId: \(currentUser.EmailID)")
            useCase.displayMails(user: currentUser , folderName: "Inbox")
            afterOpeningInboxMails(user: currentUser)
        case 3:
            print("------  sentMails folder ---------")
//            print("emailId: \(currentUser.EmailID)")
            useCase.displayMails(user: currentUser , folderName: "Sent")
            afterOpeningSentMails(user: currentUser)
            
        case 4:
            print("----- adding folders -----")
            print("enter the name of the folder: ",terminator: " ")
            let foldername = readLine()
            guard let currentUser = useCase.addFolders(user: user, folderName: foldername ?? "default") else {
                print("the current user is nil")
                return
            }
            afterLogin(user: currentUser)
        case 5:
//            print("displaying list of folders in user \(currentUser.EmailID)")
            useCase.displayListOfFolders(user: currentUser)
            afterLogin(user: currentUser)
        case 6:
            print(" ----- logout ------")
            print("emailId: \(currentUser.EmailID)")
            useCase.userLogout()
            registerAndLoginPage()
            
        case 10:
            print("displaying user info: ")
            Database.shared.displayAllTheData()
            
        default:
            print("----------- invalid number entered -----------")
        }
    }
    
    func composeMailView(user:   User){
//        print("---------------- composeMailView - compose mail view --------------")
//        print("enter  toAddress, cc - can be nil but should be seperated by a , only  , subject , body ,")
        print(" -------------------------------------- ")
        print("toAddress: ",terminator: " ")
        let toAddress = readLine()!
        print("enter CC : ",terminator: " ")
        let cc = readLine()?.components(separatedBy: ",")
        print("subject : ",terminator: " ")
        let subject = readLine()!
        print("body  : ",terminator: " ")
        let body = readLine()!
        
        var trimmedCc: [String] = []
        if let cc = cc {
            trimmedCc = cc.map { $0.trimmingCharacters(in: .whitespaces) }
//            print("cc entered",trimmedCc[0])
        } else {
            print("cc is nil")
        }
        let isRead = false
        let isFavourite = false
        print(" -------------------------------------- ")
        let newEmail = Emails(toAddress: toAddress, fromAddress: user.EmailID, subject: subject , body: body, cc:  trimmedCc, isRead: isRead, isFavourite: isFavourite )
        let mail = useCase.composeMail(email: newEmail)
        if mail == nil {
            print("mail composing failed")
            print(" -------------------------------------- ")
            afterLogin(user: user)
        }else{
//            print("mail was composed succesfully with subject: - \(String(describing: mail?.subject))")
            afterComposition(user: currentUser ,email: mail!)
        }
    }
    
    func afterComposition(user:  User , email: Emails){
        print(" -------------------------------------- ")
//        print("------------ afterComposingMail() view ---------")
        print("1. send")
        print("2. cancel")
        print("selected option: ",terminator: " ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        print(" -------------------------------------- ")
        switch optionselected{
        case 1:
            print("--------  send -------")
            let currentUser = useCase.sendEmail(user: user, email: email)
//            print(print("emailId: \(currentUser!.EmailID)"))
            afterLogin(user: currentUser!)
        case 2:
            print("----------  cancel   --------")
            afterLogin(user: currentUser)
        default:
            print("-------- invalid number entered -------")
            afterLogin(user: currentUser)
        }
        
    }
    
    func afterOpeningInboxMails(user:  User){
        print(" -------------------------------------- ")
        print("1. back")
        print("2. deleteMails")
        print("3. openMail")
        print("4. moveTo")
        print("selected option: ",terminator: " ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        print(" -------------------------------------- ")
        switch optionselected{
        case 1:
            afterLogin(user: currentUser)
        case 2:
            print("----- delete selected mails -----")
            deletingInboxMails(user: currentUser)
        case 3:
            print("----- open mail ------ ")
            openingMail(user: currentUser , folderName: "Inbox")
            print("main - afterOpeningInboxMails - ")
            afterOpeningInboxMails(user: currentUser)
        case 4:
            print("----- move to ------")
            
            
        default:
            print("-------- invalid number entered -------")
            afterLogin(user: currentUser)
        }
        
    }
    
    func deletingInboxMails(user:  User){
        print(" -------------------------------------- ")
//        print("-------- deletingInboxMails() ------- ")
//        print("emailId: \(currentUser.EmailID)")
        print()
        print("enter the mail SNo. to delete: ",terminator: " ")
        let input = readLine()
        let input1 = Int(input ?? "0") ?? -1
        print("input number: ",input1)
        print(" -------------------------------------- ")
        currentUser = useCase.deleteMail(user: currentUser, mailNo: input1 , folderName: "Inbox") ?? User()
        if currentUser == nil {
            print("deletingInboxMails() - currentUser is nil ")
        }
        afterOpeningInboxMails(user: currentUser)
        
    }
    
    func afterOpeningSentMails(user:  User){
//        print(" -------------------------------------- ")
//        print("emailId: \(currentUser.EmailID)")
        print("1. back")
        print("2. deleteMails")
        print("selected option: ",terminator: " ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        print(" -------------------------------------- ")
        switch optionselected{
        case 1:
            afterLogin(user: currentUser)
        case 2:
//            print(" -------------------------------------- ")
//            print("----- delete selected mails -----")
//            print("emailId: \(currentUser.EmailID)")
            deletingSentMails(user: currentUser)
            print(" -------------------------------------- ")
        case 3:
            print("something")
           
        default:
            print("-------- invalid number entered -------")
        }
        
    }
    
    func deletingSentMails(user:  User){
        
        print("-------- deletingSentMails() ------- ")
//        print("emailId: \(currentUser.EmailID)")
        print("enter the mail SNo. to delete: ",terminator: " ")
        let input = readLine()
        let input1 = Int(input ?? "0") ?? -1
        
        currentUser = useCase.deleteMail(user: currentUser, mailNo: input1 , folderName: "Sent")!
        print(" -------------------------------------- ")
//        print("calling afteropeningSentMails - main - after calling deletingSentMails")
        afterOpeningSentMails(user: currentUser)
        
    }
    
    func openingMail(user:  User, folderName: String){
        
        print(" ---- opening a mail -----")
        //        print("emailId: \(currentUser.EmailID)")
        print("enter the mail no: to open ",terminator: " ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        print(" -------------------------------------------------------------------------------- ")
        currentUser = useCase.displaySelectedMail(user: currentUser, folderName: folderName, mailNoToOpen: optionselected!)!
        
    }
    
//    func afterOpeningAMail(user: User,email: Emails){
//        print(" -------------------------------------------------------------------------------- ")
//        print("----------- afterOpeningAMail -------")
//        print("1. addToFavourites ")
//        print("2. back")
//        let input = readLine()
//        let input1 = Int(input ?? "0") ?? -1
//        print(" -------------------------------------------------------------------------------- ")
//        switch input1{
//        case 1:
//            print("adding to favourites")
//            useCase.addingToFavourites()
//        case 2:
//            print("back")
//        default:
//            print("invalid number entered")
//        }
//    }
    
    useCase.userLogout()
    registerAndLoginPage()
}
