//
//  RecordViewController.swift
//  Pitch Perfect
//
//  Created by Jeffrey Sulton on 3/7/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordingStatus: UILabel!
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var microphone: UIButton!
    
    var recording: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startRecording(sender: AnyObject) {
        if (!recording)
        {
            println("Start recording")
            recordingStatus.text = "Recording...";
            startStopButton.imageView?.image = UIImage(named: "stop2x-iphone")
            startStopButton.hidden = false
            microphone.enabled = false
            recording = true
        }
        else
        {
            recordingStatus.text = "Tap to start recording";
            startStopButton.hidden = true
            recording = false
        }
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        recordingStatus.text = "Tap to start recording";
        startStopButton.hidden = true
        microphone.enabled = true
        recording = false
    }
}
