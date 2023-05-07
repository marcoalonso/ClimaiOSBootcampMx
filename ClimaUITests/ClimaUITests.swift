//
//  ClimaUITests.swift
//  ClimaUITests
//
//  Created by Marco Alonso Rodriguez on 05/05/23.
//

import XCTest

///Al iniciar la app que tenga textField Vacío, No muestre nada en el label de temperatura, ni en el label de descripción
 class when_app_is_shown: XCTestCase {

     private var app: XCUIApplication!
     private var contentViewPage: ContentViewPage!
     
     override func setUp() {
         app = XCUIApplication()
         continueAfterFailure = false
         app.launch()
     }
     
     

     func test_should_make_sure_that_the_name_city_contains_empty_value(){
         XCTAssertEqual(contentViewPage.nameCityTextField.value as! String, "ciudad o pais")
     }
    

}
