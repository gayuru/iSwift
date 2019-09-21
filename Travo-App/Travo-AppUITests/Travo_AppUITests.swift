//
//  Travo_AppUITests.swift
//  Travo-AppUITests
//
//  Created by Gayuru Gunawardana on 15/9/19.
//  Copyright © 2019 Sogyal Thundup Sherpa. All rights reserved.
//

import XCTest

class Travo_AppUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

      
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //Common setup for a successful login
    func loginSuccessSetUp(){
        let logoElementsQuery = XCUIApplication().otherElements.containing(.image, identifier:"Logo")
        let textField = logoElementsQuery.children(matching: .textField).element
        textField.tap()
        textField.typeText("email1")
        
        let secureTextField = logoElementsQuery.children(matching: .secureTextField).element
        secureTextField.tap()
        secureTextField.typeText("password1")
    }
    
    //------ OVERALL USECASE STORYBOARD ------//
    func testOverall(){
        
    }
    
    //Tests _ Login storyboard
    //pre-condition, action and post condition should be present with comments
    func testValidLoginSuccess(){
    }
    
    func testInvalidLogin_missingCredentials(){
    }
    
    func testInvalidLogin_wrongCredentials(){
    }
    
    
    //------ DASHBOARD STORYBOARD ------//
    //pre-condition
    func testDashboardLoads(){
        loginSuccessSetUp()
        app.buttons["Login"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        let willYouGoTodayStaticText = elementsQuery.staticTexts["will you go\ntoday?"]
     
        XCTAssert(elementsQuery.buttons["Logo"].exists)
        XCTAssert(elementsQuery.staticTexts["Where"].exists)
        XCTAssert(willYouGoTodayStaticText.exists)
}
    
    func testDashboardMainComponentsVisible(){
        loginSuccessSetUp()
        app.buttons["Login"].tap()
        
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        let collectionView = scrollViewsQuery.otherElements.collectionViews.element
        let mostPopularElementsQuery = scrollViewsQuery.otherElements.containing(.staticText, identifier:"Most Popular")
        
        XCTAssert(elementsQuery.staticTexts["Most Popular"].exists)
        XCTAssert(elementsQuery.staticTexts["Recommended"].exists)
        XCTAssert(collectionView.exists)
        XCTAssert (mostPopularElementsQuery.children(matching: .button).matching(identifier: "See all").element(boundBy: 0).exists)
        XCTAssert(mostPopularElementsQuery.children(matching: .collectionView).element(boundBy: 2).children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.exists)
    }
    
    
    func testDashboardProfileTap(){
        loginSuccessSetUp()
        app.buttons["Login"].tap()

        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        
        XCTAssert(elementsQuery.buttons["profile"].exists)
        elementsQuery.buttons["profile"].tap()
        XCTAssert(elementsQuery.staticTexts["About me"].exists)
        elementsQuery.buttons["left arrow"].tap()
    }
    
    //To-Do
    func testDashboardCategoryChange(){
    }
    
    func testDashboardMostPopularTap(){
        loginSuccessSetUp()
        app.buttons["Login"].tap()
        
        let popularPlace = app.scrollViews.otherElements.collectionViews/*@START_MENU_TOKEN@*/.cells.staticTexts["Arcades and Laneways"]/*[[".cells.staticTexts[\"Arcades and Laneways\"]",".staticTexts[\"Arcades and Laneways\"]"],[[[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/
        XCTAssert(popularPlace.exists)
        popularPlace.tap()
        
        let validTitle = "Arcades and Laneways"
        let arcadesAndLanewaysStaticText = app.staticTexts["Arcades and Laneways"]
        XCTAssertEqual(validTitle, arcadesAndLanewaysStaticText.firstMatch.label)
    }
    
    func testDashboardSeeAll(){
        loginSuccessSetUp()
        app.buttons["Login"].tap()
        
        let mostPopularElementsQuery = app.scrollViews.otherElements.containing(.staticText, identifier:"Most Popular")
        let popularSeeAll = mostPopularElementsQuery.children(matching: .button).matching(identifier: "See all").element(boundBy: 0)
        XCTAssert(popularSeeAll.exists)
        popularSeeAll.tap()
        
        //go back home
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .button).element.tap()
        
        let recommendedSeeAll = mostPopularElementsQuery.children(matching: .button).matching(identifier: "See all").element(boundBy: 1)
        XCTAssert(recommendedSeeAll.exists)
        recommendedSeeAll.tap()
    }
    
    func testTaBar(){
        loginSuccessSetUp()
        app.buttons["Login"].tap()
        
        let window = app.children(matching: .window).element(boundBy: 0)
        let tabBar = window.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        XCTAssert(tabBar.exists)
        
        let homeItem = tabBar.children(matching: .other).element(boundBy: 0).children(matching: .button).element
        let favouriteItem = tabBar.children(matching: .other).element(boundBy: 1).children(matching: .button).element
        let cameraItem = tabBar.children(matching: .other).element(boundBy: 2).children(matching: .button).element
        let feelingLuckyItem = tabBar.children(matching: .other).element(boundBy: 3).children(matching: .button).element
        
        XCTAssert(homeItem.exists)
        XCTAssert(favouriteItem.exists)
        XCTAssert(cameraItem.exists)
        XCTAssert(feelingLuckyItem.exists)
        
        //checks if its tappable
        favouriteItem.tap()
        favouriteItem.tap()
        //change this to favourites later
        XCTAssert(app.staticTexts["No Favourites"].exists)
        
        cameraItem.tap()
        XCTAssert(app.staticTexts["PHOTO"].exists)
        app.buttons["arrow point to right"].tap()
        
        feelingLuckyItem.tap()
        XCTAssert(app.staticTexts["I'm Feeling lucky"].exists)
        
        homeItem.tap()
        let scrollViewsQuery = app.scrollViews
        let elementsQuery = scrollViewsQuery.otherElements
        XCTAssert(elementsQuery.buttons["Logo"].exists)
    }
    
    //------ PLACE STORYBOARD ------//
    //Tests _ Place storyboard
    func testPlaceLablesExist(){
        //pre-condition
        let app = XCUIApplication()
        app.buttons["Login"].tap()
        
        //action
        app.scrollViews.otherElements.buttons["aiony haust 3TLl 97HNJo unspla"].tap()
        app.scrollViews.otherElements.buttons["aiony haust 3TLl 97HNJo unspla"].tap()
        
        //testing
        let presentTitle = app.staticTexts["National Gallery of Victoria"].exists
        let presentOpenTime = app.staticTexts["10AM - 5PM"].exists
        let presentRating = app.staticTexts["4.7"].exists
        
        XCTAssertTrue(presentTitle && presentOpenTime && presentRating)
    }
    
    func testPlaceWithCorrectDetails(){
        
        let validTitle = "National Gallery of Victoria"
        let validOpenTime = "10AM - 5PM"
        let validRating = "4.7"
        
        //pre-condition
        let app = XCUIApplication()
        app.buttons["Login"].tap()
        
        //action
        app.scrollViews.otherElements.buttons["aiony haust 3TLl 97HNJo unspla"].tap()
        app.scrollViews.otherElements.buttons["aiony haust 3TLl 97HNJo unspla"].tap()
        
        let presentTitle = app.staticTexts["National Gallery of Victoria"]
        let presentOpenTime = app.staticTexts["10AM - 5PM"]
        let presentRating = app.staticTexts["4.7"]
        
        //testing
        XCTAssertEqual(validTitle, presentTitle.label)
        XCTAssertEqual(validOpenTime, presentOpenTime.label)
        XCTAssertEqual(validRating, presentRating.label)
    }
    
    func testPlace_CorrectImage(){
       
    }
    
    
    func testPlace_getDirections(){
        
    }
    
    func testPlace_ratingValid(){
        
    }
    
    //------ FAVORUITES STORYBOARD ------//

    //------ FEELING LUCKY STORYBOARD ------//

    
}
