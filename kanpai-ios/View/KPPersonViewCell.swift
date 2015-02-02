//
//  KPPersonViewCell.swift
//  kanpai-ios
//
//  Created by Noda Shimpei on 2015/02/01.
//  Copyright (c) 2015年 kanpai. All rights reserved.
//

import UIKit

class KPPersonViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var checkBox: UIImageView?
    @IBOutlet var thumbnail: UIImageView? {
        didSet {
            self.thumbnail?.layer.masksToBounds = true;
            self.thumbnail?.layer.cornerRadius = 20;
        }
    }
    
    func setThumbnail(thumbnail: UIImage?) {
        if let image = thumbnail {
            self.thumbnail?.image = image
        } else {
            self.thumbnail?.image = UIImage(named: "icon-avatar-60x60")
        }
    }
    
    func setCheckBok(checked: Bool) {
        if checked {
            self.checkBox?.image = UIImage(named: "icon-checkbox-selected-green-25x25")
        } else {
            self.checkBox?.image = UIImage(named: "icon-checkbox-unselected-25x25")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
