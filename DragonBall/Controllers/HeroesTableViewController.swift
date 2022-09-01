//
//  HeroesTableViewController.swift
//  DragonBall
//
//  Created by Roberto Rojo Sahuquillo on 26/7/22.
//

import UIKit

class HeroesTableViewController: UITableViewController {
    
    var heroes: [Hero] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView?.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifier")
        
        tableView?.register(UINib(nibName: "SecondTableViewCell", bundle: nil), forCellReuseIdentifier: "cell2")
        
        
        guard let token = LocalDataModel.getToken() else {return}
        // Network call
//        let networkModel = NetworkModel.shared
        
        let networkModel = NetworkModel(token: token)
        
        networkModel.getHeroes { [weak self] heroes, _ in
            self?.heroes = heroes
            
            DispatchQueue.main.async{
                self?.tableView.reloadData()
            }
            
        }
    }

    
    
    // Uncomment and give cell with identifier
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row % 2 == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? TableViewCell else{
                return UITableViewCell()
            }
            // Configure the cell
            cell.set(model: heroes[indexPath.row])
            
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as? SecondTableViewCell else{
                let cell = UITableViewCell()
                
                var content = cell.defaultContentConfiguration()
                content.text = "Title"
                cell.contentConfiguration = content
                
                return UITableViewCell()
                
                
                
            }

            cell.label.text = heroes[indexPath.row].name
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // Creamos un hero completo de prueba
//        let hero = Hero(
//          id: "14BB8E98-6586-4EA7-B4D7-35D6A63F5AA3",
//          name: "Maestro Roshi",
//          description: "Es un maestro de artes marciales que tiene una escuela, donde entrenará a Goku y Krilin para los Torneos de Artes Marciales. Aún en los primeros episodios había un toque de tradición y disciplina, muy bien representada por el maestro. Pero Muten Roshi es un anciano extremadamente pervertido con las chicas jóvenes, una actitud que se utilizaba en escenas divertidas en los años 80. En su faceta de experto en artes marciales, fue quien le enseñó a Goku técnicas como el Kame Hame Ha",
//          photo: URL(string: "https://cdn.alfabetajuega.com/alfabetajuega/2020/06/dragon-ball-satan.jpg?width=300")!,
//          favorite: false)
        
        // Create next controller
        let nextViewController = DetailViewController()
        // Set model with hero
        nextViewController.set(model: heroes[indexPath.row])
        
        // Create Navigation controller with the next controller
        navigationController?.pushViewController(nextViewController, animated: true)
     }
    
}

// MARK: - Table view data source

extension HeroesTableViewController{
    

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return heroes.count
    }

}
