//
//  ViewController.swift
//  News App
//
//  Created by Moh. Absar Rahman on 12/1/23.
//

import UIKit
import Lottie

class InitialViewController: UIViewController {
    
    @IBOutlet weak var newsAnimation: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newsAnimation.loopMode = .playOnce
        newsAnimation.animationSpeed = 1.5
        newsAnimation.play {[weak self] _ in
            guard let self = self else { return }
            self.performSegue(withIdentifier: Constants.Routes.goToHome, sender: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.viewControllers.removeAll(where: { vc in
            vc == self
        })
    }


}

