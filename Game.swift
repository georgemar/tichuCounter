//
//  Game.swift
//  TichuCounterSwift
//
//  Created by George Maroulis on 3/9/17.
//  Copyright © 2017 George Maroulis. All rights reserved.
//

import UIKit
import CoreData

class ScoreCell: UITableViewCell {
    @IBOutlet var tscore2: UILabel!
    @IBOutlet var tscore1: UILabel!
}
class Game: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var team1 = ""
    var team2 = ""
    var games :[NSManagedObject] = []
    var id = -1
    var scores1 = [Int]()
    var scores2 = [Int]()
    var sum1 = 0
    var sum2 = 0
    let textCellIdentifier = "TextCell"
    var flag = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        label1.text = team1
        label2.text = team2
        tableView.delegate = self
        tableView.dataSource = self
        lookupid()
    }
    func save(){
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        let entity =
            NSEntityDescription.entity(forEntityName: "Game_",
                                       in: managedContext)!
        let game = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        game.setValue(id, forKey: "id")
        game.setValue(team1, forKey: "team1")
        game.setValue(team2, forKey: "team2")
        do {
            try managedContext.save()
            games.append(game)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func lookupid() {
        if (self.id == -1){
            self.id = 100
            self.save()
        }
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores1.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell  {
        let cell = tableView.dequeueReusableCell(withIdentifier: textCellIdentifier, for: indexPath) as! ScoreCell
        let row = indexPath.row
        
        cell.tscore1?.text = String(scores1[row])
        cell.tscore2?.text = String(scores2[row])
        return cell
    }
    @IBOutlet var button: UIButton!
    @IBOutlet var ssum1: UILabel!
    @IBOutlet var ssum2: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label1: UILabel!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func checkScores(score1 :Int ,score2 :Int) {
        if(score1 + score2 > 400 || score1 > 400 || score2 > 400 || (score1+score2)%100 != 0 || score1 + score2 == 0)
        {
            let alertController1 = UIAlertController(title: "Wrong Scores", message: "", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action : UIAlertAction!) -> Void in  self.newround((Any).self)  })
            alertController1.addAction(okAction)
            self.present(alertController1, animated: true, completion: nil)
        } else {
            self.sum1 += score1
            self.sum2 += score2
            self.ssum1.text = String(self.sum1)
            self.ssum2.text = String(self.sum2)
            self.scores1.append(score1)
            self.scores2.append(score2)
            self.tableView.reloadData()
        }
    }
    func winneral(win:String) {
        let alertCong = UIAlertController(title: "Congrats", message: win, preferredStyle: UIAlertControllerStyle.alert)
        let okAction2 = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in
        })
        alertCong.addAction(okAction2)
        self.present(alertCong, animated: true, completion: nil)
        self.button.isEnabled = false
    }
    @IBAction func undo(_ sender: Any) {
        if (scores1.count > 0){
            self.sum1 -= scores1.last!
            self.sum2 -= scores2.last!
            self.ssum1.text = String(self.sum1)
            self.ssum2.text = String(self.sum2)
            scores1.removeLast()
            scores2.removeLast()
            self.tableView.reloadData()
        }
    }
    @IBAction func newround(_ sender: Any) {
        var winner = ""
        let addScore = UIAlertController(title: "Enter Scores", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default, handler: {
            alert -> Void in
            let firstTextField = addScore.textFields![0].text as String?
            let secondTextField = addScore.textFields![1].text as String?
            if (firstTextField != "" && secondTextField != "" && firstTextField != "," && secondTextField != "," ){
                self.checkScores(score1 :Int(firstTextField!)! ,score2 :Int(secondTextField!)!)
            } else {
                self.checkScores(score1: 0, score2: 0)
            }
            if (self.sum1 >= 1000 && self.sum2 <= 1000) {
                winner = self.team1
            } else if ( self.sum1 <= 1000 && self.sum2 >= 1000) {
                winner = self.team2
            } else if ( self.sum1 >= 1000 && self.sum2 >= 1000 && self.sum1 > self.sum2) {
                winner = self.team1
            } else if (self.sum1 >= 1000 && self.sum2 >= 1000 && self.sum2 > self.sum1 ) {
                winner = self.team2
            }
            if (winner != "") {
                self.winneral(win: winner)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: {
            (action : UIAlertAction!) -> Void in})
        addScore.addTextField { (textField : UITextField!) -> Void in
            textField.keyboardType = UIKeyboardType.decimalPad
            textField.placeholder = self.team1
        }
        addScore.addTextField { (textField : UITextField!) -> Void in
            textField.keyboardType = UIKeyboardType.decimalPad
            textField.placeholder = self.team2
        }
        addScore.addAction(saveAction)
        addScore.addAction(cancelAction)
        self.present(addScore, animated: true, completion: nil)
        }
}
