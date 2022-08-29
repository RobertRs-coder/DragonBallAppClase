//
//  DetailViewController.swift
//  DragonBall
//
//  Created by Roberto Rojo Sahuquillo on 26/7/22.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    
    private var hero: Hero?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let hero = hero else {
            return
        }
        
        self.title = hero.name
        
        
//        self.imageView.image = hero.photo
        self.imageView.setImage(url: hero.photo)
        self.nameLabel.text = hero.name
        self.descriptionTextView.text = hero.description

    }
    
    func set(model: Hero) {
        hero = model
    }
}
