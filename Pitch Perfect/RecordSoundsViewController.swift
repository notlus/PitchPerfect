//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeffrey Sulton on 3/7/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // Outlets
    @IBOutlet weak var recordingStatus: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    // Properties
    var audioRecorder: AVAudioRecorder!
    var paused: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        startButton.enabled = true
        pauseButton.hidden = true
        paused = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getAudioFilePath() -> NSURL? {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyy-HHmmss"
        let audioFileName = formatter.stringFromDate(now) + ".wav"
        
        let pathComponents = [dirPath, audioFileName]
        let fileURL = NSURL.fileURLWithPathComponents(pathComponents)
        
        return fileURL
    }

    @IBAction func startRecording(sender: AnyObject) {
        recordingStatus.text = "Recording";
        stopButton.imageView?.image = UIImage(named: "stop2x-iphone")
        stopButton.hidden = false
        pauseButton.hidden = false
        startButton.enabled = false
        
        if !paused {
            if let audioFile = getAudioFilePath() {
                // Start recording
                println(audioFile)
                let session = AVAudioSession.sharedInstance()
                session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
                audioRecorder = AVAudioRecorder(URL: audioFile, settings: nil, error: nil)
                audioRecorder.delegate = self
                audioRecorder.meteringEnabled = true
                audioRecorder.prepareToRecord()
                audioRecorder.record()
            }
        }
        else {
            // Recording has been paused, start it again
            audioRecorder.record()
            paused = false
        }
    }
    
    @IBAction func stopRecording(sender: AnyObject) {
        recordingStatus.text = "Tap to start recording";
        stopButton.hidden = true
        startButton.enabled = true
        audioRecorder.stop()
        paused = false
        let session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    @IBAction func pauseRecording(sender: AnyObject) {
        audioRecorder.pause()
        recordingStatus.text = "Tap to resume recording"
        startButton.enabled = true
        paused = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            let recordedAudio = RecordedAudio(filePath: recorder.url, title: recorder.url.lastPathComponent!)
            
            // Recorded successfully
            performSegueWithIdentifier("playRecordedAudio", sender: recordedAudio)
        }
        else {
            println("Failed to record audio")
            stopButton.hidden = true
            startButton.enabled = true
        }
        paused = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let playSoundsVC = segue.destinationViewController as PlaySoundsViewController
        let recordedData = sender as RecordedAudio
        playSoundsVC.receivedAudio = recordedData
    }
}
