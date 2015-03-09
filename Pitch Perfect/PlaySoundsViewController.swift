//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeffrey Sulton on 3/8/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer = AVAudioPlayer()
    var receivedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        if let songPath = NSBundle.mainBundle().pathForResource("sound", ofType: "mp3") {
//            var songURL = NSURL(fileURLWithPath: songPath)
//            println(songURL)
//            
//            var error: NSError?
//            audioPlayer = AVAudioPlayer(contentsOfURL: songURL, error: &error)
//            audioPlayer.enableRate = true
//        }
//        else {
//            println("Failed to get path to file")
//        }
        
        var error: NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: &error)
        audioPlayer.enableRate = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudioWithRate(rate: Float) {
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    @IBAction func playAudioFast(sender: AnyObject) {
        println("Playing fast")
        playAudioWithRate(2.0)
    }
    
    @IBAction func playSlowly(sender: AnyObject) {
        println("Playing slowly")
        playAudioWithRate(0.5)
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        audioPlayer.stop()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
