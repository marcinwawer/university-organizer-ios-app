//
//  UniversityOrganizerUITestsLaunchTests.swift
//  UniversityOrganizerUITests
//
//  Created by Marcin Wawer on 23-12-2024.
//

import XCTest

final class UniversityOrganizerUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launchArguments.append("--uitesting-showWelcomeView-true")
        app.launch()

        let welcomeViewTitle = app.staticTexts["Set your info! 🤩"]
        XCTAssertTrue(welcomeViewTitle.exists, "WelcomeView was not shown, when showWelcomeView = true.")
        
        app.terminate()
        app.launchArguments = ["--uitesting-showWelcomeView-false"]
        app.launch()
        
        let preferencesIcon = app.images["slider.horizontal.3"]
        XCTAssertTrue(preferencesIcon.exists, "HomeView was not shown, when showWelcomeView = false.")

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
