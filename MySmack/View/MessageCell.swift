//
//  MessageCell.swift
//  MySmack
//
//  Created by Michael Sidoruk on 01.02.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var userImg: CircleImage!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(message: Message) {
        messageLbl.text = message.message
        userNameLbl.text = message.userName
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = UserDataService.shared.returnUIColor(components: message.userAvatarColor)
        
        let isoDate = message.timeStamp
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        let resultDate = isoDate[...end]
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: resultDate.appending("Z"))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm d, h:mm a"
        
        if let finalDate = chatDate {
            let finalDate = dateFormatter.string(from: finalDate)
            timeStampLbl.text = finalDate
        }
    }

}
