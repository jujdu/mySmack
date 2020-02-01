//
//  ChatVC.swift
//  MySmack
//
//  Created by Michael Sidoruk on 29.01.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    //MARK: @IBOutlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        if AuthService.shared.isLoggedIn {
            AuthService.shared.findUserByEmail { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }
    }
    
    @objc func userDataDidChange(_ notifcation: Notification) {
        if AuthService.shared.isLoggedIn {
            //getchannels
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log In"
        }
    }
    
    @objc func channelSelected(_ notifcation: Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let channelName = MessageService.shared.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
    }

    func onLoginGetMessages() {
        MessageService.shared.findAllChannels { (success) in
            if success {
                
            }
        }
    }
}
