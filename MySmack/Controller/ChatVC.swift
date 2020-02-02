//
//  ChatVC.swift
//  MySmack
//
//  Created by Michael Sidoruk on 29.01.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: @IBOutlets
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var channelNameLbl: UILabel!
    @IBOutlet weak var messageTxt: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var typingUsersLbl: UILabel!
    
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sendBtn.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        view.bindToKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        SocketService.shared.getChatMessage { (newMessage) in
            if newMessage.channelId == MessageService.shared.selectedChannel?.id && AuthService.shared.isLoggedIn {
                MessageService.shared.messages.append(newMessage)
                self.tableView.reloadData()
                if MessageService.shared.messages.count > 0 {
                    let indexPath = IndexPath(row: MessageService.shared.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            }
        }
        
//        SocketService.shared.getChatMessage { (success) in
//            if success {
//                self.tableView.reloadData()
//                if MessageService.shared.messages.count > 0 {
//                    let indexPath = IndexPath(row: MessageService.shared.messages.count - 1, section: 0)
//                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
//                }
//            }
//        }
        
        SocketService.shared.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.shared.selectedChannel?.id else { return }
            
            var names = ""
            var numberOfTypers = 0
            print(typingUsers)
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.shared.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypers += 1
                }
            }
            
            if numberOfTypers > 0 && AuthService.shared.isLoggedIn {
                var verb = "is"
                if numberOfTypers > 1 {
                    verb = "are"
                }
                
                self.typingUsersLbl.text = "\(names) \(verb) typing a message"
            } else {
                self.typingUsersLbl.text = ""
            }
        }
        
        if AuthService.shared.isLoggedIn {
            AuthService.shared.findUserByEmail { (success) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func userDataDidChange(_ notifcation: Notification) {
        if AuthService.shared.isLoggedIn {
            //getchannels
            onLoginGetMessages()
        } else {
            channelNameLbl.text = "Please Log In"
            tableView.reloadData()
        }
    }
    
    @objc func channelSelected(_ notifcation: Notification) {
        updateWithChannel()
    }
    
    func updateWithChannel() {
        let channelName = MessageService.shared.selectedChannel?.channelTitle ?? ""
        channelNameLbl.text = "#\(channelName)"
        getMessages()
    }
    
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        guard let channelId = MessageService.shared.selectedChannel?.id else { return }
        if messageTxt.text == "" {
            isTyping = false
            sendBtn.isHidden = true
            SocketService.shared.socket.emit("stopType", UserDataService.shared.name, channelId)
        } else {
            if isTyping == false {
                sendBtn.isHidden = false
                SocketService.shared.socket.emit("startType", UserDataService.shared.name, channelId)
            }
            isTyping = true
        }
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        if AuthService.shared.isLoggedIn {
            guard
                let channelId = MessageService.shared.selectedChannel?.id,
                let message = messageTxt.text else { return }
            
            SocketService.shared.addMessage(messageBode: message, userId: UserDataService.shared.id, channelId: channelId) { (success) in
                if success {
                    self.messageTxt.text = ""
                    self.messageTxt.resignFirstResponder()
                    SocketService.shared.socket.emit("stopType", UserDataService.shared.name, channelId)
                    self.isTyping = false
                }
            }
        }
    }
    

    func onLoginGetMessages() {
        MessageService.shared.findAllChannels { (success) in
            if success {
                if MessageService.shared.channels.count > 0 {
                    MessageService.shared.selectedChannel = MessageService.shared.channels.first
                    self.updateWithChannel()
                } else {
                    self.channelNameLbl.text = "No channels yet"
                }
            }
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.shared.selectedChannel?.id else { return }
        MessageService.shared.findAllMessagesForChannel(channelId: channelId) { (success) in
            if success {
                self.tableView.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.shared.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell {
            cell.configureCell(message: MessageService.shared.messages[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
