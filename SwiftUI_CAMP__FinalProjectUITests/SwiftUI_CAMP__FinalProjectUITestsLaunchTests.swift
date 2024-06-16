//
//  SwiftUI_CAMP__FinalProjectUITestsLaunchTests.swift
//  SwiftUI_CAMP__FinalProjectUITests
//
//  Created by ณัฐภัทร บัวเพชร on 16/6/2567 BE.
//

import XCTest

final class SwiftUI_CAMP__FinalProjectUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
