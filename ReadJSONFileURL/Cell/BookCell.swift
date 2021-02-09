//
//  BookCell.swift
//  DemoProject
//
//  Created by AryaOmnitalk MDA on 09/02/21.
//  Copyright © 2021 ProgrammingWithSwift. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {

    @IBOutlet var bookIdLabel: UILabel!
    @IBOutlet var bookNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
