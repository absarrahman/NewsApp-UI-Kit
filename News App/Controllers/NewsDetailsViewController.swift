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
    
    @IBOutlet weak var newsImageheightConstraint: NSLayoutConstraint!
    
    var newsModel: NewsCDModel!
    
    private var lastContentOffset: CGFloat = 0
    
    @IBOutlet weak var scrollView: UIScrollView!
    
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
        
        newsImageView.sd_setImage(with: URL(string: newsModel.urlToImage ?? Constants.CommonConstants.imageNotFound), placeholderImage: nil, options: [.progressiveLoad])
        
        scrollView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier ==  Constants.Routes.goToBrowserView) {
            let vc = segue.destination as! BrowserViewController
            vc.urlString = newsModel.url
        }
    }
    
}

extension NewsDetailsViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (self.lastContentOffset > scrollView.contentOffset.y) {
            // move up
            print("UP")
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            // move down
            print("DOWN")
        }
        
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
        print(lastContentOffset)
        
        UIView.animate(withDuration: 0, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.newsImageheightConstraint.constant = self.lastContentOffset
        }
        
        
        
        //        let maximumOffset = scrollView.contentSize.height - scrollView.frame.height
        //        print("MAX OFFSET \(maximumOffset)",scrollView.contentSize.height, scrollView.frame.height)
        //        if scrollView.contentOffset.y >= maximumOffset {
        //            scrollView.contentOffset.y = maximumOffset
        //            print("SCROLL EVENT OFFSET \(scrollView.contentOffset.y)")
        //        }
        ////
        ////        UIView.animate(withDuration: 0, delay: 0) {
        ////            //heightConstraint.constant =
        ////        }
        
    }
}
