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
    
    @IBOutlet weak var newViewHeightConstraint: NSLayoutConstraint!
    
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
            UIView.animate(withDuration: 0, delay: 0) { [weak self] in
                guard let self = self else { return }
                if (self.newViewHeightConstraint.constant != 0) {
                    self.newViewHeightConstraint.constant -= 1
                }
                print("FRAME \(self.newsDetailsView.frame.height)")
            }
        }
        else if (self.lastContentOffset < scrollView.contentOffset.y) {
            // move down
            print("DOWN")
            UIView.animate(withDuration: 0, delay: 0) { [weak self] in
                guard let self = self else { return }
                let newsDetailsFrameHeight = self.newsDetailsView.frame.height
                let safeAreHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
                if (newsDetailsFrameHeight <= safeAreHeight) {
                    self.newViewHeightConstraint.constant += 1
                }
                print("FRAME \(self.newsDetailsView.frame.height)")
            }
        }
        
        // update the new position acquired
        self.lastContentOffset = scrollView.contentOffset.y
        print(lastContentOffset)
        
        UIView.animate(withDuration: 0, delay: 0) { [weak self] in
            guard let self = self else { return }
            self.newsImageheightConstraint.constant = self.lastContentOffset
       
        }
    }
}
