//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeffrey Sulton on 3/8/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {

    // Outlets
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pausePlayButton: UIButton!
    
    // Properties
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!

    enum PlaybackMode {
        case None
        case AudioPlayer
        case AudioEngine
    }
    
    var playbackMode: PlaybackMode = PlaybackMode.None
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the AVAudioPlayer instance needed for fast/slow playback
        var error: NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: &error)
        audioPlayer.delegate = self
        audioPlayer.enableRate = true
        
        // Create the AVAudioFile instance needed for some playback
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        
        // Create the AVAudioEngine instance needed for playing various effects
        audioEngine = AVAudioEngine()
        
        // Disable the play/pause and stop buttons by default
        pausePlayButton.enabled = false;
        self.stopButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func playAudioWithRate(rate: Float) {
        stopAllAudio()
        playbackMode = PlaybackMode.AudioPlayer
        
        audioPlayer.rate = rate
        audioPlayer.play()

        // Play
        pausePlayButton.enabled = true
        stopButton.enabled = true
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopAllAudio()
        playbackMode = PlaybackMode.AudioEngine

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
        pausePlayButton.enabled = true
        stopButton.enabled = true
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: { () -> Void in
            self.pausePlayButton.enabled = false
            self.stopButton.enabled = false
        })
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func playAudioWithReverb(preset: AVAudioUnitReverbPreset, mix: Float) {
        stopAllAudio()
        playbackMode = PlaybackMode.AudioEngine

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
        pausePlayButton.enabled = true
        stopButton.enabled = true
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: { () -> Void in
            self.pausePlayButton.enabled = false
            self.stopButton.enabled = false
        })
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func playAudioWithDelay(delay: Float) {
        stopAllAudio()
        playbackMode = PlaybackMode.AudioEngine

        let echoNode = AVAudioUnitDelay()
        audioEngine.attachNode(echoNode)
        echoNode.delayTime = 0.5
        
        // Attach a player node to the engine
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        audioEngine.connect(audioPlayerNode, to: echoNode, format: nil)
        audioEngine.connect(echoNode, to: audioEngine.outputNode, format: nil)
        
        pausePlayButton.enabled = true
        stopButton.enabled = true
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: { () -> Void in
            self.pausePlayButton.enabled = false
            self.stopButton.enabled = false
        })
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func stopAllAudio() {
        if playbackMode == PlaybackMode.AudioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
        else if playbackMode == PlaybackMode.AudioPlayer {
            audioPlayer.stop()
            audioPlayer.currentTime = 0
        }
        
        pausePlayButton.enabled = false
        stopButton.enabled = false
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        // Finished playing, so disable the stop and pause buttons
        pausePlayButton.enabled = false
        stopButton.enabled = false
    }

    // MARK: - Interface Builder Actions

    @IBAction func playAudioFast(sender: AnyObject) {
        println("Playing fast")
        playAudioWithRate(2.0)
        pausePlayButton.enabled = true
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
        if playbackMode == PlaybackMode.AudioEngine {
            audioEngine.stop()
        }
        else if playbackMode == PlaybackMode.AudioPlayer {
            audioPlayer.stop()
        }
        
        pausePlayButton.enabled = false
        stopButton.enabled = false

        pausePlayButton.setImage(UIImage(named: "pause2x-iphone"), forState: UIControlState.Normal)
    }
    
    @IBAction func toggleAudio(sender: AnyObject) {
        var pause = false
        
        if playbackMode == PlaybackMode.AudioEngine {
            if audioEngine.running {
                audioEngine.pause()
                pause = true
            }
            else {
                audioEngine.startAndReturnError(nil)
                pause = false
            }
        }
        else if playbackMode == PlaybackMode.AudioPlayer {
            if audioPlayer.playing {
                audioPlayer.pause()
                pause = true
            }
            else {
                audioPlayer.play()
                pause = false
            }
        }
        
        if pause == true {
            pausePlayButton.setImage(UIImage(named: "stop2x-iphone"), forState: UIControlState.Normal)
        }
        else {
            pausePlayButton.setImage(UIImage(named: "pause2x-iphone"), forState: UIControlState.Normal)
        }
    }
}
