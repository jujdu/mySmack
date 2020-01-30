//
//  Constants.swift
//  MySmack
//
//  Created by Michael Sidoruk on 29.01.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

//url

let BASE_URL = "https://mysmacky.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"

struct AppSegues {
    static let toLogin = "toLogin"
    static let toCreateAccount = "toCreateAccount"
    static let unwindToChannel = "unwindToChannel"
}

//User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"
