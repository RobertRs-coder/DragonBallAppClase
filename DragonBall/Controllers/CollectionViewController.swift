//
//  CollectionViewController.swift
//  DragonBall
//
//  Created by Roberto Rojo Sahuquillo on 10/8/22.
//

import UIKit

private let reuseIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    var heroes: [Hero] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

//        // Register cell classes - not found defualt for storyboard creation
//        self.collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // If we generate XIB manually
        collectionView?.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        
        
        guard let token = LocalDataModel.getToken() else {return}
        // Network call
//        let networkModel = NetworkModel.shared
        
        let networkModel = NetworkModel(token: token)
        
        networkModel.getHeroes { [weak self] heroes, _ in
            self?.heroes = heroes
            
            DispatchQueue.main.async{
                self?.collectionView.reloadData()
            }
            
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return heroes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        (cell as? CollectionViewCell)?.set(model: heroes[indexPath.row])
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Create next controller
        let nextViewController = DetailViewController()
        // Set model with hero
        nextViewController.set(model: heroes[indexPath.row])
        
        // Create Navigation controller with the next controller
        navigationController?.pushViewController(nextViewController, animated: true)
     }
}



extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Set width divide in 2 columns with margin y height fix
        
        return CGSize (width: (collectionView.frame.width / 2 ) - 6 , height: 140.0)
    }
    
}
