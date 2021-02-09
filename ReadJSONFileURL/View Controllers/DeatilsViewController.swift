//
//  DeatilsViewController.swift
//  DemoProject
//
//  Created by AryaOmnitalk MDA on 09/02/21.
//  Copyright © 2021 ProgrammingWithSwift. All rights reserved.
//

import UIKit

class DeatilsViewController: UIViewController {
    
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var bookTitleLabel: UILabel!
    
    var selectedBookName: String?
    var selectedBookDescription: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Book Details View"
        bookTitleLabel.text = selectedBookName
        descriptionLabel.text = selectedBookDescription
    }
    
    
    
    
}
