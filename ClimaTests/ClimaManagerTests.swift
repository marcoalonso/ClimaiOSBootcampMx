//
//  ClimaManagerTests.swift
//  ClimaTests
//
//  Created by Marco Alonso Rodriguez on 07/06/23.
//

import XCTest
@testable import Clima

final class ClimaManagerTests: XCTestCase, ClimaManagerDelegate {
   
    var climaModelo : ClimaModelo?
    var nombreCiudad: String = ""
    var errorMessage: String?

    ///Probar que el service devuelva un obj a partir de un json local
    func test_ClimaManagerDecodingFromJson(){
        //Given
        let jsonString = "{\"coord\":{\"lon\":-55,\"lat\":-10},\"weather\":[{\"id\":804,\"main\":\"Clouds\",\"description\":\"nubes\",\"icon\":\"04n\"}],\"base\":\"stations\",\"main\":{\"temp\":26.53,\"feels_like\":26.53,\"temp_min\":26.53,\"temp_max\":26.53,\"pressure\":1012,\"humidity\":60,\"sea_level\":1012,\"grnd_level\":983},\"visibility\":10000,\"wind\":{\"speed\":1.36,\"deg\":100,\"gust\":1.41},\"clouds\":{\"all\":88},\"dt\":1686174915,\"sys\":{\"country\":\"BR\",\"sunrise\":1686131535,\"sunset\":1686173140},\"timezone\":-14400,\"id\":3469034,\"name\":\"Brazil\",\"cod\":200}"
        
        //Then
        let data = jsonString.data(using: .utf8)!
        let sut = ClimaManager()
        
        //When
        let decodedData = sut.parseJSON(climaData: data)
        XCTAssertNotNil(decodedData)
    }
    
    func testClimaManagerGettingBackObj(){
        //Given
        var manager = ClimaManager()
        manager.delegado = self
        let exp = expectation(description: "Espera recibir obj")
        
        //Then
        manager.fetchClima(nombreCiudad: "Morelia")
        
        //When
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            XCTAssertEqual(self.nombreCiudad, "Morelia")
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 8)
        
        
    }
    
    // MARK:  ClimaManagerDelegate
    func actualizarClima(clima: ClimaModelo) {
        self.nombreCiudad = clima.nombreCiudad
    }
    
    func huboError(cualError: String) {
        self.errorMessage = cualError
    }

}
