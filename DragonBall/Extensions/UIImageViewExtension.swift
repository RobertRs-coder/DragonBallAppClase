//
//  UIImageViewExtension.swift
//  DragonBall
//
//  Created by Roberto Rojo Sahuquillo on 28/7/22.
//

import UIKit

typealias ImageCompletion = (UIImage?) -> Void

extension UIImageView {
    
    // Creamos una funcion para setear la imagen desde una url
    func setImage(url: URL) {
        // Llamamos a la funcion creada para descargar la imagen de una url y le pasamos los argumentos
        downloadImageWithUrlSession(url: url) { [weak self] image in
            // Lo mandamos al hilo principal porque task queda en background
            DispatchQueue.main.sync {
                // Asigmamos el valor de la imagen
                self?.image = image
            }
        }
    }
    
    // Creamos una funcion para descargar la imagen de una url
    private func downloadImageWithUrlSession(url: URL, completion: ImageCompletion?) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                completion?(nil)
                return
            }
            completion?(image)
        }.resume() // Without resume, we can't do the task
    }
}
