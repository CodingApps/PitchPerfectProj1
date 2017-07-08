//
//  RecordSoundsViewController.swift
//  PItchPerfectV2
//  Updated name
//
//  Created by Rick Mc on 6/11/17.
//  Copyright © 2017 Rick Mc. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController : UIViewController, AVAudioRecorderDelegate  {
    
    var audioRecorder: AVAudioRecorder!

    @IBOutlet weak var recordingLabel: UILabel!
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LabelSetting(Bool1: false, Bool2: true, Text: "Tap to Record" )
    
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewwillAppear called")
    }

  //  override func didReceiveMemoryWarning() {
  //      super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
  //  }

    @IBAction func RecordAudio(_ sender: AnyObject) {
        
         LabelSetting(Bool1: true, Bool2: false, Text: "Recording in Progress")
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:.defaultToSpeaker)
        

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(_ sender: AnyObject) {
        LabelSetting(Bool1: true, Bool2: true, Text: "Stop Recording")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    

    func LabelSetting(Bool1:Bool, Bool2:Bool, Text:String ) {
        recordingLabel.text = Text
        stopRecordingButton.isEnabled = Bool1
        recordButton.isEnabled = Bool2
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder,
                                         successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as!PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}


