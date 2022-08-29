//
//  SettingsViewController.swift
//  DragonBall
//
//  Created by Roberto Rojo Sahuquillo on 17/8/22.
//

import UIKit

class SettingsViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onLogOutButtonTap(_ sender: Any) {
        LocalDataModel.deleteToken()
        
        // Dismiss View without modal presemter like Xibs
        // If we used navigation controller push when logging in, we can use this to logout:
        // With animation <-
//        navigationController?.viewControllers.insert(ViewController(), at: 0)
//        navigationController?.popViewController(animated: true)
        // With animation ->
//        navigationController?.setViewControllers([ViewController()], animated: true)
        
        dismiss(animated: true)
    }
    
}
