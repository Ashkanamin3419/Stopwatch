//
//  ViewController.swift
//  Stopwatch
//
//  Created by Ashkan Amin on 1/16/20.
//  Copyright © 2020 Ashkan Amin. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var timerLabel: UILabel!
    lazy var timer = Timer()
    lazy var lapsTimer = Timer()
    lazy var isTimerRunning = false
    lazy var counter = 0.0
    lazy var lapCounter = 0
    lazy var lapTimeCounter = 0.0
    lazy var laps = [Lap]()
    lazy var lapsArray = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.layer.cornerRadius = 0.5 * startButton.bounds.size.width
        startButton.clipsToBounds = true
        resetButton.layer.cornerRadius = 0.5 * resetButton.bounds.size.width
        resetButton.clipsToBounds = true
//        tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
        // Do any additional setup after loading the view.
    }
    @IBAction func startButtonDidTouch(_ sender: UIButton) {
        if !isTimerRunning {
            sender.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 0.5997431507)
            sender.setTitle("Pause", for: .normal)
            sender.setTitleColor(#colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), for: .normal)
            resetButton.setTitle("Lap", for: .normal)
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runtimer), userInfo: nil, repeats: true)
            isTimerRunning = true
            lapsTimer.invalidate()
            lapsTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runtimerForLap), userInfo: nil, repeats: true)
        }else {
            isTimerRunning = false
            timer.invalidate()
            sender.backgroundColor = #colorLiteral(red: 0.3098039216, green: 0.5607843137, blue: 0, alpha: 0.7418396832)
            sender.setTitle("Start", for: .normal)
            sender.setTitleColor(#colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1), for: .normal)
            resetButton.setTitle("Reset", for: .normal)
        }
            
        }
        @objc func runtimer() {
            
            counter += 0.1
            // HH:MM:SS
            let flooredCounter = Int(floor(counter))
            let hour = flooredCounter / 3600
            var hourString = "\(hour)"
            if hour < 10 {
                hourString = "0\(hourString)"
            }
            let minute = (flooredCounter % 3600) / 60
            var minuteString = "\(minute)"
            if minute < 10 {
                minuteString = "0\(minuteString)"
            }
            let second = (flooredCounter % 3600) % 60
            var secondString = "\(second)"
            if second < 10 {
                secondString = "0\(second)"
            }
            let deciSecond = String(format: "%.1f", counter).components(separatedBy: ".").last!
            timerLabel.text = "\(hourString):\(minuteString):\(secondString).\(deciSecond)"
        }
    @objc func runtimerForLap(){
        lapTimeCounter += 0.1
        // HH:MM:SS
        let flooredCounter = Int(floor(lapTimeCounter))
        let hour = flooredCounter / 3600
        var hourString = "\(hour)"
        if hour < 10 {
            hourString = "0\(hourString)"
        }
        let minute = (flooredCounter % 3600) / 60
        var minuteString = "\(minute)"
        if minute < 10 {
            minuteString = "0\(minuteString)"
        }
        let second = (flooredCounter % 3600) % 60
        var secondString = "\(second)"
        if second < 10 {
            secondString = "0\(second)"
        }
        let deciSecond = String(format: "%.1f", counter).components(separatedBy: ".").last!
        lapsArray.append("\(hourString):\(minuteString):\(secondString).\(deciSecond)")
        
    }
        
    
    @IBAction func resetButtonDidTouch(_ sender: UIButton) {
        if !isTimerRunning {
            //when button title is reset
            timer.invalidate()
            isTimerRunning = false
            counter = 0.0
            lapTimeCounter = 0.0
            timerLabel.text = "00:00:00.0"
            startButton.isEnabled = true
            lapsArray.removeAll()
            laps.removeAll()
            tableView.reloadData()
            updateTableContentInset()
        }else{
            //when button title is Lap
            lapCounter += 1
            
            
            print("Lap \(lapCounter):\(timerLabel.text!)")
            
                lapsTimer.invalidate()
                lapTimeCounter = 0.0
                lapsTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runtimerForLap), userInfo: nil, repeats: true)
                laps.append(Lap(numberOfLap: lapCounter, lap: lapsArray.last, orginalLap: timerLabel.text!))
                lapsArray.removeAll()
                tableView.reloadData()
            updateTableContentInset()
                
            
            
        }
        
    }


    @IBAction func saveButtondidTouch(_ sender: UIBarButtonItem) {
    }
    
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as! LapTableViewCell
        let lap = laps[indexPath.item]
        if lap.numberOfLap! == 1 {
            cell.orginalTime.isHidden = true
        }else{
            cell.orginalTime.isHidden = false
        }
        cell.lapCounterLabel.text = "Lap \(lap.numberOfLap!)"
        cell.lapsTimeLabel.text = lap.lap
        cell.orginalTime.text = lap.orginalLap
        
//        cell.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        return cell
    }
    func updateTableContentInset() {
        let numRows = tableView(self.tableView, numberOfRowsInSection: 0)
        var contentInsetTop = self.tableView.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tableView.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
            }
            self.tableView.scrollToRow(at: IndexPath(item: i, section: 0), at: UITableView.ScrollPosition.bottom, animated: false)
        }
        self.tableView.contentInset = UIEdgeInsets(top: contentInsetTop,left: 0,bottom: 0,right: 0)
        
    }

}

