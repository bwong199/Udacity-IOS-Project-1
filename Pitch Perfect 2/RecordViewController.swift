//
//  RecordViewController.swift
//  Pitch Perfect 2
//
//  Created by Ben Wong on 2016-03-23.
//  Copyright © 2016 Ben Wong. All rights reserved.
//

import UIKit
import AVFoundation
class RecordViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var rate: Float = 1.0
    var audioURL : NSURL?
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    
    var recordedAudio:RecordedAudio!
    
    
    @IBOutlet var playButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpAudioRecorder()
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        stopButton.enabled = false

    }
    
    func setUpAudioRecorder(){
        
        do {
            let basePath : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
            
            let pathComponents = [basePath, "theAudio.m4a"]
            
            
            self.audioURL = NSURL.fileURLWithPathComponents(pathComponents)
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
            try session.setActive(true)
            
            var recordSettings = [String: AnyObject]()
            recordSettings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
            recordSettings[AVSampleRateKey] = 44100.0
            recordSettings[AVNumberOfChannelsKey] = 2
            
            self.audioRecorder = try AVAudioRecorder(URL: self.audioURL!, settings: recordSettings)
            self.audioRecorder!.meteringEnabled = true
            self.audioRecorder!.prepareToRecord()
            
        } catch {
            
        }
        
    }
    
    
    @IBAction func recordTapped(button: AnyObject) {
        //
        //        if self.audioRecorder!.recording {
        //            self.audioRecorder!.stop()
        //            button.setTitle("RECORD", forState: UIControlState.Normal)
        //        } else {
        
        if !self.audioRecorder!.recording {
            do {
                try AVAudioSession.sharedInstance().setActive(true)
                self.audioRecorder?.delegate = self
                self.audioRecorder!.record()

                // While recording, stop button is enabled, record button is disabled and record button alpha is set to 0.5
                stopButton.enabled = true
                recordButton.enabled = false
                recordButton.alpha = 0.5
                
            } catch {}
            
        }
        
        //
        //        }
    }
    
    @IBAction func stopTapped(button: AnyObject) {
        if self.audioRecorder!.recording {
            self.audioRecorder!.stop()
            //        button.setTitle("RECORD", forState: UIControlState.Normal)
            stopButton.enabled = false
            stopButton.alpha = 0.5
        } else {
            
        }
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        
        
        
        if(flag){
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url
            print("Recorded successfully")
            self.performSegueWithIdentifier("toPlaySegue", sender: recordedAudio)
        }else {
            print("Recorded not successful")
            
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "toPlaySegue"){
            let playViewController = segue.destinationViewController as! PlayViewController
            playViewController.receivedAudio  = recordedAudio
        }
    }
    
    
    
    @IBAction func playTapped(sender: AnyObject) {
        if self.audioPlayer == nil {
            setUpAndPlay()
        } else {
            if self.audioPlayer!.playing {
                self.audioPlayer!.stop()
                self.playButton.setTitle("PLAY", forState: UIControlState.Normal)
                
            } else {
                setUpAndPlay()
            }
        }
        
    }
    
    func setUpAndPlay(){
        do {
            
            self.audioPlayer = try AVAudioPlayer(contentsOfURL: self.audioURL!)
            self.audioPlayer!.enableRate = true
            self.audioPlayer!.rate = self.rate
            self.audioPlayer!.delegate = self
            self.audioPlayer!.play()
            self.playButton.setTitle("STOP", forState: UIControlState.Normal)
        } catch {}
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.playButton.setTitle("PLAY", forState: UIControlState.Normal)
    }
        
}



