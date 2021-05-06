//
//  ViewController.swift
//  Stopwatch
//
//  Created by vivek shrivastwa on 06/05/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lapTimer: UILabel!
    @IBOutlet weak var mainTimer: UILabel!
    @IBOutlet weak var lapButtonOutlet: UIButton!
    @IBOutlet weak var startButtonOutlet: UIButton!
    @IBOutlet weak var lapTableView: UITableView!
   
    var timer: Timer?
    var timer2: Timer?
    
    var tableValue = [String]()
    
    var isPlay = false
    var counter = 0.0
    var minuteCounter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initCircleButton: (UIButton) -> Void = { button in
          button.layer.cornerRadius = 0.5 * button.bounds.size.width
          button.backgroundColor = UIColor.white
        }
        
        initCircleButton(lapButtonOutlet)
        initCircleButton(startButtonOutlet)
        
        lapButtonOutlet.isEnabled = false
        startButtonOutlet.isEnabled = true
        
        lapTableView.delegate = self
        lapTableView.dataSource = self
    }


    @IBAction func lapButtonAction(_ sender: UIButton) {
        if !isPlay {
          setButtonTitle(button:lapButtonOutlet, title: "Lap", color: UIColor.lightGray)
            lapTimer.text = "00:00.0"
            mainTimer.text = "00:00.0"
            tableValue = []
            lapTableView.reloadData()
          lapButtonOutlet.isEnabled = false
            isPlay = !isPlay
        } else {
          if let timerLabelText = mainTimer.text {
            tableValue.append(timerLabelText)
          }
          lapTableView.reloadData()
        
          unowned let weakSelf = self
            lapTimer.text = "0:00.0"
//            timer = Timer.scheduledTimer(timeInterval: 0.1, target: weakSelf, selector: #selector(updateLapTimer), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        if !isPlay{
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            timer2 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateLapTimer), userInfo: nil, repeats: true)
            
            lapButtonOutlet.isEnabled = true
            setButtonTitle(button: startButtonOutlet, title: "stop", color: UIColor.systemRed)
            setButtonTitle(button: lapButtonOutlet, title: "Lap", color: UIColor.systemGray)
            isPlay = !isPlay
        }
        else{
            timer?.invalidate()
            timer2?.invalidate()
            lapButtonOutlet.isEnabled = true
            setButtonTitle(button: lapButtonOutlet, title: "Reset", color: UIColor.systemGray)
            setButtonTitle(button: startButtonOutlet, title: "Start", color: UIColor.systemGreen)
            isPlay = !isPlay
        }
    }
    
    @objc func updateTimer() {
        
        if counter > 59.0{
            minuteCounter += 1
            counter = 0.0
        }
        else{
            counter += 0.1
        }
        let second = String(format: "%.1f",counter)
        let minute = minuteCounter
        mainTimer.text = "\(minute):\(second)"
    }
    
    @objc func updateLapTimer() {
        if counter > 59.0{
            minuteCounter += 1
            counter = 0.0
        }
        else{
            counter += 0.1
        }
        let second = String(format: "%.1f",counter)
        let minute = minuteCounter
        lapTimer.text = "\(minute):\(second)"
    }
    
    func setButtonTitle(button:UIButton, title:String, color:UIColor){
        button.setTitle(title, for: .normal)
        button.setTitleColor(color, for: .normal)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timerCell", for: indexPath)
        cell.textLabel!.text = tableValue[indexPath.row]
        return cell
    }
    
    
}
