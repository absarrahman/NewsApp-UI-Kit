//
//  BookmarkViewController.swift
//  News App
//
//  Created by Moh. Absar Rahman on 12/1/23.
//

import UIKit

class BookmarkViewController: UIViewController {

    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var bottomView: UIView!
    
    var selectedCategory: NewsCategory = .all
    var selectedNewsList: [BookmarkCDModel] = []
    
    fileprivate func fetchData() {
        // Do any additional setup after loading the view.
        selectedNewsList = CoreDataHandler.shared.fetchAllDataFromBookmark(categoryField: selectedCategory, queryField: searchTextField.text ?? "")
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bottomView.layer.cornerRadius = bottomView.frame.height / 2
        bottomView.clipsToBounds = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsTableViewCell")
        
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCollectionCell")
        fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.Routes.goToDetailsViewFromNews) {
            if let vc = segue.destination as? NewsDetailsViewController, let indexPath = tableView.indexPathForSelectedRow {
                let model = selectedNewsList[indexPath.row]
                vc.detailsModel = DetailsModel(newsTitle: model.newsTitle, publishedAt: model.publishedAt, sourceName: model.sourceName, content: model.content, newsDescription: model.newsDescription, url: model.url, isBookmark: true, urlToImage: model.urlToImage)
            }
        }
    }
    
}

// MARK: - COLLECTION VIEW DATASOURCE

extension BookmarkViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        NewsCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isSelectedValue = selectedCategory ==  NewsCategory.allCases[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionCell", for: indexPath) as! CategoryCollectionViewCell
        cell.buttonLabel.text = NewsCategory.allCases[indexPath.row].rawValue.capitalized
        cell.buttonSelectedStateView.alpha = isSelectedValue ? 1 : 0
        cell.bgView.alpha = isSelectedValue ? 1 : 0.5
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return cell
    }
    
    
}

// MARK: - COLLECTION VIEW DELEGATE

extension BookmarkViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedCategory == NewsCategory.allCases[indexPath.row] {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        selectedCategory = NewsCategory.allCases[indexPath.row]
        fetchData()
        collectionView.reloadData()
        tableView.reloadData()
    }
}

extension BookmarkViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableViewCell", for: indexPath) as! NewsTableViewCell
        let model = selectedNewsList[indexPath.row]
        cell.authorTitleLabel.text = model.authorName
        cell.newTitleLabel.text = model.newsTitle
        cell.dateLabel.text = "Published \(CommonFunctions.postedBefore(date: model.publishedAt)) ago"
        cell.sourceTitleLabel.text = model.sourceName
        cell.setBackgroundImageFrom(urlString: model.urlToImage ?? Constants.CommonConstants.imageNotFound)
        
        return cell
        
    }
}

extension BookmarkViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.Routes.goToDetailsViewFromNews, sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let model = selectedNewsList[indexPath.row]
        let bookmarkAction = UIContextualAction(style: .normal, title: "Bookmark") {[weak self] _, _, completion in
            // set bookmark of that index path
            guard let self = self else {
                return
            }
            
            CoreDataHandler.shared.removeBookmarkBasedOnURL(urlString: model.url!, category: self.selectedCategory)
            self.fetchData()
            completion(true)
            
        }
        bookmarkAction.image = UIImage(systemName: "bookmark.fill")
        bookmarkAction.backgroundColor = .systemYellow
        let shareAction  = UIContextualAction(style: .normal, title: "Share") {[weak self] _, _, completion in
            
            guard let self = self else { return }
            let text = model.newsTitle
            let url = URL(string: model.url!)!
            
            let activityViewController = UIActivityViewController(activityItems: [text ?? "", url], applicationActivities: nil)
            self.present(activityViewController, animated: true)
            tableView.reloadRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        shareAction.backgroundColor = .systemBlue
        shareAction.image = UIImage(systemName: "square.and.arrow.up.fill")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [bookmarkAction,shareAction])
        return swipeConfiguration
    }
}

extension BookmarkViewController : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("YEEET")
        fetchData()
//        selectedNewsList = CoreDataHandler.shared.fetchAllDataFrom(categoryField: selectedCategory,queryField: searchTextField.text ?? "")
//        tableView.reloadData()
    }
}
