//
//  UIViewControllerExtension.swift
//  DragonBall
//
//  Created by Roberto Rojo Sahuquillo on 29/8/22.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String = "") {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(alertAction)
        present(alert, animated: true)
    }
}

