//
//  LoginVC.swift
//  MySmack
//
//  Created by Michael Sidoruk on 29.01.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        usernameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
    }
    
    @IBAction func closePressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        
        guard
            let email = usernameTxt.text, usernameTxt.text != "",
            let password = passwordTxt.text, passwordTxt.text != "" else { return }
        
        AuthService.shared.logInUser(email: email, password: password) { (success) in
            if success {
                AuthService.shared.findUserByEmail { (success) in
                    if success {
                        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                        self.activityIndicator.stopAnimating()
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func createAccountPressed(_ sender: Any) {
        performSegue(withIdentifier: AppSegues.toCreateAccount, sender: nil)
    }
    
}
