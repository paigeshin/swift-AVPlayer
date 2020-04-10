//
//  ViewController.swift
//  AVAudioPlayer
//
//  Created by shin seunghyun on 2020/04/09.
//  Copyright © 2020 shin seunghyun. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    let url: URL = URL(string: "https://firebasestorage.googleapis.com/v0/b/chatting-app-bd8a6.appspot.com/o/audio.mp3?alt=media&token=59a64f38-5b0c-4723-9758-cbaf4d4f17a8")!
    var asset: AVAsset!
    var player: AVPlayer!
    var playerItem: AVPlayerItem!
    
    private var playerItemContext = 0
    
    let requiredAssetKeys: [String] = [
        "playable",
        "hasProtectedContent"
    ]

    var isPlayed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareToPlay()
    }
    
    func prepareToPlay() {
        // Create the asset to play
        asset = AVAsset(url: url)

        // Create a new AVPlayerItem with the asset and an
        // array of asset keys to be automatically loaded
        playerItem = AVPlayerItem(asset: asset,
                                  automaticallyLoadedAssetKeys: requiredAssetKeys)

        // Register as an observer of the player item's status property
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: &playerItemContext)
                                /*
                                    ampersand: It works as an inout to make the variable an in-out parameter. In-out means in fact passing value by reference, not by value. And it requires not only to accept value by reference, by also to pass it by reference, so pass it with & - foo(&myVar) instead of just foo(myVar)
                                */
        
        // Associate the player item with the player
        player = AVPlayer(playerItem: playerItem)
        
    }
    
    @IBAction func playButtonPressed(_ sender: UIButton) {
        if !isPlayed {
            player.play()
            isPlayed = true
        } else {
            player.rate = 0
            isPlayed = false
        }
        
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }

        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }

            // Switch over status value
            switch status {
            case .readyToPlay:
                // Player item is ready to play.
                print("music ready to play")
            case .failed:
                // Player item failed. See error.
                print("failed to play")
            case .unknown:
                // Player item is not yet ready.
                print("not yet ready")
            default:
                print("No Action")
            }
        }
        
    }


}

