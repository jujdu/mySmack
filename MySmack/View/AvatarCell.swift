//
//  AvatarCell.swift
//  MySmack
//
//  Created by Michael Sidoruk on 30.01.2020.
//  Copyright © 2020 Michael Sidoruk. All rights reserved.
//

import UIKit

enum AvatarType {
    case dark
    case light
}

class AvatarCell: UICollectionViewCell {
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.layer.backgroundColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }
    
    func configureCell(index: Int, type: AvatarType) {
        switch type {
        case .dark:
            avatarImage.image = UIImage(named: "dark\(index)")
            self.layer.backgroundColor = UIColor.lightGray.cgColor
        case .light:
            avatarImage.image = UIImage(named: "light\(index)")
            self.layer.backgroundColor = UIColor.gray.cgColor
        }
    }
}
