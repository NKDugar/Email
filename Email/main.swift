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
        print("selected option: ",terminator: " ")
        let selectedoption = Int(selectedOption!)
        switch selectedoption{
        case 1:
            print(" -------------------------------------- ")
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
            print("login: ")
            print("emailID: ",terminator: " ")
            let emailID = readLine()!
            print("password: ",terminator: " ")
            let password = readLine()!
            guard let loginUser = useCase.loginUser(emailID: emailID, password: password)else{
                return
            }
            print("login successfull : \(String(describing: loginUser.EmailID))")
            currentUser = loginUser
            afterLogin(user: currentUser)
            
        default:
            print("invalid option entered")
        }
    }
    
    func afterLogin(user:  User){
        print(" -------------------------------------- ")
        print("1. compose mail")
        print("2. inboxMails")
        print("3. sentMails")
        print("4. addFolders")
        print("5. listOffolders")
        print("6. logout")
        print("7. starred messages")
        print(" -------------------------------------- ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        switch optionselected{
        case 1:
            print("--------  composing a email -------")
            print("emailId: \(user.EmailID)")
            composeMailView(user: currentUser)
        case 2:
            print("----------  inbox -  --------")
            print("emailId: \(currentUser.EmailID)")
            useCase.displayInboxMails(user: currentUser)
            afterOpeningInboxMails(user: currentUser)
        case 3:
            print("------  opening sentMails folder ---------")
            print("emailId: \(currentUser.EmailID)")
            useCase.displaySentMails(user: currentUser)
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
            print("displaying list of folders in user \(currentUser.EmailID)")
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
        print("---------------- composeMailView - compose mail view --------------")
        print("enter  toAddress, cc - can be nil but should be seperated by a , only  , subject , body ,")
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
            print("cc entered",trimmedCc[0])
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
        }else{
            print("mail was composed succesfully with subject: - \(String(describing: mail?.subject))")
            afterComposition(user: currentUser ,email: mail!)
           
//            var user12 = useCase.addFolders(user: &user)
//            useCase.getUserDetails(emailId: user12.EmailID )
//            afterComposition()
        }
    }
    
    func afterComposition(user:  User , email: Emails){
        print(" -------------------------------------- ")
        print("------------ afterComposingMail() view ---------")
        print("1. send")
        print("2. cancel")
        print(" -------------------------------------- ")
        print("selected option: ",terminator: " ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        switch optionselected{
        case 1:
            print("--------  send -------")
            let currentUser = useCase.sendEmail(user: user, email: email)
            print(print("emailId: \(currentUser!.EmailID)"))
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
        print(" -------------------------------------- ")
        print("selected option: ",terminator: " ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        switch optionselected{
        case 1:
            afterLogin(user: currentUser)
        case 2:
            print("----- delete selected mails -----")
            deletingInboxMails(user: currentUser)
            
        case 3:
            print("----- open mail ------ ")
            print("emailId: \(currentUser.EmailID)")
            openingMail(user: currentUser , folderName: "Inbox")
            print("main - afterOpeningInboxMails - ")
            afterOpeningInboxMails(user: currentUser)
        default:
            print("-------- invalid number entered -------")
            afterLogin(user: currentUser)
        }
        
    }
    
    func deletingInboxMails(user:  User){
        print(" -------------------------------------- ")
        print("-------- deletingInboxMails() ------- ")
        print("emailId: \(currentUser.EmailID)")
        print("enter the mail SNo. to delete: ",terminator: " ")
        print(" -------------------------------------- ")
        let input = readLine()
        let input1 = Int(input ?? "0") ?? -1
        print("input number: ",input1)
        currentUser = useCase.deleteInboxMails(user: currentUser, mailNo: input1) ?? User()
        if currentUser == nil {
            print("deletingInboxMails() - currentUser is nil ")
        }
        afterOpeningInboxMails(user: currentUser)
        
    }
    
    func afterOpeningSentMails(user:  User){
        print(" -------------------------------------- ")
        print("emailId: \(currentUser.EmailID)")
        print("1. back")
        print("2. deleteMails")
        print("selected option: ",terminator: " ")
        print(" -------------------------------------- ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        switch optionselected{
        case 1:
            afterLogin(user: currentUser)
        case 2:
            print(" -------------------------------------- ")
            print("----- delete selected mails -----")
            print("emailId: \(currentUser.EmailID)")
            deletingSentMails(user: currentUser)
            print(" -------------------------------------- ")
        case 3:
            print("something")
//            openingSelectedMail()
        default:
            print("-------- invalid number entered -------")
        }
        
    }
    
    func deletingSentMails(user:  User){
        print(" -------------------------------------- ")
        print("-------- deletingSentMails() ------- ")
        print("emailId: \(currentUser.EmailID)")
        print("enter the mail SNo. to delete: ",terminator: " ")
        print(" -------------------------------------- ")
        let input = readLine()
        let input1 = Int(input ?? "0") ?? -1
        
        currentUser = useCase.deleteSentMails(user: currentUser, mailNo: input1)!
        if currentUser == nil {
            print("current user is nil - main - deletingSentMails ")
        }
        print("calling afteropeningSentMails - main - after calling deletingSentMails")
        afterOpeningSentMails(user: currentUser)
        
    }
    
    func openingMail(user:  User, folderName: String){
        print(" -------------------------------------- ")
        print(" ---- opening a mail -----")
        print("emailId: \(currentUser.EmailID)")
        print("enter the mail no: to open ",terminator: " ")
        print(" -------------------------------------- ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        currentUser = useCase.displaySelectedMail(user: currentUser, folderName: folderName, mailNoToOpen: optionselected!)!
        if currentUser == nil {
            print("main - openingMail - current user is nil")
        }
       
        
    }
    

    registerAndLoginPage()
}
