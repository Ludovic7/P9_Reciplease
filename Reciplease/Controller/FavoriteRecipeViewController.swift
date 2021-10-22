//
//  FavoriteRecipeViewController.swift
//  Reciplease
//
//  Created by Ludovic DANGLOT on 07/10/2021.
//

import UIKit

class FavoriteRecipeViewController: UIViewController, UITableViewDataSource {
    
    // MARK: - @IB Outlet

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    var recipeInfo : Favorite?
    private var coreDataManager: CoreDataManager?
    let cellRecipe = "RecipeTableViewCell"

    // MARK: - Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = recipeInfo?.title
        likeLabel.text = recipeInfo?.like
        hoursLabel.text = "\(recipeInfo?.hours ?? "0") min"
        if let stringUrl = recipeInfo?.recipeImage {
            recipeImageView.load(url: URL(string: stringUrl)!)
        } else {
            recipeImageView.image = UIImage(named: "maxresdefault")
        }
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coredataStack)
        
        if let isRecipe = coreDataManager?.searchForRecipe(recipeTitle: recipeInfo?.title ?? "") {
            if isRecipe {
                favoriteButton.image = UIImage(systemName: "star.fill")
            } else {
                favoriteButton.image = UIImage(systemName: "star")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ingredientTableView.reloadData()
    }

    // MARK: - Methodes
 
    func numberOfSections(in tableView: UITableView) -> Int {
       return 1
   }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let table = recipeInfo?.ingredientTable else {return 0}
        return table.count
   }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableCell", for: indexPath)
        cell.textLabel?.text = recipeInfo?.ingredientTable?[indexPath.row]
        return cell
    }
    
    // MARK: - @IB Action
    
    @IBAction func didTappedButtonFavoriteToDelete(_ sender: UIBarButtonItem) {
        guard let recipeInfo = recipeInfo else {return}
        guard let coreDataManager = coreDataManager else {return}
        
        navigationController?.popToRootViewController(animated: true)
        favoriteButton.image = UIImage(systemName: "star")
        coreDataManager.deleteRecipe(recipeTitle: recipeInfo.title!)
        
    }
    
}
