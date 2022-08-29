//
//  LoginViewController.swift
//  DragonBall
//
//  Created by Roberto Rojo Sahuquillo on 25/7/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loginButton.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Si tiene el token salta la pantalla de login
        if LocalDataModel.getToken() != nil {
            performSegue(withIdentifier: "AuthSegue", sender: nil)
        } else {
            userTextField.center.x -= view.bounds.width
            passwordTextField.center.x -= view.bounds.width
            
            UIView.animate(withDuration: 0.75,
                           delay: 0.5,
                           usingSpringWithDamping: 0.75,
                           initialSpringVelocity: 0,
                           options: []) {
                self.userTextField.center.x += self.view.bounds.width
            }
            UIView.animate(withDuration: 0.75,
                           delay: 0.3,
                           usingSpringWithDamping: 0.75,
                           initialSpringVelocity: 0,
                           options: []) {
                self.passwordTextField.center.x += self.view.bounds.width
            }
            UIView.animate(withDuration: 1) {
                self.loginButton.alpha = 1
            }
        }
    }
    // Pulsamos el boton
    @IBAction func onLoginTap(_ sender: Any) {
        // Utilizamos la instancia 
//        let model = NetworkModel.shared
        let model = NetworkModel()
        let user = userTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        // Comprobamos que user y password no esten vacios antes de las animacions de boton y activity sino se queda en infinito
        guard !user.isEmpty, !password.isEmpty else {
//            let alert = UIAlertController(title: "Missing fields", message: "Please complete all fields", preferredStyle: .alert)
//            let alertAction = UIAlertAction(title: "Ok", style: .default)
//            alert.addAction(alertAction)
//            self.present(alert, animated: true)
//            return
            self.showAlert(title: "Missing fields", message: "Please complete all fields")
            return
            
        }
        
        //Desactivamos el boton
        loginButton.isEnabled = false
        //Activamos el activityIndicator
        activityIndicator.startAnimating()
        
        // Pasamos user y password al network model
        model.login(user: user, password: password) { [weak self] /* Evitar retain cycle del controller */ token , error in
            // La funcion login nos devuelve el token
            // print(token)
//            // Desempaquetamos el token y comprobamos que no sea vacio
//            guard let token = token, !token.isEmpty  else { return }
            
            // Mandamos a la cola del hilo principal, neceario para cambios en la UI
            DispatchQueue.main.sync {
                //Activamos el boton
                self?.loginButton.isEnabled = true
                //desactivamos el activityIndicator
                self?.activityIndicator.stopAnimating()
                
                if let error = error {
//                    let alert = UIAlertController(title: "There was an error", message: error.localizedDescription, preferredStyle: .alert)
//                    let alertAction = UIAlertAction(title: "Ok", style: .default)
//                    alert.addAction(alertAction)
//                    self?.present(alert, animated: true)
                    self?.showAlert(title: "There was an error", message: error.localizedDescription)
                    return
                }
                
                // Desempaquetamos el token y comprobamos que no sea vacio, dentro del dispatch y antes del segue sino se queda pillado
                guard let token = token, !token.isEmpty  else {
//                    let alert = UIAlertController(title: "There is no token", message: "", preferredStyle: .alert)
//                    let alertAction = UIAlertAction(title: "Ok", style: .default)
//                    alert.addAction(alertAction)
//                    self?.present(alert, animated: true)
                    self?.showAlert(title: "There is no token")
                    return
                }
                LocalDataModel.save(token: token)
                // Realizamos un segue con identficador
                self?.performSegue(withIdentifier: "AuthSegue", sender: nil)

            }
        }
    }
    
}
