//
//  StubApiTests.swift
//  TorAlarmCodingTaskTests
//
//  Created by Erdinc Kolukisa on 3/22/21.
//

import XCTest
@testable import TorAlarmCodingTask

class StubApiTests: XCTestCase {
    
    var networking: Networkable!
    
    override func setUpWithError() throws {
        networking = StubApi()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetCategories() {
        let categoriesExpectation = expectation(description: "Get categories from StubApi")
        networking.getCategories { result in
            switch result {
            case .failure(let error):
                XCTAssertNil(error, "Error must be nil")
                
            case .success(let categories):
                XCTAssertEqual(categories.count, 7, "Categories count is wrong")
            }
            
            categoriesExpectation.fulfill()
        }
        
        wait(for: [categoriesExpectation], timeout: 2.0)
    }
    
    func testGetNews() {
        let newsExpectation = expectation(description: "Get news from StubApi")
        networking.getNews(from: "", category: "") { result in
            switch result {
            case .failure(let error):
                XCTAssertNil(error, "Error must be nil")
                
            case .success(let response):
                XCTAssertEqual(response.articles?.count, 20, "News count is wrong")
            }
            
            newsExpectation.fulfill()
        }
        
        wait(for: [newsExpectation], timeout: 2.0)
    }
    
}
