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

    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!
    
    // Create audio engine
    var audioEngine: AVAudioEngine!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the AVAudioPlayer instance needed for fast/slow playback
        var error: NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: &error)
        audioPlayer.enableRate = true
        
        // Create the AVAudioFile instance needed for some playback
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
        // Create the AVAudioEngine instance needed for playing various effects
        audioEngine = AVAudioEngine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudioWithRate(rate: Float) {
        stopAllAudio()
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        // Stop any currently playing audio
        stopAllAudio()

        // Attach a player node
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // Attach a pitch node with the desired pitch
        var audioTimePitch = AVAudioUnitTimePitch()
        audioTimePitch.pitch = pitch
        audioEngine.attachNode(audioTimePitch)
        
        // Connect the player to the pitch node
        audioEngine.connect(audioPlayerNode, to: audioTimePitch, format: nil)
        
        // Connect the pitch node to the player
        audioEngine.connect(audioTimePitch, to: audioEngine.outputNode, format: nil)
        
        // Play
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func playAudioWithReverb(preset: AVAudioUnitReverbPreset, mix: Float) {
        // Stop any currently playing audio
        stopAllAudio()
        
        // Create the unit and set the effect
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(preset)
        reverbNode.wetDryMix = mix

        // Attach the effect to the engine
        audioEngine.attachNode(reverbNode)
        
        // Attach a player node to the engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.connect(audioPlayerNode, to: reverbNode, format: nil)
        audioEngine.connect(reverbNode, to: audioEngine.outputNode, format: nil)
        
        // Play
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func playAudioWithDelay(delay: Float) {
        stopAllAudio()
        
        let echoNode = AVAudioUnitDelay()
        audioEngine.attachNode(echoNode)
        echoNode.delayTime = 0.5
        
        // Attach a player node to the engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.connect(audioPlayerNode, to: echoNode, format: nil)
        audioEngine.connect(echoNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func stopAllAudio() {
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer.stop()
        audioPlayer.currentTime = 0
    }
    
    @IBAction func playAudioFast(sender: AnyObject) {
        println("Playing fast")
        playAudioWithRate(2.0)
    }
    
    @IBAction func playSlowly(sender: AnyObject) {
        println("Playing slowly")
        playAudioWithRate(0.5)
    }
    
    @IBAction func playChipmunk(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVader(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)
    }
    
    @IBAction func playEcho(sender: AnyObject) {
        playAudioWithDelay(0.25)
    }

    @IBAction func playReverb(sender: AnyObject) {
        playAudioWithReverb(AVAudioUnitReverbPreset.Cathedral, mix: 75.0)
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
