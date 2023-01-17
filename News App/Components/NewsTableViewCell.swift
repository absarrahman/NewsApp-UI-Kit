//
//  NewsTableViewCell.swift
//  News App
//
//  Created by BJIT  on 13/1/23.
//

import UIKit

import SDWebImage

class NewsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var sourceTitleLabel: UILabel!
    
    
    @IBOutlet weak var newTitleLabel: UILabel!
    
    
    @IBOutlet weak var authorTitleLabel: UILabel!
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
        contentView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setBackgroundImageFrom(urlString: String) {
        backgroundImageView.sd_setImage(with: URL(string: urlString), placeholderImage: nil, options: [.progressiveLoad])
    }
    
}
