//
//  RecipeTableViewCell.swift
//  Reciplease
//
//  Created by Ludovic DANGLOT on 24/09/2021.
//

import UIKit

class RecipeTableViewCell: UITableViewCell {

    @IBOutlet weak var recipePictureImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ingretientsLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var hoursLabel: UILabel!

    var recipe : Recipe? {
        didSet {
            titleLabel.text = recipe?.label
            ingretientsLabel.text = recipe?.ingredientLines.joined(separator: ", ")
            likeLabel.text = String(recipe?.yield ?? 0)
            hoursLabel.text = "\(String(recipe?.totalTime ?? 0)) min"
            if let stringUrl = recipe?.image {
                recipePictureImageView.load(url: URL(string: stringUrl)!)
            } else {
                recipePictureImageView.image = UIImage(named: "maxresdefault")
            }
        }
    }
    
    var recipeFavorite : Favorite? {
        didSet {
            titleLabel.text = recipeFavorite?.title
            ingretientsLabel.text = recipeFavorite?.ingredientTable?.joined(separator: ",")
            likeLabel.text = recipeFavorite?.like
            hoursLabel.text = "\(recipeFavorite?.hours ?? "0") min"
            if let stringUrl = recipeFavorite?.recipeImage {
                recipePictureImageView.load(url: URL(string: stringUrl)!)
            } else {
                recipePictureImageView.image = UIImage(named: "maxresdefault")
            }
        }
    }
    
}
