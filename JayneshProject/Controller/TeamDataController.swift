//
//  TeamDataController.swift
//  JayneshProject
//
//  Created by Jaynesh Patel on 07/10/23.
//

import UIKit

class TeamDataController: UIViewController {
    
    var teamA: [Team] = []
    var teamB: [Team] = []
    var teamAPlayers: [Player] = []
    var teamBPlayers: [Player] = []
    var allPlayers: [Player] = []
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.estimatedRowHeight = 60
        tableView.register(UINib(nibName: "PlayerInfoCell", bundle: nil), forCellReuseIdentifier: "PlayerInfoCell")
        
        if let teamAName = teamA.first?.nameShort {
            segmentedControl.setTitle(teamAName, forSegmentAt: 0)
        }
        if let teamBName = teamB.first?.nameShort {
            segmentedControl.setTitle(teamBName, forSegmentAt: 2)
        }
        segmentedControl.setTitle("All Players", forSegmentAt: 1) // Add "All Players" segment
        segmentedControl.selectedSegmentIndex = 0
        updateTableViewData()
    }
    
    private func updateTableViewData() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            // Show Team A players
            allPlayers = teamAPlayers + teamBPlayers
        case 1:
            // Show All Players (combine Team A and Team B players)
            allPlayers = teamAPlayers + teamBPlayers
        case 2:
            // Show Team B players
            allPlayers = teamBPlayers + teamAPlayers
        default:
            break
        }
        
        tableView.reloadData()
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: Any) {
        updateTableViewData()
    }
}

extension TeamDataController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Tableview datasource & delegate method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            return teamAPlayers.count
        case 1:
            return allPlayers.count
        case 2:
            return teamBPlayers.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerInfoCell", for: indexPath) as! PlayerInfoCell
        cell.selectionStyle = .none
        var player: Player
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            player = teamAPlayers[indexPath.row]
        case 1:
            player = allPlayers[indexPath.row]
        case 2:
            player = teamBPlayers[indexPath.row]
        default:
            return UITableViewCell()
        }
        
        cell.configure(with: player)
        
        if let isCaptain = player.iscaptain, isCaptain {
            if let isKeeper = player.iskeeper, isKeeper {
                cell.backgroundColor = UIColor.orange
            } else {
                cell.backgroundColor = UIColor.yellow
            }
        } else {
            if let isKeeper = player.iskeeper, isKeeper {
                cell.backgroundColor = UIColor.green
            } else {
                cell.backgroundColor = UIColor.white
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPlayer: Player
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            selectedPlayer = teamAPlayers[indexPath.row]
        case 1:
            selectedPlayer = allPlayers[indexPath.row]
        case 2:
            selectedPlayer = teamBPlayers[indexPath.row]
        default:
            return
        }
        
        let alertController = UIAlertController(title: "Player Information", message: nil, preferredStyle: .alert)
        
        alertController.message = "Player Name: \(selectedPlayer.nameFull)"
        
        alertController.message?.append("\nBatting Style: \(selectedPlayer.batting.style.rawValue)")
        alertController.message?.append("\nBatting Average: \(selectedPlayer.batting.average)")
        alertController.message?.append("\nBatting Strike Rate: \(selectedPlayer.batting.strikerate)")
        alertController.message?.append("\nTotal Runs: \(selectedPlayer.batting.runs)")
        
        alertController.message?.append("\nBowling Style: \(selectedPlayer.bowling.style)")
        alertController.message?.append("\nBowling Average: \(selectedPlayer.bowling.average)")
        alertController.message?.append("\nBowling Economy Rate: \(selectedPlayer.bowling.economyrate)")
        alertController.message?.append("\nTotal Wickets: \(selectedPlayer.bowling.wickets)")
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
