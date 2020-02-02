//
//  SocketService.swift
//  MySmack
//
//  Created by Michael Sidoruk on 31.01.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import UIKit
import SocketIO

class SocketService: NSObject {

    static let shared = SocketService()
    
    let manager: SocketManager
    let socket: SocketIOClient
    
    override init() {
        self.manager = SocketManager(socketURL: URL(string: BASE_URL)!)
        self.socket = manager.defaultSocket
        super.init()
    }
    
    func establishConnection() {
        socket.connect()
    }
    
    func closeConnection() {
        socket.disconnect()
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        socket.emit("newChannel", channelName, channelDescription)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) { // kak listener
        socket.on("channelCreated") { (dataArray, ack) in
            guard
                let channelName = dataArray[0] as? String,
                let channelDesc = dataArray[1] as? String,
                let channelId = dataArray[2] as? String else { return }
            let channel = Channel(channelTitle: channelName, channelDescription: channelDesc, id: channelId)
            MessageService.shared.channels.append(channel)
            completion(true)
        }
    }
    
    func addMessage(messageBode: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.shared
        
        socket.emit("newMessage", messageBode, userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true)
    }
    
    func getChatMessage(completion: @escaping (Message) -> Void) {
        socket.on("messageCreated") { (dataArray, ack) in
            guard
                let messageBody = dataArray[0] as? String,
                let channelId = dataArray[2] as? String,
                let userName = dataArray[3] as? String,
                let userAvatar = dataArray[4] as? String,
                let userAvatarColor = dataArray[5] as? String,
                let id = dataArray[6] as? String,
                let timeStamp = dataArray[7] as? String else { return }
            
            let newMessage = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
            completion(newMessage)
        }
    }
    
    func getTypingUsers(_ completion: @escaping (_ typingUsers: [String: String]) -> Void) {
        socket.on("userTypingUpdate") { (arrayData, ack) in
            guard let typingUsers = arrayData[0] as? [String: String] else { return }
            completion(typingUsers)
        }
    }
}
