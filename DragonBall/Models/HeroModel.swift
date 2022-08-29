//
//  HeroModel.swift
//  DragonBall
//
//  Created by Roberto Rojo Sahuquillo on 28/7/22.
//

import UIKit

//Creamos un struct de hero
//struct Hero {
//    let image: UIImage
//    let name: String
//    let despcription: String
//}

// Creamos un nuevo struct igual a la respuesta de la API Rest Dragon Ball
struct Hero: Decodable{
    let id: String
    let name: String
    let description: String
    let photo: URL
    let favorite: Bool
}

