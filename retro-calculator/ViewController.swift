//
//  ViewController.swift
//  retro-calculator
//
//  Created by Daniel Boga on 04/05/16.
//  Copyright © 2016 Daniel Boga. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    enum Operation: String {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    @IBOutlet weak var outputLabel: UILabel!
    
    var buttonSound: AVAudioPlayer!
    
    var runningNumber: String = ""
    var leftValStr: String = ""
    var rightValStr: String = ""
    var currentOperation: Operation = .Empty
    var result: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do {
            try buttonSound = AVAudioPlayer(contentsOfURL: soundUrl)
            buttonSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
        
        outputLabel.text = "0"
    }
    
    @IBAction func numberPressed(btn: UIButton!) {
        playButtonSound()
        runningNumber += "\(btn.tag)"
        outputLabel.text = runningNumber
    }
    
    @IBAction func onClearButtonPressed(sender: AnyObject) {
        playButtonSound()
        outputLabel.text = "0"
        runningNumber = ""
        leftValStr = ""
        rightValStr = ""
        currentOperation = .Empty
        result = ""
    }
    
    @IBAction func onDivideButtonPressed(sender: AnyObject) {
        processOperation(.Divide)
    }
    
    @IBAction func onMultiplyButtonPressed(sender: AnyObject) {
        processOperation(.Multiply)
    }
    
    @IBAction func onSubtractButtonPressed(sender: AnyObject) {
        processOperation(.Subtract)
    }
    
    @IBAction func onAddButtonPressed(sender: AnyObject) {
        processOperation(.Add)
    }
    
    @IBAction func onEqualButtonPressed(sender: AnyObject) {
        processOperation(currentOperation)
    }
    
    func processOperation(op: Operation) {
        playButtonSound()
        
        if currentOperation != Operation.Empty {
            //Run some math
            if runningNumber != "" {
                rightValStr = runningNumber
                runningNumber = ""
                
                switch currentOperation {
                case .Multiply:
                    result = "\(Double(leftValStr)! * Double(rightValStr)!)"
                case .Divide:
                    result = "\(Double(leftValStr)! / Double(rightValStr)!)"
                case .Add:
                    result = "\(Double(leftValStr)! + Double(rightValStr)!)"
                case .Subtract:
                    result = "\(Double(leftValStr)! - Double(rightValStr)!)"
                default:
                    result = "Err"
                }
                
                leftValStr = result
                
                outputLabel.text = result
            }
            
            currentOperation = op
        } else {
            //This is the first time an operator has been pressed
            leftValStr = runningNumber
            runningNumber = ""
            currentOperation = op
        }
    }
    
    func playButtonSound() {
        if buttonSound.playing {
            buttonSound.stop()
        }
        
        buttonSound.play()
    }
    
}

