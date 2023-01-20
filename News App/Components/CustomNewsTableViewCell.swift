//
//  CustomNewsTableViewCell.swift
//  News App
//
//  Created by Moh. Absar Rahman on 20/1/23.
//

import UIKit

class CustomNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    @IBOutlet weak var sourceTitleLabel: UILabel!
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    
    
    @IBOutlet weak var authorTitleLabel: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var bookmarkImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBackgroundImageFrom(urlString: String) {
        backgroundImageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil, options: [.progressiveLoad])
    }
    
    
}
