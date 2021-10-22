//
//  RecipeTableViewController.swift
//  Reciplease
//
//  Created by Ludovic DANGLOT on 28/09/2021.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDataSource {
    
    // MARK: - @IB Outlet

    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIBarButtonItem!
    
    // MARK: - Properties
    
    var recipeInfo : Recipe?
    private var coreDataManager: CoreDataManager?
    
    // MARK: - Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = recipeInfo?.label
        likeLabel.text = String(recipeInfo?.yield ?? 0)
        hoursLabel.text = "\(String(recipeInfo?.totalTime ?? 0)) min"
        if let stringUrl = recipeInfo?.image {
            recipeImageView.load(url: URL(string: stringUrl)!)
        } else {
            recipeImageView.image = UIImage(named: "maxresdefault")
        }
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let coredataStack = appdelegate.coreDataStack
        coreDataManager = CoreDataManager(coreDataStack: coredataStack)
        
        if let isRecipe = coreDataManager?.searchForRecipe(recipeTitle: recipeInfo?.label ?? "") {
            if isRecipe {
                favoriteButton.image = UIImage(systemName: "star.fill")
            } else {
                favoriteButton.image = UIImage(systemName: "star")
            }
        }
    }
    
    // MARK: - Table view data source
    
    @IBAction func openRecipeButton(_ sender: Any) {
        UIApplication.shared.open(URL(string: recipeInfo?.url ?? "rien")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ingredientTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeInfo?.ingredientLines.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = recipeInfo?.ingredientLines[indexPath.row]
        return cell
    }
    
    // MARK: - @IB Action
    
    @IBAction func didTappedButtonFavorite(_ sender: UIBarButtonItem) {
        guard let recipeInfo = recipeInfo else {return}
        guard let coreDataManager = coreDataManager else {return}
        
        if coreDataManager.searchForRecipe(recipeTitle: recipeInfo.label) {
            favoriteButton.image = UIImage(systemName: "star")
            coreDataManager.deleteRecipe(recipeTitle: recipeInfo.label)
        } else {
            favoriteButton.image = UIImage(systemName: "star.fill")
            coreDataManager.createFavorite(title: recipeInfo.label, hours: "\(recipeInfo.totalTime)", like: "\(recipeInfo.yield)", ingredientTable: recipeInfo.ingredientLines, recipeImage: recipeInfo.image, url: recipeInfo.url)
        }
    }
}



