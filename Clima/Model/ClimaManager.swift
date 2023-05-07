//
//  ClimaManager.swift
//  Clima
//
//  Created by marco rodriguez on 22/10/22.
//

import Foundation

protocol ClimaManagerDelegate {
    //dos metodos obligatorios que el VC debera de implementar
    func actualizarClima(clima: ClimaModelo)
    func huboError(cualError: String)
}

struct ClimaManager {
    //Puede o no, haber un delegado y lo hay debe de adoptar el protocolo
    var delegado: ClimaManagerDelegate?
    
    let climaURL = "https://api.openweathermap.org/data/2.5/weather?appid=698cb29c0a1e70d1a30a0a9982f6a95a&units=metric&lang=es"
    
    func fetchClima(lat: Double, lon: Double){
        //Concatenar la url base con lat y lon
        //llamar a la API
        let urlString = "\(climaURL)&lat=\(lat)&lon=\(lon)"
        realizarSolicitud(url: urlString)
    }
    
    func fetchClima(nombreCiudad: String) {
        //concatenar la url base con la busq del usuario
        let urlString = "\(climaURL)&q=\(nombreCiudad)"
        
        realizarSolicitud(url: urlString)
    }
    
    //Consulta API
    func realizarSolicitud(url: String) {
        //1.- Crear un obj URL
        if let url = URL(string: url) {
            
            //2.- Crear una sesion
            let session = URLSession(configuration: .default)
            
            //3.- Asignar una tarea a la sesion
            let tarea = session.dataTask(with: url) { data, respuesta, error in
                
                ///Estraer el valor de un opcional
                if let res = respuesta {
                    print(res)
                }
                
                if error != nil { //significa que hubo error en la peticion
                    print("Error en la tarea de la API: \(error!.localizedDescription)")
                    delegado?.huboError(cualError: error!.localizedDescription)
                }
                
                //desenvolver la data
                if let datosSeguros = data {
                    //decodificar esa data, crear el objeto Clima y mandarlo a traves del delegado.
                    if let clima = self.parseJSON(climaData: datosSeguros) {
                      //si mi PARSEJSON si me retorna
                        delegado?.actualizarClima(clima: clima)
                    }
                }
            }
            //4.- Comenzar la tarea
            tarea.resume()
            
        } else {
            delegado?.huboError(cualError: "Error al buscar el nombre de la ciudad o pais intenta de nuevo")
        }
        
    }
    
    //decodificacion del archivo JSON a los datos que estableci,
    //y me va retornar el objeto para mi App, pero opcional
    func parseJSON(climaData: Data) -> ClimaModelo? {
        let decoder = JSONDecoder()
        
        do {
            let dataDecodificada = try decoder.decode(ClimaData.self, from: climaData)
            //crear el objClima
            let id = dataDecodificada.weather[0].id
            let nombre = dataDecodificada.name
            let descripcion = dataDecodificada.weather[0].description
            let temp = dataDecodificada.main.temp
            let humedad = dataDecodificada.main.humidity
            
            let objClima = ClimaModelo(condicionID: id, nombreCiudad: nombre, descripcionClima: descripcion, temperaturaCelcius: temp, humedad: humedad)
            
            return objClima
        } catch {
            print("Error al decodificar : \(error.localizedDescription)")
            //a traves del delegado le voy a informar al usuario el error
            delegado?.huboError(cualError: error.localizedDescription)
            return nil
        }
        
    }
    
}
