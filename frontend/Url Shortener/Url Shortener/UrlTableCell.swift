//
//  UrlTableCell.swift
//  Url Shortener
//
//  Created by Michael Peterson on 11/14/15.
//  Copyright © 2015 Michael Peterson. All rights reserved.
//

import UIKit

class UrlTableCell: UITableViewCell {
    
    @IBOutlet weak var originalUrlLabel: UILabel!
    @IBOutlet weak var clickCountLabel: UILabel!
    @IBOutlet weak var shortUrlLabel: UILabel!
    
    
    
    func setUrl(url: Url, baseUrl: String) {
        shortUrlLabel.text = "\(baseUrl)/\(url.shortUrl)"
        originalUrlLabel.text = url.originalUrl
        clickCountLabel.text = url.numClicks.description
    }
}