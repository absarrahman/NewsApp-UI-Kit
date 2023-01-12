//
//  ViewController.swift
//  News App
//
//  Created by Moh. Absar Rahman on 12/1/23.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {[weak self] in
            self?.performSegue(withIdentifier: Constants.Routes.goToHome, sender: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.viewControllers.removeAll(where: { vc in
            vc == self
        })
    }


}

