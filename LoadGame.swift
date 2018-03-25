//
//  LoadGame.swift
//  TichuCounterSwift
//
//  Created by George Maroulis on 12/9/17.
//  Copyright © 2017 George Maroulis. All rights reserved.
//

import UIKit
import CoreData

class LoadCell :UITableViewCell {
    
    @IBOutlet var team2: UILabel!
    @IBOutlet var team1: UILabel!
}

class LoadGame: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var games : [NSManagedObject] = []
    var id : Int = -1
    var team1 = ""
    var team2 = ""
    let textCellIdentifier = "LoadCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Game_")
        
        do {
            games = try managedContext.fetch(fetchRequest)
            print("Ekane fetch")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    @IBOutlet var tableView: UITableView!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let game = games[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! LoadCell
        
        cell.team1?.text = game.value(forKey: "team1") as? String
        cell.team2?.text = game.value(forKey: "team2") as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let game = games[indexPath.row]
        self.id = game.value(forKey: "id") as! Int
        self.team1 = game.value(forKey: "team1") as! String
        self.team2 = game.value(forKey: "team2") as! String
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGameLoad" {
            if let destinationVC = segue.destination as? Game{
                destinationVC.id = self.id
                destinationVC.team1 = self.team1
                destinationVC.team2 = self.team2
            }
        }
    }

}
