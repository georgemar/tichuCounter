//
//  ViewController.swift
//  TichuCounterSwift
//
//  Created by George Maroulis on 3/9/17.
//  Copyright © 2017 George Maroulis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepare (for segue: UIStoryboardSegue , sender: Any?) {
        if segue.identifier == "toNewGame" {
            if segue.destination is NewGame{}
        } else if segue.identifier == "toLoadGame"{
            if segue.destination is LoadGame{}
        }
    }
}

