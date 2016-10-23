//
//  MedsTableViewCell.swift
//  Medchat
//
//  Created by Srihari Mohan on 6/17/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import UIKit

class MedsTableViewCell: UITableViewCell {
    @IBOutlet weak var medType: UILabel!
    @IBOutlet weak var doseLab: UILabel!
    @IBOutlet weak var freqLab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
