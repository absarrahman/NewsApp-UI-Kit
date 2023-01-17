//
//  BrowserViewController.swift
//  News App
//
//  Created by Moh. Absar Rahman on 17/1/23.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController {
    
    var urlString: String!
    
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: URL(string: urlString)!))
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
