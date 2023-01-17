//
//  NewsDetailsViewController.swift
//  News App
//
//  Created by Moh. Absar Rahman on 17/1/23.
//

import UIKit
import SDWebImage

class NewsDetailsViewController: UIViewController {

    @IBOutlet weak var newsDetailsView: UIView!
    
    
    @IBOutlet weak var newsImageView: UIImageView!
    
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var sourceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBOutlet weak var contentDetailsLabel: UILabel!
    
    
    var newsModel: NewsCDModel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsDetailsView.layer.cornerRadius = 20
        newsDetailsView.clipsToBounds = true
        newsDetailsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        newsTitleLabel.text = newsModel.newsTitle
        dateLabel.text = newsModel.publishedAt
        sourceLabel.text = newsModel.sourceName
        contentDetailsLabel.text = newsModel.content
        descriptionLabel.text = newsModel.newsDescription
        
        newsImageView.sd_setImage(with: URL(string: newsModel.urlToImage ?? "https://via.placeholder.com/300/09f/fff.png?text=Image+not+found"), placeholderImage: nil, options: [.progressiveLoad])
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier ==  Constants.Routes.goToBrowserView) {
            let vc = segue.destination as! BrowserViewController
            vc.urlString = newsModel.url
        }
    }
    

}
