//
//  NewsViewController.swift
//  News App
//
//  Created by Moh. Absar Rahman on 12/1/23.
//

import UIKit

class NewsViewController: UIViewController {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let refreshControl = UIRefreshControl()

    @IBOutlet weak var bottomView: UIView!
    
    //var selectedNewsList: [NewsModel] = []
    var selectedNewsList: [NewsCDModel] = []
    
    var selectedCategory: NewsCategory = .all
    
    var pageNumber = 1
    var totalResultCount = 0
    var timeDifference = 0
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate func initiateFetch() {
        activityIndicator.startAnimating()
        view.isUserInteractionEnabled = false
        
        let storedPageNumber = UserDefaults.standard.integer(forKey: "\(Constants.UserDefaultConstants.pageNumber).\(selectedCategory.rawValue)")
        
        // IMPLEMENTATION
        // CHECK whether the distance is less than or = 0
        // if true then remove data, set pagenumber to 0 and start fetching
        // else retrieve from Core data
        let fetchedTimeInterval = UserDefaults.standard.double(forKey: Constants.UserDefaultConstants.lastUpdatedTimeInterval)
        
        print("FETCHED INTERVAL \(fetchedTimeInterval)")
        
//      Fetched time interval will never be zero. If zero then it means the user is new
        if (fetchedTimeInterval != 0) {
            let fetchedDate = Date(timeIntervalSince1970: fetchedTimeInterval)
            let currentDate = Date()
            let difference = Calendar.current.dateComponents([.second], from: currentDate, to: fetchedDate)
            timeDifference = difference.second!
            print("TIME difference \(difference)")
        }
        print("TIME difference global \(timeDifference)")
        if (timeDifference <= 0) {
            print("REMOVING DATA. TIME DIFF: \(timeDifference)")
            CoreDataHandler.shared.removeAllData {
                selectedNewsList = []
            }
        }
        
        if (CoreDataHandler.shared.isEmpty(category: selectedCategory) || storedPageNumber < pageNumber) {
            
            if (pageNumber == 1 && timeDifference <= 0) {
                let date = Date() // current date and time
                let minute = Constants.CommonConstants.refreshMinuteInterval
                let storeDate = date.addingTimeInterval(minute*60)
                let timeInterval = storeDate.timeIntervalSince1970
                print("PAGE NUMBER \(pageNumber) \(timeInterval)")
                UserDefaults.standard.setValue(timeInterval, forKey: Constants.UserDefaultConstants.lastUpdatedTimeInterval)
            }
            
            ApiHandler.fetchAllDataBased(on: selectedCategory,pageNumber: pageNumber) { [weak self] result, totalResults in
                switch(result) {
                case .success(let newsModels):
                    guard let self = self else {
                        return
                    }
                    print(totalResults,newsModels.count, self.pageNumber)
                    UserDefaults.standard.set(self.pageNumber, forKey: "\(Constants.UserDefaultConstants.pageNumber).\(self.selectedCategory.rawValue)")
                    DispatchQueue.main.async { [weak self] in
                        guard let self = self else {
                            return
                        }
                        let newsCDModels = CoreDataHandler.shared.addDataToCoreDataFrom(apiModels: newsModels, category: self.selectedCategory)
                        self.activityIndicator.stopAnimating()
                        self.totalResultCount = totalResults
                        if self.pageNumber > 1 {
                            //self.selectedNewsList.append(contentsOf: newsModels)
                            self.selectedNewsList.append(contentsOf: newsCDModels)
                        } else {
                            self.selectedNewsList = newsCDModels
                        }
                        self.view.isUserInteractionEnabled = true
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error occurred \(error)")
                    let alertController = UIAlertController(title: "Failed", message: "Failed to fetch data. Please try again", preferredStyle: .alert)
                    
    
                    let saveAction = UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
                        guard let self = self else {
                            return
                        }
                        self.initiateFetch()
                    }
                    
                    
                    alertController.addAction(saveAction)

                    DispatchQueue.main.async {[weak self] in
                        guard let self = self else {
                            return
                        }
                        self.present(alertController, animated: true)
                    }
                }
                //            if let error = error {
                //                print("Error occurred \(error)")
                //                return
                //            }
                //            print(totalResults,newsModels.count, self.pageNumber)
                //            DispatchQueue.main.async { [weak self] in
                //                guard let self = self else {
                //                    return
                //                }
                //                self.activityIndicator.stopAnimating()
                //                //self?.activityIndicator.hidesWhenStopped
                //                self.totalResultCount = totalResults
                //                if self.pageNumber > 1 {
                //                    self.selectedNewsList.append(contentsOf: newsModels)
                //                } else {
                //                    self.selectedNewsList = newsModels
                //                }
                //
                //                self.tableView.reloadData()
                //            }
            }
        } else {
            self.activityIndicator.stopAnimating()
            selectedNewsList = CoreDataHandler.shared.fetchAllDataFrom(categoryField: selectedCategory,queryField: searchTextField.text ?? "")
            view.isUserInteractionEnabled = true
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        searchTextField.delegate = self
        
        bottomView.layer.cornerRadius = bottomView.frame.height / 2
        bottomView.clipsToBounds = true
        
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        //initiateFetch()
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsTableViewCell")
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCollectionCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        initiateFetch()
    }
    
    @objc func refreshData() {
        CoreDataHandler.shared.removeAllData {
            selectedNewsList = []
            tableView.reloadData()
        }
        UserDefaults.standard.set(0, forKey: "\(Constants.UserDefaultConstants.pageNumber).\(selectedCategory.rawValue)")
        UserDefaults.standard.set(0, forKey: Constants.UserDefaultConstants.lastUpdatedTimeInterval)
        initiateFetch()
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Constants.Routes.goToDetailsViewFromNews) {
            if let vc = segue.destination as? NewsDetailsViewController, let indexPath = tableView.indexPathForSelectedRow {
                let model = selectedNewsList[indexPath.row]
                vc.newsModel = model
                vc.detailsModel = DetailsModel(newsTitle: model.newsTitle, publishedAt: model.publishedAt, sourceName: model.sourceName, content: model.content, newsDescription: model.newsDescription, url: model.url, isBookmark: CoreDataHandler.shared.isBookmarkAvailableForThat(news: model), urlToImage: model.urlToImage)
            }
        }
    }
    
    
}

extension NewsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableViewCell", for: indexPath) as! NewsTableViewCell
        
        let model = selectedNewsList[indexPath.row]
        let isBookmark = CoreDataHandler.shared.isBookmarkAvailableForThat(news: model)
        cell.authorTitleLabel.text = model.authorName
        cell.newTitleLabel.text = model.newsTitle
        //cell.dateLabel.text = model.publishedAt
        cell.dateLabel.text = "Published \(CommonFunctions.postedBefore(date: model.publishedAt)) ago"
        cell.sourceTitleLabel.text = model.sourceName
        cell.bookmarkImageView.tintColor = isBookmark ? .white : .opaqueSeparator
        cell.setBackgroundImageFrom(urlString: model.urlToImage ?? Constants.CommonConstants.imageNotFound)
        
        return cell
        
    }
    
    
}


// MARK: - TABLEVIEW DELEGATE

extension NewsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == selectedNewsList.count - 1) && (selectedNewsList.count < totalResultCount) {
            pageNumber += 1
            initiateFetch()
        }
    }
    
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
            
            if (model.isBookmarkEnabled) {
                CoreDataHandler.shared.removeBookmarkBasedOnURL(urlString: model.url!, category: self.selectedCategory)
            } else {
                guard let bookmarkData = CoreDataHandler.shared.addNewsToBookmark(news: model, category: self.selectedCategory) else {
                    return
                }
                print("SUCCESSFULLY ADDED BOOKMARK \(bookmarkData.authorName)")
            }
            model.isBookmarkEnabled = !model.isBookmarkEnabled
            tableView.reloadRows(at: [indexPath], with: .automatic)
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

// MARK: - Collection View Datasource

extension NewsViewController : UICollectionViewDataSource {
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

// MARK: - Collection View Delegate

extension NewsViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedCategory == NewsCategory.allCases[indexPath.row] {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        pageNumber = 1
        selectedCategory = NewsCategory.allCases[indexPath.row]
        initiateFetch()
        collectionView.reloadData()
    }
}

extension NewsViewController : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("YEEET")
        initiateFetch()
//        selectedNewsList = CoreDataHandler.shared.fetchAllDataFrom(categoryField: selectedCategory,queryField: searchTextField.text ?? "")
//        tableView.reloadData()
    }
}
