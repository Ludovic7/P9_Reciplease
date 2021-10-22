//
//  CoreDataManagerTests.swift
//  RecipleaseTests
//
//  Created by Ludovic DANGLOT on 13/10/2021.
//

@testable import Reciplease
import XCTest

class CoreDataManagerTests: XCTestCase {

    // MARK: - Properties

    var coreDataStack: MockCoreDataStack!
    var coreDataManager: CoreDataManager!

    //MARK: - Tests Life Cycle

    override func setUp() {
        super.setUp()
        coreDataStack = MockCoreDataStack()
        coreDataManager = CoreDataManager(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        coreDataManager = nil
        coreDataStack = nil
    }

    // MARK: - Tests

    func testCreateFavoriteMethods_WhenAnEntityIsCreated_ThenShouldBeCorrectlySaved() {
        coreDataManager.createFavorite(title: "chicken", hours: "1", like: "2", ingredientTable: ["chicken", "tomato"], recipeImage: "picture", url: "http")
        XCTAssertTrue(!coreDataManager.favorites.isEmpty)
        XCTAssertTrue(coreDataManager.favorites.count == 1)
        XCTAssertTrue(coreDataManager.favorites[0].title == "chicken")
}
    
    func testDeleteRecipeMethod_WhenAnEntityIsCreated_ThenShouldBeCorrectlyDeleted() {
        coreDataManager.createFavorite(title: "chicken", hours: "1", like: "2", ingredientTable: ["chicken", "tomato"], recipeImage: "picture", url: "http")
        coreDataManager.deleteRecipe(recipeTitle: "chicken")
        XCTAssertTrue(coreDataManager.favorites.isEmpty)
}
    
    func testSearchForRecipeMethod_WhenAnEntityIsSearch_ThenShouldBeAddedInFavorite() {
        XCTAssertFalse(coreDataManager.searchForRecipe(recipeTitle: "chicken"))
        coreDataManager.createFavorite(title: "chicken", hours: "1", like: "2", ingredientTable: ["chicken", "tomato"], recipeImage: "picture", url: "http")
        XCTAssertTrue(coreDataManager.searchForRecipe(recipeTitle: "chicken"))
        
        
}
    
    
}

