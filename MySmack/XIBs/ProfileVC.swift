//
//  ProfileVC.swift
//  MySmack
//
//  Created by Michael Sidoruk on 31.01.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    @IBOutlet weak var profileImage: CircleImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        profileImage.image = UIImage(named: UserDataService.shared.avatarName)
        profileImage.backgroundColor = UserDataService.shared.returnUIColor(components: UserDataService.shared.avatarColor)
        userName.text = UserDataService.shared.name
        userEmail.text = UserDataService.shared.email
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeTap(_:)))
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc func closeTap(_ gesture: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func closeModalPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.shared.logoutUser()
        NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        self.dismiss(animated: true, completion: nil)
    }
}
