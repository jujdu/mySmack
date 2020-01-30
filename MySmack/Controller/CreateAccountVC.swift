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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    //Properties
    var avatarName = "profileDefault"
    var avatarColor = "[0.5, 0.5, 0.5, 1]"
    var bgColor: UIColor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDataService.shared.avatarName != "" {
            userImg.image = UIImage(named: UserDataService.shared.avatarName)
            avatarName = UserDataService.shared.avatarName
            if avatarName.contains("light") && bgColor == nil {
                userImg.backgroundColor = UIColor.lightGray
            }
        }
    }

    @IBAction func createAccountPressed(_ sender: Any) {
        guard let userName = userNameTxt.text, userNameTxt.text != "" else { return }
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let pass = passwordTxt.text, passwordTxt.text != "" else { return }
        
        activityIndicator.startAnimating()
        
        AuthService.shared.registerUser(email: email, password: pass) { (success) in
            if success {
                AuthService.shared.logInUser(email: email, password: pass) { (success) in
                    if success {
                        AuthService.shared.createUser(userName: userName, email: email, avatarName: self.avatarName, avatarColor: self.avatarColor) { (success) in
                            if success {
                                print("Success")
                                self.activityIndicator.stopAnimating()
                                self.performSegue(withIdentifier: AppSegues.unwindToChannel, sender: nil)
                                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
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
    
    func setupView() {
        userNameTxt.attributedPlaceholder = NSAttributedString(string: "username", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
        emailTxt.attributedPlaceholder = NSAttributedString(string: "email", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
        passwordTxt.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    
    
    @IBAction func pickImgPressed(_ sender: Any) {
        performSegue(withIdentifier: AppSegues.toAvatarPicker, sender: nil)
    }
    @IBAction func pickBGColorPressed(_ sender: Any) {
        let r = CGFloat(arc4random_uniform(255)) / 255
        let g = CGFloat(arc4random_uniform(255)) / 255
        let b = CGFloat(arc4random_uniform(255)) / 255

        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        
        UIView.animate(withDuration: 0.3) {
            self.userImg.backgroundColor = self.bgColor
        }
    }
    @IBAction func closePressed(_ sender: Any) {
        performSegue(withIdentifier: AppSegues.unwindToChannel, sender: nil)
    }
}
