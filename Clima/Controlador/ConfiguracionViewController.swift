//
//  ConfiguracionViewController.swift
//  Clima
//
//  Created by Marco Alonso Rodriguez on 26/02/23.
//

import UIKit

class ConfiguracionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func temperaturaSegmentedControlAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("Centigrados")
        } else if sender.selectedSegmentIndex == 1 {
            print("Farenheit")
        }
    }
    
    
    @IBAction func cerrarButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
   
}
