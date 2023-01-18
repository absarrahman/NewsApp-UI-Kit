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
    
    
    var selectedCategory: NewsCategory = .all
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "customCollectionCell")
    }
    
}

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
extension BookmarkViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if selectedCategory == NewsCategory.allCases[indexPath.row] {
            collectionView.deselectItem(at: indexPath, animated: true)
            return
        }
        selectedCategory = NewsCategory.allCases[indexPath.row]
        collectionView.reloadData()
    }
}
