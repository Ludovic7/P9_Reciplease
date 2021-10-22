//
//  ViewController.swift
//  Reciplease
//
//  Created by Ludovic DANGLOT on 20/09/2021.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - @IB Outlet
 
    @IBOutlet weak var addIngredientsTextField: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!
    private var coreDataManager: CoreDataManager?
    
    // MARK: - Properties
    
    var recipe : RecipeList?
    var table = [String]()
    private let service = RecipeService()
    
    // MARK: - Initializer
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ingredientTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TableViewController" {
            let viewController = segue.destination as! TableViewController
            viewController.recipeList = recipe
        }
    }
    
    // MARK: - @IB Action
    
    @IBAction func addIngredients() {
        if addIngredientsTextField.text != "" {
            let ingredientsTable = (addIngredientsTextField.text?.components(separatedBy: ","))!
        for element in ingredientsTable {
            table.append(element)
        }
        ingredientTableView.reloadData()
        } else {
            didAlert(message: "C'est vide")
        }
    }
    
    @IBAction func clearIngredientsButton(_ sender: Any) {
        table = []
        ingredientTableView.reloadData()
    }
    
    @IBAction func searchForRecipeButton(_ sender: Any) {
        service.getData(textToSearch: table.joined(separator: ",")) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data) :
                    if data.hits.isEmpty {
                        self?.didAlert(message: "Aucun ingredient valable")
                    }else{
                    self?.recipe = data
                    self?.performSegue(withIdentifier: "TableViewController", sender: nil)
                    }
                case .failure(_):
                    self?.didAlert(message: "Probleme de reseau")
                }
            }
        }
    }
}

// MARK: - Extension

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return table.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath)
        cell.textLabel?.text = "- \(table[indexPath.row])"
        
        return cell
    }
}


extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Add some ingredients in the list"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return table.isEmpty ? 200 : 0
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            table.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

