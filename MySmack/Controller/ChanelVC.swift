//
//  ChanelVC.swift
//  MySmack
//
//  Created by Michael Sidoruk on 29.01.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import UIKit

class ChanelVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: @IBOutlets
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        
        SocketService.shared.getChannel { (success) in// kak listener
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }
    
    @objc func userDataDidChange(_ notifcation: Notification) {
        setupUserInfo()
    }
    
    func setupUserInfo() {
        if AuthService.shared.isLoggedIn {
            loginBtn.setTitle(UserDataService.shared.name, for: .normal)
            userImg.image = UIImage(named: UserDataService.shared.avatarName)
            userImg.backgroundColor = UserDataService.shared.returnUIColor(components: UserDataService.shared.avatarColor)
            print(UserDataService.shared.returnUIColor(components: UserDataService.shared.avatarColor))
        } else {
            loginBtn.setTitle("Login", for: .normal)
            userImg.image = UIImage(named: "menuProfileIcon")
            userImg.backgroundColor = .clear
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if AuthService.shared.isLoggedIn {
            // show profile
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            profile.modalTransitionStyle = .crossDissolve
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: AppSegues.toLogin, sender: nil)
        }
    }
    
    @IBAction func addChannelPressed(_ sender: Any) {
        let addChannelVC = AddChannelVC()
        addChannelVC.modalPresentationStyle = .overFullScreen
        addChannelVC.modalTransitionStyle = .crossDissolve
        present(addChannelVC, animated: true, completion: nil)
    }
    
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.shared.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            let channel = MessageService.shared.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        }
        return UITableViewCell()
    }
}
