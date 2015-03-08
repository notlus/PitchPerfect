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
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var recording: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        startButton.enabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startRecording(sender: AnyObject) {
        println("Start recording")
        recordingStatus.text = "Recording...";
        stopButton.imageView?.image = UIImage(named: "stop2x-iphone")
        stopButton.hidden = false
        startButton.enabled = false
        recording = true
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        recordingStatus.text = "Tap to start recording";
        stopButton.hidden = true
        startButton.enabled = true
        recording = false
    }
}
