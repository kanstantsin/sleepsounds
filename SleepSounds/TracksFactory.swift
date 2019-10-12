//
//  TracksFactory.swift
//  SleepSounds
//
//  Created by Kanstantsin Charnukha on 10/12/19.
//  Copyright © 2019 Kanstantsin Charnukha. All rights reserved.
//

import Foundation

enum TracksFactory {
  static func makeTracks(wakeUpDate: Date, sounds: [String]) -> [Track] {
    let futureWakeUpDate = wakeUpDate < Date() ? wakeUpDate.addingTimeInterval(60 * 60 * 24) : wakeUpDate
    
    let intervalTillWakeUp = futureWakeUpDate.timeIntervalSinceNow
    let intervalForTrack = intervalTillWakeUp / TimeInterval(sounds.count)
    let lastTrackInterval = min(60 * 30, intervalForTrack)
    let firstTracksInterval = (intervalTillWakeUp - lastTrackInterval) / (TimeInterval(sounds.count - 1))
    print("Intervals: \(firstTracksInterval) x \(sounds.count - 1) + \(lastTrackInterval)")
    var tracks = sounds.dropLast().map { Track(url: $0.mp3ResourceUrl, playbackTime: firstTracksInterval) }
    tracks.append(Track(url: sounds.last!.mp3ResourceUrl, playbackTime: lastTrackInterval))
    return tracks
  }
}

private extension String {
  var mp3ResourceUrl: URL {
    let urlString = Bundle.main.path(forResource: self, ofType: "mp3")!
    return URL(fileURLWithPath: urlString)
  }
}
