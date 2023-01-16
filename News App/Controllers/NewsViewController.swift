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

    
    //var selectedNewsList: [NewsModel] = []
    var selectedNewsList: [NewsCDModel] = []
    
    var selectedCategory: NewsCategory = .all
    
    var pageNumber = 1
    var totalResultCount = 0
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate func initiateFetch() {
        activityIndicator.startAnimating()
        
        let storedPageNumber = UserDefaults.standard.integer(forKey: "pageNumber.\(selectedCategory.rawValue)")
        
        if (CoreDataHandler.shared.isEmpty || storedPageNumber < pageNumber) {
            
            ApiHandler.fetchAllDataBased(on: selectedCategory,pageNumber: pageNumber) { [weak self] result, totalResults in
                switch(result) {
                case .success(let newsModels):
                    guard let self = self else {
                        return
                    }
                    print(totalResults,newsModels.count, self.pageNumber)
                    UserDefaults.standard.set(self.pageNumber, forKey: "pageNumber.\(self.selectedCategory.rawValue)")
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
                        
                        self.tableView.reloadData()
                    }
                case .failure(let error):
                    print("Error occurred \(error)")
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
        
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)

        initiateFetch()
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsTableViewCell")
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCollectionCell")
    }
    
    @objc func refreshData() {
        CoreDataHandler.shared.removeAllData {
            selectedNewsList = []
            tableView.reloadData()
        }
        UserDefaults.standard.set(0, forKey: "pageNumber.\(self.selectedCategory.rawValue)")
        initiateFetch()
        refreshControl.endRefreshing()
    }
    
    
}

extension NewsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableViewCell", for: indexPath) as! NewsTableViewCell
        let model = selectedNewsList[indexPath.row]
        cell.authorTitleLabel.text = model.authorName
        cell.newTitleLabel.text = model.newsTitle
        cell.dateLabel.text = model.publishedAt
        cell.sourceTitleLabel.text = model.sourceName
        
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
        performSegue(withIdentifier: "goToNextView", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
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
