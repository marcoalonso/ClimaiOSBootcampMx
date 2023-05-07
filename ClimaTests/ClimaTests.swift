//
//  ClimaTests.swift
//  ClimaTests
//
//  Created by Marco Alonso Rodriguez on 07/05/23.
//

import XCTest
@testable import Clima

final class ClimaTests: XCTestCase {
    
    var sut: ClimaViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: "ClimaViewController") as? ClimaViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
    }

    func test_validate_textField_is_empty() throws {
        let nameCity = try XCTUnwrap(sut.nombreCiudadTextField)
        
        XCTAssertEqual(nameCity.text!, "")
    }
    
    func test_validate_textField_shows_correct_message() throws {
        let nameCity = try XCTUnwrap(sut.nombreCiudadTextField)
        
        XCTAssertEqual(nameCity.placeholder, "ciudad o pais")
    }
    
    func test_validate_textField_keyboardtype_should_be_asciiCapable() throws {
        let nameCity = try XCTUnwrap(sut.nombreCiudadTextField)
        
        XCTAssertEqual(nameCity.keyboardType, .asciiCapable)
        
        //This code will fall
//        XCTAssertEqual(nameCity.keyboardType, .emailAddress)
    }
    
    func test_validate_temperature_label_is_empty_at_start() throws {
        let temperatureLabel = try XCTUnwrap(sut.temperaturaLabel)
        
        XCTAssertEqual(temperatureLabel.text, "")
    }
    
    func test_validate_description_label_is_empty_at_start() throws {
        let descriptionLabel = try XCTUnwrap(sut.descripcionClimaLabel)
        
        XCTAssertEqual(descriptionLabel.text, "")
    }

}


