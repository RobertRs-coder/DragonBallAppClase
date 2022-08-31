//
//  DetailViewController.swift
//  DragonBall
//
//  Created by Roberto Rojo Sahuquillo on 26/7/22.
//

import UIKit

private enum Constants {
    static normalImageHeight = 200.0
}

class DetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var hero: Hero?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scrollView.delegate = self
        
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


extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let correctedOffset = scrollView.contentOffset.y + 92.0
        imageHeight.constant = Constants.normalImageHeight - correctedOffset
    }
}
