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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    fileprivate func initiateFetch() {
        activityIndicator.startAnimating()
        ApiHandler.fetchAllDataBased(on: selectedCategory) { newsModels, error in
            if let error = error {
                print("Error occurred \(error)")
                return
            }
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                //self?.activityIndicator.hidesWhenStopped
                self?.selectedNewsList = newsModels
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        collectionView.dataSource = self
        initiateFetch()
        
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCollectionCell")
    }
    
}

extension NewsViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let model = selectedNewsList[indexPath.row]
        cell.textLabel?.text = model.title
        cell.detailTextLabel?.text = model.author
        return cell
    }
    
    
}


// MARK: - Collection View Datasource

extension NewsViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        NewsCategory.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isSelectedValue = indexPath.row == 1
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCollectionCell", for: indexPath) as! CategoryCollectionViewCell
        cell.buttonLabel.text = "Yeet"
        cell.buttonSelectedStateView.alpha = isSelectedValue ? 1 : 0
        cell.layer.cornerRadius = 20
        cell.clipsToBounds = true
        cell.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return cell
    }
    
    
}
