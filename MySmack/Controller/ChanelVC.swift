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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.width - 60
    }
    @IBAction func loginBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: AppSegues.toLogin, sender: nil)
    }
    
}
