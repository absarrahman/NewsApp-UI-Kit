//
//  NewsViewController.swift
//  News App
//
//  Created by Moh. Absar Rahman on 12/1/23.
//

import UIKit

class NewsViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var selectedNewsList: [NewsModel] = []
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        activityIndicator.startAnimating()
        ApiHandler.fetchAllData { newsModels in
            DispatchQueue.main.async { [weak self] in
                self?.activityIndicator.stopAnimating()
                //self?.activityIndicator.hidesWhenStopped
                self?.selectedNewsList = newsModels
                self?.tableView.reloadData()
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
