//
//  CollectionViewCell.swift
//  DragonBall
//
//  Created by Roberto Rojo Sahuquillo on 10/8/22.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    
    func set(model: Hero) {
        
        heroName.text = model.name
        heroImage.setImage(url: model.photo)
    }
}
