//
//  ViewController.swift
//  Clima
//
//  Created by marco rodriguez on 22/10/22.
//

import UIKit
import CoreLocation
import ProgressHUD

//Adoptar el protocolo
class ClimaViewController: UIViewController, ClimaManagerDelegate {
    
    @IBOutlet weak var humedadLabel: UILabel!
    @IBOutlet weak var gradosCLabel: UILabel!
    @IBOutlet weak var fondoClimaImageView: UIImageView!
    @IBOutlet weak var climaImageView: UIImageView!
    @IBOutlet weak var nombreCiudadTextField: UITextField!
    @IBOutlet weak var temperaturaLabel: UILabel!
    @IBOutlet weak var descripcionClimaLabel: UILabel!
    
    // MARK: - Variables
    var climaManager = ClimaManager()
    var activityView: UIActivityIndicatorView?
    
    var locationManager = CLLocationManager()
    var lat : Double?
    var lon: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nombreCiudadTextField.delegate = self
        climaManager.delegado = self
        locationManager.delegate = self
        
        //Pedir permiso al usuario para acceder a su ubicacion
        locationManager.requestWhenInUseAuthorization()
        gradosCLabel.isHidden = true
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        showActivityIndicator()
    }
    
    // MARK: - Functions
    func setupUI(){
        nombreCiudadTextField.accessibilityIdentifier = "citiNameTextField"
    }
    
    func actualizarClima(clima: ClimaModelo) {
        DispatchQueue.main.async {
            self.temperaturaLabel.text = clima.temperaturaDecimal
            self.descripcionClimaLabel.text = "En \(clima.nombreCiudad) el clima esta: \(clima.descripcionClima)"
            self.climaImageView.image = UIImage(systemName: "\(clima.condicionClima)")
            self.gradosCLabel.isHidden = false
            self.humedadLabel.text = clima.humedadPorcentaje
            self.hideActivityIndicator()
            self.climaImageView.isHidden = false
        }
        
    }
    
    func huboError(cualError: String) {
        DispatchQueue.main.async {
            self.mostrarAlerta(titulo: "Error", mensaje: "La ciudad o pais que estás buscando no existe o está mal escrita, por favor intenta de nuevo.")
        }
    }
    
    
    func showActivityIndicator() {
        ProgressHUD.show("Buscando...", icon: .exclamation)
    }
    
    func hideActivityIndicator(){
        ProgressHUD.remove()
    }
    
    func mostrarAlerta(titulo: String, mensaje: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "OK", style: .default) { _ in
            //Do something
            self.climaManager.fetchClima(lat: self.lat ?? 19.1345, lon: self.lon ?? -101.1840)
        }
        alerta.addAction(accionAceptar)
        present(alerta, animated: true)
    }
    
    //MARK: Nueva Búsqueda
    private func newSearch(){
        showActivityIndicator()
        
        print("Buscar el internet la info del clima")
        guard let nombre = nombreCiudadTextField.text?.replacingOccurrences(of: " ", with: "%20") else {
            return
        }
        climaManager.fetchClima(nombreCiudad: nombre)
        ///ocultar teclado
        limpiarCampos()
    }
    
    func limpiarCampos(){
        nombreCiudadTextField.endEditing(true)
        nombreCiudadTextField.text = ""
        ///Limpiar
        self.descripcionClimaLabel.text = ""
        self.humedadLabel.text = ""
        self.gradosCLabel.isHidden = true
        self.climaImageView.isHidden = true
        self.temperaturaLabel.text = ""
    }

    @IBAction func locationButton(_ sender: UIButton) {
        print("DEBUG: Acceder  ak GPS")
        climaManager.fetchClima(lat: lat!, lon: lon!)
        showActivityIndicator()
        limpiarCampos()
    }
    
    
    @IBAction func configuracionButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ConfiguracionViewController") as! ConfiguracionViewController
        
        if let sheet = vc.presentationController as? UISheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true ///Indicador horizontal de enmedio
        }
        present(vc, animated: true)
    }
    
}

// MARK: - GPS Metodos Del Protocolo que a traves del Delegado se ejecutan
extension ClimaViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("DEBUG: Se otuvo la ubicacion")
        if let ubicacion = locations.last {
            print("Ubicacion \(ubicacion.coordinate.latitude)")
            print("Ubicacion \(ubicacion.coordinate.longitude)")
            
             lat = ubicacion.coordinate.latitude
             lon = ubicacion.coordinate.longitude
            
            climaManager.fetchClima(lat: lat ?? 19.1345, lon: lon ?? -101.1840)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("DEBUG: Error al obtener la ubicacion")
        mostrarAlerta(titulo: "Atención", mensaje: "Error al obtener tu ubicacion, es necesaria para darte información del clima donde te encuentra actualmente.")
    }
    
    //Cada que se cambian los permisos de la ubicacion
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            //Acceder a la ubicacion
            manager.requestLocation()
        case .authorized:
            print("authorized")
        @unknown default:
            fatalError("Error desconocido :/")
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}


extension ClimaViewController: UITextFieldDelegate {
    //1.- Habilitar el boton del teclado virtual
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Hacer algo ")
        //ocultar teclado
        nombreCiudadTextField.endEditing(true)
        return true
    }
    
    //2.- Identificar cuando el usuario termina de editar y que pueda borrar el contenido del textField
    func textFieldDidEndEditing(_ textField: UITextField) {
        newSearch()
    }
    
    //3.- Evitar que el usuario no escriba nada
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if nombreCiudadTextField.text != "" {
            return true
        } else {
            //el usuario no escribio nada
            nombreCiudadTextField.placeholder = "Debes escribir algo.."
            return false
        }
    }
}
