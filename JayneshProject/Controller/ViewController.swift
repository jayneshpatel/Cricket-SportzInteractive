//
//  ViewController.swift
//  JayneshProject
//
//  Created by Jaynesh Patel on 07/10/23.
//

import UIKit

class ViewController: UIViewController {
    
    var matchData: MatchData?
    var matchDate: String = ""
    var timeDetails: String = ""
    var venueDetails: String = ""
    var tourName: String = ""
    var teamA: Team?
    var teamB: Team?
    var teamIDs: [String] = []
    var teamAArray: [Team] = []
    var teamBArray: [Team] = []
    var teamAPlayers: [Player] = []
    var teamBPlayers: [Player] = []
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 120
            tableView.register(UINib(nibName: "MatchHeaderCell", bundle: nil), forCellReuseIdentifier: "MatchHeaderCell")
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // fetchDataInBackground()
        fetchMatchDetails()
    }
    
    func formatDateTime(originalDate: String, originalTime: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        if let date = dateFormatter.date(from: originalDate), let time = timeFormatter.date(from: originalTime) {
            
            let newDateFormatter = DateFormatter()
            newDateFormatter.dateFormat = "dd MMMM yyyy - h:mm a"
            
            // Combine the date and time
            let calendar = Calendar.current
            let combinedDate = calendar.date(bySettingHour: calendar.component(.hour, from: time), minute: calendar.component(.minute, from: time), second: 0, of: date)
            
            let formattedDateTime = newDateFormatter.string(from: combinedDate ?? Date())
            
            return formattedDateTime
        } else {
            print("Failed to parse the original date or time")
            return nil
        }
    }
    
    func fetchDataInBackground() {
        // Create a background queue
        let backgroundQueue = DispatchQueue.global(qos: .background)
        
        // Execute the task on the background queue
        backgroundQueue.async { [weak self] in
            
            let urlString = "https://demo.sportz.io/nzin01312019187360.json"
            // let urlString = "https://demo.sportz.io/sapk01222019186652.json"
            
            guard let url = URL(string: urlString) else {
                print("Invalid URL")
                return
            }
            
            DispatchQueue.main.async {
                self?.spinner.startAnimating()
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let matchData = try decoder.decode(MatchData.self, from: data)
                
                // Store the fetched data
                self?.matchData = matchData
                self?.populateData(from: matchData)
                
                // Update the UI on the main thread
                DispatchQueue.main.async { [weak self] in
                    self?.spinner.stopAnimating()
                    self?.tableView.reloadData()
                }
            } catch {
                print("Error fetching or decoding data: \(error)")
                self?.spinner.stopAnimating()
            }
        }
    }
    
    func fetchMatchDetails() {
        let urlString = "https://demo.sportz.io/nzin01312019187360.json"
        // let urlString = "https://demo.sportz.io/sapk01222019186652.json"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        Task {
            do {
                spinner.startAnimating()
                self.matchData = try await APIManager().getMatchData(url: url)
                populateData(from: self.matchData!)
                tableView.reloadData()
                spinner.stopAnimating()
            } catch {
                print("\(error)")
                spinner.stopAnimating()
            }
        }
    }
    
    func extractPlayers(from team: Team) -> [Player] {
        return Array(team.players.values)
    }
    
    func populateData(from matchData: MatchData) {
        venueDetails = matchData.matchdetail.venue.name
        
        // Format the date and time
        if let formattedDate = formatDateTime(originalDate: matchData.matchdetail.match.date, originalTime: matchData.matchdetail.match.time) {
            matchDate = formattedDate
        }
        
        tourName = matchData.matchdetail.series.tourName
        
        let teamIDs = matchData.teams.keys.sorted { $0 < $1 }
        
        // You can access the team data using these IDs
        if let team1ID = teamIDs.first, let team2ID = teamIDs.last,
           let team1 = matchData.teams[team1ID], let team2 = matchData.teams[team2ID] {
            teamA = team1
            teamB = team2
            teamAArray = [team1]
            teamBArray = [team2]
        }
        
        if let teamA = teamA, let teamB = teamB {
            // Extract and store players' data in separate arrays
            teamAPlayers = extractPlayers(from: teamA)
            teamBPlayers = extractPlayers(from: teamB)
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Tableview datasource & delegate method
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if matchData != nil {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MatchHeaderCell", for: indexPath) as! MatchHeaderCell
        // Prevent cell highlighting
        cell.selectionStyle = .none
        // Assuming matchData is a property in your view controller
        if let matchData = self.matchData {
            // Configure the cell's UI elements with data
            cell.seriesLbl.text = matchData.matchdetail.series.tourName
            cell.teamALbl.text = self.teamA?.nameFull ?? ""
            cell.teamBLbl.text = self.teamB?.nameFull ?? ""
            cell.dateAndTimeLbl.text = "\(self.matchDate)"
            cell.venueLbl.text = matchData.matchdetail.venue.name
            cell.moreDetailsButton.addTarget(self, action: #selector(showTeamVC), for: .touchUpInside)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTeamVC()
    }
}

extension ViewController {
    
    @objc func showTeamVC() {
        // Instantiate the destination view controller from the storyboard
        if let destinationVC = storyboard?.instantiateViewController(withIdentifier: "TeamDataController") as? TeamDataController {
            // Safely unwrap and assign the arrays
            destinationVC.teamA = self.teamAArray
            destinationVC.teamB = self.teamBArray
            destinationVC.teamAPlayers = self.teamAPlayers
            destinationVC.teamBPlayers = self.teamBPlayers
            navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
}


