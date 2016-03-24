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
    
    var echoAudioPlayer:AVAudioPlayer!
    
    @IBOutlet var playButton: UIButton!
    var audioPlayer: AVAudioPlayer?
    
    var reverbPlayers:[AVAudioPlayer] = []
    let N:Int = 10
    
    var rate: Float = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioEngine = AVAudioEngine()
        audioFile = try! AVAudioFile(forReading: receivedAudio.filePathUrl)
        
        audioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        echoAudioPlayer = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
        
        
        for _ in 0...N {
            let temp = try! AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl)
            reverbPlayers.append(temp)
        }
        
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
    
    @IBAction func playEcho(sender: AnyObject) {
        
        audioPlayer!.stop()
        audioPlayer!.currentTime = 0;
        audioPlayer!.play()
        
        let delay:NSTimeInterval = 0.2
        var playtime:NSTimeInterval
        playtime = echoAudioPlayer.deviceCurrentTime + delay
        echoAudioPlayer.stop()
        echoAudioPlayer.currentTime = 0
        echoAudioPlayer.volume = 0.8
        echoAudioPlayer.playAtTime(playtime)
        
        
    }
    
    @IBAction func playReverb(sender: AnyObject) {
        let delay:NSTimeInterval = 0.02
        for i in 0...N {
            let curDelay:NSTimeInterval = delay*NSTimeInterval(i)
            let player:AVAudioPlayer = reverbPlayers[i]
            //M_E is e=2.718...
            //dividing N by 2 made it sound ok for the case N=10
            let exponent:Double = -Double(i)/Double(N/2)
            let volume = Float(pow(Double(M_E), exponent))
            player.volume = volume
            player.playAtTime(player.deviceCurrentTime + curDelay)
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
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.playButton.setTitle("PLAY", forState: UIControlState.Normal)
        
    }
}


