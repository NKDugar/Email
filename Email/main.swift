//
//  main.swift
//  Email
//
//  Created by naveen-pt6301 on 14/02/23.
//

import Foundation

private var useCase = userUseCase()
private var currentUser = User()

let acc1 = User(Name: "naveen",  EmailID: "naveen@gmail.com" , password: "12345")
let acc2 = User(Name: "guhan", EmailID: "guhan@gmail.com" , password: "12345")
let acc3 = User(Name: "deepak", EmailID: "deepak@gmail.com", password: "12345")
let acc4 = User(Name: "arun", EmailID: "arun@gmail.com", password: "12345")

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
            print("register : ")
            print("enter userName: ",terminator: " ")
            let userName = readLine()!
            print("enter emailID: ",terminator: " ")
            let emailID = readLine()!
            print("enter password: ",terminator: " ")
            let password = readLine()!
            let newUser = User(Name: userName, EmailID: emailID, password: password)
            if useCase.registerUser(user: newUser){
                print("user registration successfull ")
            }
        case 2:
            print("login: ")
            print("emailID: ",terminator: " ")
            let emailID = readLine()!
            print("password: ",terminator: " ")
            let password = readLine()!
            guard var loginUser = useCase.loginUser(emailID: emailID, password: password)else{
                return
            }
            if loginUser == nil {
                print("login failed")
            }else{
                print("login successfull : \(String(describing: loginUser.EmailID))")
                currentUser = loginUser
                afterLogin(user: &loginUser)
            }
            
        default:
            print("invalid option entered")
        }
    }
    
    func afterLogin(user: inout User){
        print("1. compose mail")
        print("2. inbox")
        print("3. sent")
        print("4. logout")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        switch optionselected{
        case 1:
            print("--------  composing a email -------")
            
            composeMailView(user: &user)
            
        case 2:
            print("----------  inbox -  --------")
            afterLogin(user: &user)
            
        case 3:
            print("------  opening sentMails folder ---------")
            
        case 4:
            print(" ----- logout ------")
            registerAndLoginPage()
        
        case 10:
            print("displaying user info: ")
            
        
        default:
            print("----------- invalid number entered -----------")
        }
    }
    
    func composeMailView(user: inout User){
        print("---------------- composeMailView - compose mail view --------------")
        print("enter  toAddress, cc - can be nil but should be seperated by a , only  , subject , body ,")
        
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
        
        let newEmail = Emails(toAddress: toAddress, fromAddress: user.EmailID, subject: subject , body: body, cc:  trimmedCc, isRead: isRead, isFavourite: isFavourite )
        let mail = useCase.composeMail(email: newEmail)
        if mail == nil {
            print("mail composing failed")
        }else{
            print("mail was composed succesfully with subject: - \(String(describing: mail?.subject))")
            afterComposition(user: &user ,email: mail!)
//            var user12 = useCase.addFolders(user: &user)
//            useCase.getUserDetails(emailId: user12.EmailID )
//            afterComposition()
        }
    }
    
    func afterComposition(user: inout User , email: Emails){
        print("------------ afterComposingMail() view ---------")
        print("1. send")
        print("2. cancel")
        print("selected option: ",terminator: " ")
        let optionSelected = readLine()!
        let optionselected = Int(optionSelected)
        switch optionselected{
        case 1:
            print("--------  send -------")
            var currentUser = useCase.sendEmail(user: &user, email: email)
            useCase.getUserDetails(emailId: currentUser!.EmailID)
            print("-------")
            afterLogin(user: &user)
        case 2:
            print("----------  cancel   --------")
            
        default:
            print("-------- invalid number entered -------")
        }
        
    }
    
    registerAndLoginPage()
}
