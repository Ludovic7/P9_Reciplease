//
//  CoreDataManager.swift
//  Reciplease
//
//  Created by Ludovic DANGLOT on 04/10/2021.
//

import Foundation

import CoreData

final class CoreDataManager {

    // MARK: - Properties

    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext

    var favorites: [Favorite] {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        guard let tasks = try? managedObjectContext.fetch(request) else { return [] }
        return tasks
    }

    // MARK: - Initializer

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }

    // MARK: - Manage Task Entity

    func createFavorite(title: String, hours: String, like: String, ingredientTable: [String], recipeImage: String, url: String) {
        let favorite = Favorite(context: managedObjectContext)
        favorite.title = title
        favorite.like = like
        favorite.hours = hours
        favorite.url = url
        favorite.ingredientTable = ingredientTable
        favorite.recipeImage = recipeImage
        coreDataStack.saveContext()
    }
    
    func deleteRecipe(recipeTitle : String){
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title = %@", recipeTitle)
        guard let recipes = try? managedObjectContext.fetch(fetchRequest) else { return }
        guard let recipe = recipes.first else {return}
        managedObjectContext.delete(recipe)
        coreDataStack.saveContext()
    }
    
    func searchForRecipe(recipeTitle : String) -> Bool{
        let fetchRequest: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", recipeTitle)
        if (try? managedObjectContext.fetch(fetchRequest).first) != nil { return true }
        return false
    }
        
    
    
    

}
