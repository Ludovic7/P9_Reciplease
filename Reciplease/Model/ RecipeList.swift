//
//   RecipeList.swift
//  Reciplease
//
//  Created by Ludovic DANGLOT on 22/09/2021.
//

import Foundation

// MARK: - RecipeList
struct RecipeList: Codable {
    var hits: [Hit]
    var links: RecipeListLinks?

    enum CodingKeys: String, CodingKey {
        case hits
        case links = "_links"
        
    }
}

// MARK: - Hit
struct Hit: Codable {
    let recipe: Recipe
    let links: HitLinks

    enum CodingKeys: String, CodingKey {
        case recipe
        case links = "_links"
    }
}

// MARK: - HitLinks
struct HitLinks: Codable {
    let linksSelf: Next

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - Next
struct Next: Codable {
    let href: String
    let title: Title
}

enum Title: String, Codable {
    case nextPage = "Next page"
    case titleSelf = "Self"
}

// MARK: - Recipe
struct Recipe: Codable {
    let label: String
    let image: String
    let url: String
    let yield: Int
    let ingredientLines: [String]
    let ingredients: [Ingredient]
    let totalTime: Int
}


// MARK: - Ingredient
struct Ingredient: Codable {
    let text: String
    let food: String

    enum CodingKeys: String, CodingKey {
        case text, food

    }
}


// MARK: - RecipeListLinks
struct RecipeListLinks: Codable {
    let next: Next?
}


