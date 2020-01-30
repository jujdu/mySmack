//
//  CreateAccountVC.swift
//  MySmack
//
//  Created by Michael Sidoruk on 30.01.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {

    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    
    //Properties
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func createAccountPressed(_ sender: Any) {
        guard let userName = userNameTxt.text, userNameTxt.text != "" else { return }
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let pass = passwordTxt.text, passwordTxt.text != "" else { return }
        
        AuthService.shared.registerUser(email: email, password: pass) { (success) in
            if success {
                AuthService.shared.logInUser(email: email, password: pass) { (success) in
                    if success {
                        AuthService.shared.createUser(userName: userName, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor) { (success) in
                            if success {
                                print("Success")
                                self.performSegue(withIdentifier: AppSegues.unwindToChannel, sender: nil)
                            }
                        }
                    } else {
                        print("Login failed")
                    }
                }
            } else {
                print("cannot register user")
            }
        }
    }
    @IBAction func pickImgPressed(_ sender: Any) {
    }
    @IBAction func pickBGColorPressed(_ sender: Any) {
    }
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: AppSegues.unwindToChannel, sender: nil)
    }
}
