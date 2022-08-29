//
//  LocalDataModelTests.swift
//  DragonBallTests
//
//  Created by Roberto Rojo Sahuquillo on 25/8/22.
//

import XCTest
@testable import DragonBall

class LocalDataModelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        LocalDataModel.deleteToken()
    }

    func testSaveToken() throws {
        // Given
        let storedToken = "TestToken"
        // When
        LocalDataModel.save(token: storedToken)
        // Then
        let retrievedToken = LocalDataModel.getToken()
        XCTAssertEqual(storedToken, retrievedToken, "Correct Token")
    }
    
    func testGetTokenWhenNoTokenSaved() throws {
        // Then
        let retrievedToken = LocalDataModel.getToken()
        XCTAssertNil(retrievedToken, "There should be no saved token")
    }
    
    func testDeleteToken() throws {
      //Given
      let storedToken = "TestToken"
      LocalDataModel.save(token: storedToken)
      //When
      LocalDataModel.deleteToken()
      //Then
      let retrievedToken = LocalDataModel.getToken()
      XCTAssertNil(retrievedToken, "There should be no saved token")
    }
}
