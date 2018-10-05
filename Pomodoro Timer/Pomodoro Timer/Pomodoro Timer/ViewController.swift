//
//  ViewController.swift
//  Pomodoro Timer
//
//  Created by Andy Yu on 8/4/18.
//  Copyright © 2018 Andy Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var timerLabel: UILabel!
    
    var breakLength = 5
    var breakString = "00:01"
    var pomodoroLength = 10
    var pomodoroString = "00:10"
    //This variable will hold a starting value of seconds. It could be any amount above 0.
    var seconds = 10
    var timer = Timer()
    //This will be used to make sure only one timer is created at a time.
    var isTimerRunning = false
    var resumeTapped = false
    var indent = 40
    var circleY = 400
    var breakTime = false
    var pomodoroCounter = 0
    var pomodoroGoal = 5
    var longBreak = 8
    var longBreakString = "00:08"
    var layerArray = [CAShapeLayer]()
    
    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer()
            self.startButton.isEnabled = false
            startButton.setTitleColor(.gray, for: .normal)
            if breakTime == false {
                resetButton.isEnabled = true
                resetButton.setTitleColor(.black, for: .normal)
            }
            else {
                resetButton.isEnabled = false
                resetButton.setTitleColor(.gray, for: .normal)
            }
        }
    }
    
    @IBOutlet weak var startButton: UIButton!
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        pauseButton.isEnabled = true
        pauseButton.setTitleColor(.black, for: .normal)
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        if self.resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
            self.pauseButton.setTitle("resume",for: .normal)
        } else {
            runTimer()
            self.resumeTapped = false
            self.pauseButton.setTitle("pause",for: .normal)
        }
    }
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        seconds = pomodoroLength
        timerLabel.text = pomodoroString
        isTimerRunning = false
        startButton.isEnabled = true
        startButton.setTitleColor(.black, for: .normal)
        pauseButton.isEnabled = false
        pauseButton.setTitleColor(.gray, for: .normal)
    }
    @IBOutlet weak var resetButton: UIButton!
    
    func timeString(time:TimeInterval) -> String {
        //let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func pomodoroDone(width: Int) -> Void {
        if pomodoroCounter == 5 || pomodoroCounter == 10 {
            circleY += 75
        }
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: width,y: circleY), radius: CGFloat(15), startAngle: CGFloat(0), endAngle:CGFloat(Double.pi * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "circle"
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.red.cgColor
        //you can change the line width
        shapeLayer.lineWidth = 1.0
        
        view.layer.addSublayer(shapeLayer)
        layerArray.append(shapeLayer)

    }
    func deletePomodoros() {
        for layer in view.layer.sublayers! {
            if (layer.name == "circle") {
                layer.removeFromSuperlayer()
            } 
        }
        layerArray.removeAll()
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
            timer.invalidate()
            if layerArray.count == pomodoroGoal {
                sleep(1)
                seconds = longBreak
                timerLabel.text = longBreakString
                circleY = 400
                pomodoroCounter = 0
                deletePomodoros()
            }
            if breakTime == false {
                if pomodoroCounter == 0 || pomodoroCounter == 5 || pomodoroCounter == 10 {
                    indent = 40
                }
                pomodoroDone(width: indent)
                
                indent += 75
                self.startButton.setTitle("start break", for: .normal)
                
                self.seconds = breakLength
                self.timerLabel.text = breakString
            pomodoroCounter += 1
            breakTime = true
            }
            else {
            seconds = pomodoroLength
            startButton.setTitle("start", for: .normal)
            timerLabel.text = pomodoroString
            breakTime = false
            }
            isTimerRunning = false
            startButton.isEnabled = true
            startButton.setTitleColor(.black, for: .normal)
            pauseButton.isEnabled = false
            pauseButton.setTitleColor(.gray, for: .normal)
            resetButton.isEnabled = false
            resetButton.setTitleColor(.gray, for: .normal)

        }
            //Send alert to indicate "time's up!"
         else {
            seconds -= 1
            timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    //@IBOutlet weak var timerBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //colours
        view.backgroundColor = UIColor.white
        timerLabel.textColor = .black
        startButton.setTitleColor(.black, for: .normal)
        pauseButton.setTitleColor(.black, for: .normal)
        resetButton.setTitleColor(.black, for: .normal)
        /////////////////////////
        
        timerLabel.text = pomodoroString
        
        //timerBar.transform = timerBar.transform.scaledBy(x: 1, y: 20)
        
        pauseButton.isEnabled = false
        
        startButton.backgroundColor = .clear
        startButton.layer.cornerRadius = 5
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.green.cgColor
        
        pauseButton.backgroundColor = .clear
        pauseButton.layer.cornerRadius = 5
        pauseButton.layer.borderWidth = 1
        pauseButton.layer.borderColor = UIColor.black.cgColor
        
        resetButton.backgroundColor = .clear
        resetButton.layer.borderWidth = 1
        resetButton.layer.borderColor = UIColor.black.cgColor

    }



}

