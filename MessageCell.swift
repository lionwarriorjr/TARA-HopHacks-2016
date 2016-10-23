//
//  MessageCell.swift
//  Medchat
//
//  Created by Srihari Mohan on 6/8/16.
//  Copyright © 2016 Srihari Mohan. All rights reserved.
//

import Foundation
import UIKit

class MessageCell: UITableViewCell {
    @IBOutlet weak var senderLab: UILabel!
    @IBOutlet weak var barLab: UILabel!
    @IBOutlet weak var dateLab: UILabel!
    @IBOutlet weak var messageLab: UILabel!
    @IBOutlet weak var photoFrame: UIImageView!
}
