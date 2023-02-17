//
//  EmailAppContract.swift
//  Email
//
//  Created by naveen-pt6301 on 16/02/23.
//

import Foundation

protocol AuthenticationContract{
    
    func registerUser(user:  User)->Bool
    func loginUser(emailId: String , password: String)->User?
    func logoutUser()->Bool
    
}

protocol MailContract{
    
    func validateUser(toAddress: String) -> Bool
    func validateCC(email: Emails) -> Bool
    func sendMail(email: Emails)
    func getAllMails()->[Emails]
}

protocol UserDetailsContract{
    
    func updateUser(user: inout User)->User?
    func getUserDetails(emailId: String)->User?
    func displayAllTheData()
}

protocol UserDisplayContract{
    
    func displaySentMails(user: User , folderName: String)
    func displayInboxMails(user: User , folderName: String)
    func displayListOfFolders(user: User)
    func displaySelectedMail(user: User , folderName: String , mailNoToOpen: Int)-> (User?,Emails?)
}

protocol FolderContract{
    
    func addFolders(user:  User , folderName: String)->User?
    func validateFolder(user: User , folderName: String)->Bool
    func copyMailToAnotherFolder(user: User , email: Emails , folderName: String)->User?
}
