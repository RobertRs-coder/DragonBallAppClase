//
//  NetworkModelsTests.swift
//  DragonBallTests
//
//  Created by Roberto Rojo Sahuquillo on 25/7/22.
//

import XCTest
@testable import DragonBall


enum ErrorMock: Error {
    case mockCase
}

class NetworkModelTests: XCTestCase {
    
    private var urlSessionMock: URLSessionMock!
    private var sut: NetworkModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        urlSessionMock = URLSessionMock ()
        sut = NetworkModel(urlSession: urlSessionMock)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }
    
    func testLoginFailWithNoData() {
        
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = nil
        
        //When
        sut.login(user: "rrojo.va@gmail.com", password: "123456") { _, networkError in
            error = networkError
        }
        //Then
        XCTAssertEqual(error, .noData)
    }
    
    func testLoginFailWithError() {
        
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = nil
        urlSessionMock.error = ErrorMock.mockCase
        
        //When
        sut.login(user: "", password: "") { _, networkError in
            error = networkError
        }
        //Then
        XCTAssertEqual(error, .otherError)
    }
    
    func testLoginFailWithErrorCodeNil() {
        
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = "TokenString".data(using: .utf8)!
        urlSessionMock.response = nil
        
        //When
        sut.login(user: "", password: "") { _, networkError in
            error = networkError
        }
        //Then
        XCTAssertEqual(error, .errorCode(nil))
    }
    
    func testLoginFailWithErrorCode() {
        
        var error: NetworkError?
        
        //Given
        urlSessionMock.data = "TokenString".data(using: .utf8)!
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 404, httpVersion: nil, headerFields: nil)
        
        //When
        sut.login(user: "", password: "") { _, networkError in
            error = networkError
        }
        //Then
        XCTAssertEqual(error, .errorCode(404))
    }
    // Problema con la data ?
//    func testLoginFailWithTokenFormatError() {
//        
//        var error: NetworkError?
//        
//        //Given
//        urlSessionMock.data = Data([0x00])
//        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
//        
//        //When
//        sut.login(user: "", password: "") { _, networkError in
//            error = networkError
//        }
//        //Then
//        XCTAssertEqual(error, .tokenFormatError)
//    }
//    
    func testLoginSuccessWithMockToken() {
        
        var error: NetworkError?
        var retrievedToken: String?

        //Given
        urlSessionMock.data = "TokenString".data(using: .utf8)!
        urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
        
        //When
        sut.login(user: "", password: "") { token, networkError in
            retrievedToken = token
            error = networkError
        }
        //Then
        XCTAssertEqual(retrievedToken, "TokenString", "Should have received a token")
        XCTAssertNil(error, "There should be no error")
    }

//    func testLoginSuccess() throws {
//        
//        var retrievedToken: String?
//        var error: NetworkError?
//        
//        // Given
//        let expectation = expectation(description: "Login Success")
//        
//        // When
//        sut.login(user: "rrojo.va@gmail.com", password: "123456") { token, networkError in
//            retrievedToken = token
//            error = networkError
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 5)
//        
//        // Then
//        XCTAssertNotNil(retrievedToken, "Should have received a token")
//        XCTAssertNil(error, "Should be no error")
//        
//    }
//    
//    func testLoginFail() throws {
//        var retrievedToken: String?
//        var error: NetworkError?
//        
//        // Given
//        let expectation = expectation(description: "Login Fail")
//        
//        // When
//        sut.login(user: "rrojo.va@", password: "123456") { token, networkError in
//            retrievedToken = token
//            error = networkError
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 5)
//        
//        // Then
//        XCTAssertNil(retrievedToken, "Should have not received a token")
//        XCTAssertNotNil(error, "Should be an error")
//        
//        
//        
//        
//        
//        
//        
//    }
    
    func testGetHerosSuccess() {
      var error: NetworkError?
      var retrievedHeroes: [Hero]?
      
      //Given
      sut.token = "testToken"
      urlSessionMock.data = getHeroesData(resourceName: "heroes")
      urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
      
      //When
      sut.getHeroes { heroes, networkError in
        error = networkError
        retrievedHeroes = heroes
      }
      
      //Then
      XCTAssertEqual(retrievedHeroes?.first?.id, "Hero ID", "should be the same hero as in the json file")
      XCTAssertNil(error, "there should be no error")
    }
    
    func testGetHerosSuccessWithNoHeroes() {
      var error: NetworkError?
      var retrievedHeroes: [Hero]?
      
      //Given
      sut.token = "testToken"
      urlSessionMock.data = getHeroesData(resourceName: "noHeroes")
      urlSessionMock.response = HTTPURLResponse(url: URL(string: "http")!, statusCode: 200, httpVersion: nil, headerFields: nil)
      
      //When
      sut.getHeroes { heroes, networkError in
        error = networkError
        retrievedHeroes = heroes
      }
      
      //Then
      XCTAssertNotNil(retrievedHeroes)
      XCTAssertEqual(retrievedHeroes?.count, 0)
      XCTAssertNil(error, "there should be no error")
    }
  }

extension NetworkModelTests {
    func getHeroesData(resourceName: String) -> Data? {
        
        let bundle = Bundle(for: NetworkModelTests.self)
        
        guard let path = bundle.path(forResource: resourceName, ofType: "json") else {
            
            print("extension")
            return nil
        }
        return try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
    }
  }
