//
//  CoreDataUseCaseImplTests.swift
//  Football LeaguesTests
//
//  Created by Ahmed Shafik on 18/09/2023.
//

import XCTest
@testable import Football_Leagues

final class CoreDataUseCaseImplTests: XCTestCase {
    var sut: CoreDataUseCaseImpl!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUpWithError() throws {
        mockCoreDataManager = MockCoreDataManager()
        sut = CoreDataUseCaseImpl(manager: mockCoreDataManager)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockCoreDataManager = nil
        try super.tearDownWithError()
    }
    
    func testSaveCompetitions_Success() {
        // Arrange
//        let competitions = MockGenerator.generateCompetitions(count: 10)
////        mockCoreDataManager.expectedError = nil
//
//        // Act
//        let expectation = XCTestExpectation(description: "Save Competitions")
//        sut.saveCompetitions(competitions) { error in
//            XCTAssertNil(error)
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 1.0)
//
//        // Assert
//        XCTAssertTrue(mockCoreDataManager.saveCompetitionsCalled)
    }
    
    func testSaveCompetitions_Failure() {
//        // Arrange
//        let competitions = [LeaguesUIModel.CompetitionUIModel(id: 1, name: "Competition 1", code: "C1", type: "League", emblem: "Emblem 1")]
//        mockCoreDataManager.expectedError = CoreDataError.someError
//        
//        // Act
//        let expectation = XCTestExpectation(description: "Save Competitions")
//        coreDataUseCase.saveCompetitions(competitions) { error in
//            XCTAssertEqual(error, CoreDataError.someError)
//            expectation.fulfill()
//        }
//        
//        wait(for: [expectation], timeout: 1.0)
//        
//        // Assert
//        XCTAssertTrue(mockCoreDataManager.saveCompetitionsCalled)
    }
    
}
