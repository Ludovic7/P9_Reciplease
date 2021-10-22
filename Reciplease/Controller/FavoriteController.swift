//
//  FavoriteController.swift
//  Reciplease
//
//  Created by Ludovic DANGLOT on 05/10/2021.
//

import UIKit

class FavoriteController: UITableViewController {
    
    // MARK: - Properties
    
    private var coreDataManager: CoreDataManager?
    let cellRecipe = "RecipeTableViewCell"
    var recipeFavorite : Favorite?
   
    // MARK: - Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coredataStack)
        tableView.register(UINib(nibName: cellRecipe, bundle:
                                    nil), forCellReuseIdentifier: cellRecipe)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Methodes
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

 override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return coreDataManager?.favorites.count ?? 0
}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellRecipe, for: indexPath) as? RecipeTableViewCell else {
        return UITableViewCell()
    }
     cell.recipeFavorite = coreDataManager?.favorites[indexPath.row]
    
    return cell
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "FavoriteRecipeViewController" {
                let favoriteTableViewController = segue.destination as! FavoriteRecipeViewController
                favoriteTableViewController.recipeInfo = recipeFavorite
            }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        recipeFavorite = coreDataManager?.favorites[indexPath.row]
        performSegue(withIdentifier: "FavoriteRecipeViewController", sender: cell)
    }
}
