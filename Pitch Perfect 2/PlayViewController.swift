//
//  PlayViewController.swift
//  Pitch Perfect 2
//
//  Created by Ben Wong on 2016-03-23.
//  Copyright © 2016 Ben Wong. All rights reserved.
//


import UIKit
import AVFoundation

var audioURL : NSURL?

class PlayViewController: UIViewController, AVAudioPlayerDelegate {
    
    var recordedAudio:RecordedAudio!
    var receivedAudio: RecordedAudio!
    
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var audioFile:AVAudioFile!
    
    
    @IBOutlet var playButton: UIButton!
    var audioPlayer: AVAudioPlayer?
    
    var rate: Float = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        
        print(audioFile)
        
        
        
    }
    
    @IBAction func playTapped(sender: AnyObject) {
        if self.audioPlayer == nil {
            setUpAndPlay(1.0)
        } else {
            if self.audioPlayer!.playing {
                self.audioPlayer!.stop()
                self.playButton.setTitle("PLAY", forState: UIControlState.Normal)
                
            } else {
                setUpAndPlay(1.0)
            }
        }
        
    }
    
    @IBAction func playChipmunk(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    
    
    @IBAction func playDarthVader(sender: AnyObject) {
        playAudioWithVariablePitch(-1000)

    }

    
    @IBAction func playSlow(sender: AnyObject) {
        if self.audioPlayer == nil {
            setUpAndPlay(0.5)
        } else {
            if self.audioPlayer!.playing {
                self.audioPlayer!.stop()
                self.playButton.setTitle("PLAY", forState: UIControlState.Normal)
                
            } else {
                setUpAndPlay(0.5)
            }
        }
    }
    
    @IBAction func playFast(sender: AnyObject) {
        if self.audioPlayer == nil {
            setUpAndPlay(2.0)
        } else {
            if self.audioPlayer!.playing {
                self.audioPlayer!.stop()
                self.playButton.setTitle("PLAY", forState: UIControlState.Normal)
                
            } else {
                setUpAndPlay(2.0)
            }
        }
    }
    
    func playAudioWithVariablePitch(pitch: Float){
        
        audioPlayer?.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        try! audioEngine.start()
        
        audioPlayerNode.play()    }
    
    func setUpAndPlay(rate: Float){
        do {
            
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
            self.audioPlayer!.enableRate = true
            self.audioPlayer!.rate = rate
            self.audioPlayer!.delegate = self
            self.audioPlayer!.play()
            self.playButton.setTitle("STOP", forState: UIControlState.Normal)
        } catch {}
    }
}


