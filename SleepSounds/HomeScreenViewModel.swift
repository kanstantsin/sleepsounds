//
//  HomeScreenViewModel.swift
//  SleepSounds
//
//  Created by Kanstantsin Charnukha on 10/11/19.
//  Copyright © 2019 Kanstantsin Charnukha. All rights reserved.
//

import Foundation

struct HomeScreenViewModel {
  enum PlaybackState {
    case stopped
    case paused
    case playing
  }
  
  var wakeUpTimeText: String
  var wakeUpTimeDate: Date
  var startText: String
  var stopText: String
  var playbackState: PlaybackState
}
