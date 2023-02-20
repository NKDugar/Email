//
//  main.swift
//  Email
//
//  Created by naveen-pt6301 on 14/02/23.
//

import Foundation

private var useCase = userUseCase()
private var currentUser = User()
private var currentEmail = Emails()

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
            print(String(repeating: "-", count: 30))
            let newUser = User(Name: userName, EmailID: emailID, password: password)
            if useCase.registerUser(user: newUser){
                print("user registration successfull ")
            }
        case 2:
            print(String(repeating: "-", count: 30))
            print("LOGIN - ")
            
            print("emailID: ",terminator: " ")
            let emailID = readLine()!
            print("password: ",terminator: " ")
            let password = readLine()!
            print(String(repeating: "-", count: 30))
            guard let loginUser = useCase.loginUser(emailId: emailID, password: password)else{
                return
            }
            print("LOGIN successfull : \(String(describing: loginUser.EmailID))")
            print(String(repeating: "-", count: 30))
            currentUser = loginUser
            afterLogin(user: currentUser)
            
        default:
            print("invalid option entered")
        }
    }
    
    func afterLogin(user:  User){
        print("1. compose mail")
        print("2. inboxMails")
        print("3. sentMails")
        print("4. addFolders")
        print("5. listOffolders")
        print("6. logout")
        
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        print(String(repeating: "-", count: 30))
        
        switch optionselected{
        case 1:
            print("--------  composing a email -------")
            composeMailView(user: currentUser)
            
        case 2:
            print("----------  inbox -  --------")
            useCase.displayInboxMails(user: currentUser , folderName: "Inbox")
            afterOpeningInboxMails(user: currentUser)
            print(" ------- finish inbox ------")
        case 3:
            print("------  sentMails folder ---------")
            useCase.displaySentMails(user: currentUser , folderName: "Sent")
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
            useCase.displayListOfFolders(user: currentUser)
            afterLogin(user: currentUser)
        case 6:
            print(" ----- logout ------")
            print("emailId: \(currentUser.EmailID)")
            _ = useCase.logoutUser()
            registerAndLoginPage()
            
        case 10:
            print("displaying user info: ")
            Database.shared.displayAllTheData()
            print(currentUser.EmailID)
            afterLogin(user: currentUser)
        default:
            print("----------- invalid number entered -----------")
        }
    }
    
    func composeMailView(user:   User){
        print(String(repeating: "-", count: 30))
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
        } else {
            print("cc is nil")
        }
        let isRead = false
        let isFavourite = false
        print(String(repeating: "-", count: 30))
        let newEmail = Emails(toAddress: toAddress, fromAddress: user.EmailID, subject: subject , body: body, cc:  trimmedCc, isRead: isRead, isFavourite: isFavourite )
        let mail = useCase.composeMail(email: newEmail)
        if mail == nil {
            print("mail composing failed")
            print(String(repeating: "-", count: 30))
            afterLogin(user: user)
        }else{
            afterComposition(user: currentUser ,email: mail!)
        }
    }
    
    func afterComposition(user:  User , email: Emails){
        print(String(repeating: "-", count: 30))
        print("1. send")
        print("2. cancel")
        print("selected option: ",terminator: " ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        print(String(repeating: "-", count: 30))
        switch optionselected{
        case 1:
            print("--------  send -------")
            currentUser = useCase.sendEmail(user: user, email: email)!
            afterLogin(user: currentUser)
        case 2:
            print("----------  cancel   --------")
            afterLogin(user: currentUser)
        default:
            print("-------- invalid number entered -------")
            afterLogin(user: currentUser)
        }
        
    }
    
    func afterOpeningInboxMails(user:  User){
        print(" ---------------after opening inbox----------------------- ")
        print("1. back")
        print("2. deleteMails")
        print("3. openMail")
        print("4. copyToAnotherFolder")
        print("selected option: ",terminator: " ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        print(String(repeating: "-", count: 30))
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
            print("----- copy to ------")
            copyToAnotherFolder(email: currentEmail)
            
        default:
            print("-------- invalid number entered -------")
            afterLogin(user: currentUser)
        }
        
    }
    
    func deletingInboxMails(user:  User){
        print(String(repeating: "-", count: 30))
        print("enter the mail SNo. to delete: ",terminator: " ")
        let input = readLine()
        let input1 = Int(input ?? "0") ?? -1
        print("input number: ",input1)
        currentUser = useCase.deleteMail(user: currentUser, mailNo: input1 , folderName: "Inbox") ?? User()
//      afterOpeningInboxMails(user: currentUser)
        print(String(repeating: "-", count: 30))
        afterLogin(user: currentUser)
    }
    
    func afterOpeningSentMails(user:  User){
        print("1. back")
        print("2. deleteMails")
        print("selected option: ",terminator: " ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        print(String(repeating: "-", count: 30))
        switch optionselected{
        case 1:
            afterLogin(user: currentUser)
        case 2:
            deletingSentMails(user: currentUser)
            print(String(repeating: "-", count: 30))
        default:
            print("-------- invalid number entered -------")
        }
    }
    
    func deletingSentMails(user:  User){
        
        print("-------- deletingSentMails() ------- ")
        print("enter the mail SNo. to delete : ",terminator: " ")
        let input = readLine()
        let input1 = Int(input ?? "0") ?? -1
        currentUser = useCase.deleteMail(user: currentUser, mailNo: input1 , folderName: "Sent")!
        print(String(repeating: "-", count: 30))
        afterOpeningSentMails(user: currentUser)
    }
    
    func openingMail(user:  User, folderName: String){
        
        print(" ---- opening a mail -----")
        print("enter the mail no: to open ",terminator: " ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        print(String(repeating: "-", count: 30))
        let output = useCase.displaySelectedMail(user: currentUser, folderName: folderName, mailNoToOpen: optionselected!)
        currentUser = output.0!
        currentEmail = output.1!
    
        
    }
    
    func copyToAnotherFolder(email: Emails){
        print("--------copy a mail to another folder----------")
        useCase.displayListOfFolders(user: currentUser)
        print("enter the name of the folder:  ",terminator: " ")
        let nameOfFolder = readLine()!
        currentUser = useCase.copyMailToAnotherFolder(user: currentUser, email: email, folderName: nameOfFolder)!
        afterLogin(user: currentUser)
    }
    
    _ = useCase.logoutUser()
    registerAndLoginPage()
    
}
