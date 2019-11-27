//
//  SubtitleTableViewCell.swift
//  WhitehousePetitions
//
//  Created by Jeffrey Lai on 11/6/19.
//  Copyright © 2019 Jeffrey Lai. All rights reserved.
//

import UIKit

class SubtitleTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.textLabel?.numberOfLines = 0
        self.textLabel?.sizeToFit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
