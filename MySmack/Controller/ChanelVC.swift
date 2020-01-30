//
//  ChanelVC.swift
//  MySmack
//
//  Created by Michael Sidoruk on 29.01.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import UIKit

class ChanelVC: UIViewController {

    //MARK: @IBOutlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: CircleImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
    }
    
    @objc func userDataDidChange(_ notifcation: Notification) {
        if AuthService.shared.isLoggedIn {
            loginBtn.setTitle(UserDataService.shared.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.shared.avatarName)
            userImg.backgroundColor = UserDataService.shared.returnUIColor(components: UserDataService.shared.avatarColor)
            print(UserDataService.shared.returnUIColor(components: UserDataService.shared.avatarColor))
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
//            userImg.backgroundColor = .clear
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: AppSegues.toLogin, sender: nil)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}

}
