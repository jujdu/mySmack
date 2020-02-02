//
//  UserDataService.swift
//  MySmack
//
//  Created by Michael Sidoruk on 30.01.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import Foundation

class UserDataService {
    
    static let shared = UserDataService()
    
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, avatarColor: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = avatarColor
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(avatarName: String) {
        self.avatarName = avatarName
    }
    
    func returnUIColor(components: String) -> UIColor {
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "][, ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a: String?
        
        r = scanner.scanUpToCharacters(from: comma)
        g = scanner.scanUpToCharacters(from: comma)
        b = scanner.scanUpToCharacters(from: comma)
        a = scanner.scanUpToCharacters(from: comma)
        
        let defaultColor = UIColor.lightGray
        
        guard
            let rUnrapped = r,
            let gUnrapped = g,
            let bUnrapped = b,
            let aUnrapped = a else { return defaultColor }
        
        let rFloat = CGFloat(Double(rUnrapped) ?? 0)
        let gFloat = CGFloat(Double(gUnrapped) ?? 0)
        let bFloat = CGFloat(Double(bUnrapped) ?? 0)
        let aFloat = CGFloat(Double(aUnrapped) ?? 0)
        
        return UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)
    }
    
    func logoutUser() {
        id = ""
        avatarName = ""
        avatarColor = ""
        name = ""
        email = ""
        AuthService.shared.isLoggedIn = false
        AuthService.shared.authToken = ""
        AuthService.shared.userEmail = ""
        MessageService.shared.clearChannels()
        MessageService.shared.clearMessages()
    }
}
