//
//  ChannelCell.swift
//  MySmack
//
//  Created by Michael Sidoruk on 31.01.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    @IBOutlet weak var channelLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.backgroundColor = UIColor(white: 1, alpha: 0.2)
        } else {
            self.backgroundColor = UIColor.clear
        }
    }
    
    func configureCell(channel: Channel) {
        let title = channel.channelTitle
        channelLbl.text = "#\(title)"
    }

}
