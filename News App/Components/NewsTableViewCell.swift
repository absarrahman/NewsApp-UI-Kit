//
//  NewsTableViewCell.swift
//  News App
//
//  Created by BJIT  on 13/1/23.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var sourceTitleLabel: UILabel!
    
    
    @IBOutlet weak var newTitleLabel: UILabel!
    
    
    @IBOutlet weak var authorTitleLabel: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
