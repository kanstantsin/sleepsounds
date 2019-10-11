//
//  Player.swift
//  SleepSounds
//
//  Created by Kanstantsin Charnukha on 10/10/19.
//  Copyright © 2019 Kanstantsin Charnukha. All rights reserved.
//

import AVFoundation
import Foundation

struct Track {
  let url: URL
  let playbackTime: TimeInterval
}

final class Player {
  let tracks: [Track]
  var currentPlayer: AVAudioPlayer?
  var currentTrackIndex = 0
  var playTimer: Timer?
  var switchTimer: Timer?
  
  init(tracks: [Track]) {
    self.tracks = tracks
  }
  
  func play() {
    print("!!! \(Date()): Playing")
    currentPlayer?.stop()
    let currentTrack = tracks[currentTrackIndex]
    currentPlayer = try! AVAudioPlayer(contentsOf: currentTrack.url)
    currentPlayer?.volume = 0
    currentPlayer?.numberOfLoops = -1
    currentPlayer?.play()
    currentPlayer?.setVolume(1, fadeDuration: fadeDuration)
    assert(currentTrack.playbackTime > fadeDuration)
    playTimer = Timer.scheduledTimer(
      withTimeInterval: currentTrack.playbackTime - fadeDuration,
      repeats: false,
      block: { [currentPlayer] _ in
        currentPlayer?.setVolume(0, fadeDuration: fadeDuration)
        print("!!! \(Date()): Fading")
        self.switchTimer = Timer.scheduledTimer(
          withTimeInterval: fadeDuration,
          repeats: false,
          block: { _ in
            guard self.currentTrackIndex < self.tracks.count - 1 else { return }
            self.currentTrackIndex += 1
            self.play()
        })
    })
  }
  
  func stop() {
    currentPlayer?.stop()
    playTimer?.invalidate()
    switchTimer?.invalidate()
  }
}

private let fadeDuration: TimeInterval = 2
