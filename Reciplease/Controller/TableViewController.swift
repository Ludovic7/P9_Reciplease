//
//  TableViewController.swift
//  Reciplease
//
//  Created by Ludovic DANGLOT on 21/09/2021.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    // MARK: - Properties
    
    var recipeList : RecipeList?
    let cellRecipe = "RecipeTableViewCell"
    var recipe : Recipe?
    var recipeService = RecipeService()
    var fetchingMore = true
    
    // MARK: - @IB Outlet

    @IBOutlet var recipeTableView: UITableView!
    
    // MARK: - Initializer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: cellRecipe, bundle:
                                    nil), forCellReuseIdentifier: cellRecipe)
        let loadingNib = UINib(nibName: "LoadingTableViewCell", bundle: nil)
        tableView.register(loadingNib, forCellReuseIdentifier: "LoadingTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Methodes
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return recipeList?.hits.count ?? 0
        } else if section == 1 && fetchingMore {
            return 1
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellRecipe, for: indexPath) as? RecipeTableViewCell
            cell?.recipe = recipeList?.hits[indexPath.row].recipe
            return cell!
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LoadingTableViewCell", for: indexPath) as? LoadingTableViewCell
            cell?.loadingIndicator.startAnimating()
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "RecipeViewController" {
            let recipeTableViewController = segue.destination as! RecipeViewController
            recipeTableViewController.recipeInfo = recipe
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        recipe = recipeList?.hits[indexPath.row].recipe
        performSegue(withIdentifier: "RecipeViewController", sender: cell)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height {
            if fetchingMore {
                beginBatchFetch()
            }
        }
    }
    
    func beginBatchFetch() {
        fetchingMore = false
        tableView.reloadSections(IndexSet(integer: 1), with: .none)
        guard let nextCell = recipeList?.links?.next?.href else {return}
        
        recipeService.getMoreData(urlToSearch: nextCell) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data) :
                    self?.recipeList?.hits.append(contentsOf: data.hits)
                    self?.recipeList?.links = data.links
                    self?.fetchingMore = true
                    self?.tableView.reloadData()
                case .failure(_):
                    self?.didAlert(message: "Probleme de reseau")
                }
            }
        }
    }
}

// MARK: - Extension

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
