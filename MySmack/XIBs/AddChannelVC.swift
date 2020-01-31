//
//  AddChannelVC.swift
//  MySmack
//
//  Created by Michael Sidoruk on 31.01.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        // Do any additional setup after loading the view.
    }

    func setupView() {
        nameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
        descriptionTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedString.Key.foregroundColor: smackPurplePlaceholder])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closetap(_:)))
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc func closetap(_ gesture: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func createPressed(_ sender: Any) {
        guard
            let name = nameTxt.text, nameTxt.text != "",
            let desc = descriptionTxt.text, descriptionTxt.text != "" else { return }
        SocketService.shared.addChannel(channelName: name, channelDescription: desc) { (success) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
