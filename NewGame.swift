//
//  NewGame.swift
//  TichuCounterSwift
//
//  Created by George Maroulis on 3/9/17.
//  Copyright © 2017 George Maroulis. All rights reserved.
//

import UIKit

class NewGame: UIViewController ,UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        textf1.delegate = self
        textf2.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBOutlet var textf1: UITextField!
    @IBOutlet var textf2: UITextField!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGame" {
            if let destinationVC = segue.destination as? Game{
                destinationVC.team1 = textf1.text!
                destinationVC.team2 = textf2.text!
            }
        }
    }
}
