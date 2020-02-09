//
//  LapTableViewCell.swift
//  Stopwatch
//
//  Created by Ashkan Amin on 1/18/20.
//  Copyright © 2020 Ashkan Amin. All rights reserved.
//

import UIKit

class LapTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var lapCounterLabel: UILabel!
    
    @IBOutlet weak var lapsTimeLabel: UILabel!
    @IBOutlet weak var orginalTime: UILabel!
}
