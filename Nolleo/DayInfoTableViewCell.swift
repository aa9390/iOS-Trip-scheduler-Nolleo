//
//  DayInfoTableViewCell.swift
//  Nolleo
//
//  Created by SWUCOMPUTER on 2018. 6. 16..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class DayInfoTableViewCell: UITableViewCell {

    @IBOutlet var labelPlace: UILabel!
    @IBOutlet var labelTime: UILabel!
    @IBOutlet var labelMemo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
