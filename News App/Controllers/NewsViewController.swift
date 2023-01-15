//
//  NewsViewController.swift
//  News App
//
//  Created by Moh. Absar Rahman on 12/1/23.
//

import UIKit

class NewsViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedNewsList: [NewsModel] = []
    
    var selectedCategory: NewsCategory = .all
    
    var pageNumber = 1
    var totalResultCount = 0
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate func initiateFetch() {
        activityIndicator.startAnimating()
        ApiHandler.fetchAllDataBased(on: selectedCategory,pageNumber: pageNumber) { newsModels, error, totalResults in
            if let error = error {
                print("Error occurred \(error)")
                return
            }
            print(totalResults,newsModels.count, self.pageNumber)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                self.activityIndicator.stopAnimating()
                //self?.activityIndicator.hidesWhenStopped
                self.totalResultCount = totalResults
                if self.pageNumber > 1 {
                    self.selectedNewsList.append(contentsOf: newsModels)
                } else {
                    self.selectedNewsList = newsModels
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
        initiateFetch()
        
        tableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "newsTableViewCell")
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCollectionCell")
    }
    
}

extension NewsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsTableViewCell", for: indexPath) as! NewsTableViewCell
        let model = selectedNewsList[indexPath.row]
//        cell.textLabel?.text = indexPath.row.description
//        cell.detailTextLabel?.text = model.author
        cell.authorTitleLabel.text = model.author
        cell.newTitleLabel.text = model.title
        cell.dateLabel.text = model.publishedAt
        cell.sourceTitleLabel.text = model.source.name
        
        return cell
        
    }
    
    
}

extension NewsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == selectedNewsList.count - 1) && (selectedNewsList.count < totalResultCount) {
            pageNumber += 1
            initiateFetch()
        }
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
