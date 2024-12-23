//
//  PreferencesViewUITests.swift
//  UniversityOrganizerUITests
//
//  Created by Marcin Wawer on 23-12-2024.
//

import XCTest

final class PreferencesViewUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--uitesting")
        app.launchArguments.append("--uitesting-showWelcomeView-false") 
        app.launchArguments.append("--uitesting-appearance-light")
        app.launch()
        
        let preferencesIcon = app.images["slider.horizontal.3"]
        XCTAssertTrue(preferencesIcon.exists, "Icon 'slider.horizontal.3' does not exist.")
        preferencesIcon.tap()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testToggleDarkMode() throws {
        let darkModeToggle = app.switches["🌙 Dark Mode"]
        XCTAssertTrue(darkModeToggle.exists, "'🌙 Dark Mode' toggle does not exist.")
        
        XCTAssertEqual(darkModeToggle.value as? String, "0", "Dark Mode should be off.")
        darkModeToggle.switches.firstMatch.tap()
        XCTAssertEqual(darkModeToggle.value as? String, "1", "Dark Mode is not enabled.")
    }
    
    func testNavigateToColorPickerView() throws {
        let colorsOption = app.staticTexts["🌈 Set Colors for Classes"]
        XCTAssertTrue(colorsOption.exists, "Option '🌈 Set Colors for Classes' does not exist.")
        
        colorsOption.tap()
        
        let colorPickerView = app.staticTexts["Select Colors for Classes"]
        XCTAssertTrue(colorPickerView.exists, "View 'ColorPickerView' was not shown.")
    }
    
    func testResetAppData() throws {
        let resetButton = app.buttons["Reset App Data"]
        XCTAssertTrue(resetButton.exists, "Button 'Reset App Data' does not exist.")
        
        resetButton.tap()
        
        let resetToast = app.staticTexts["App data reseted!"]
        XCTAssertTrue(resetToast.waitForExistence(timeout: 2), "Toast 'App data reseted!' was not shown.")
        
        let welcomeScreen = app.staticTexts["Set your info! 🤩"]
        XCTAssertTrue(welcomeScreen.waitForExistence(timeout: 2), "Welcome View was not shown after data reset.")
    }
    
    func testDismissPreferencesView() throws {
                let dismissButton = app.images["xmark"]
        XCTAssertTrue(dismissButton.exists, "Icon 'xmark' does not exist.")
        dismissButton.tap()
        
        XCTAssertFalse(app.navigationBars["Preferences"].exists, "View 'Preferences' was not closed.")
    }
}
