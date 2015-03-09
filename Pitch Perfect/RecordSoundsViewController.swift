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
    
    var audioRecorder: AVAudioRecorder!
    
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
        recordingStatus.text = "Recording...";
        stopButton.imageView?.image = UIImage(named: "stop2x-iphone")
        stopButton.hidden = false
        startButton.enabled = false
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
    
    @IBAction func stopRecording(sender: AnyObject) {
        recordingStatus.text = "Tap to start recording";
        stopButton.hidden = true
        startButton.enabled = true
        audioRecorder.stop()
        let session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            let recordedAudio = RecordedAudio()
            recordedAudio.title = recorder.url.lastPathComponent
            recordedAudio.filePathURL = recorder.url
            
            // Recorded successfully
            performSegueWithIdentifier("playRecordedAudio", sender: recordedAudio)
        }
        else {
            println("Failed to record audio")
            stopButton.hidden = true
            startButton.enabled = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let playSoundsVC = segue.destinationViewController as PlaySoundsViewController
        let recordedData = sender as RecordedAudio
        playSoundsVC.receivedAudio = recordedData
    }
}
