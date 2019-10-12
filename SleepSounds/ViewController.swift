//
//  ViewController.swift
//  SleepSounds
//
//  Created by Kanstantsin Charnukha on 10/10/19.
//  Copyright © 2019 Kanstantsin Charnukha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  enum Cell: Int, CaseIterable {
    case start
    case date
  }
  
  var homeScreenView: HomeScreenView!
  var wakeUpDate = Date().addingTimeInterval(60)
  var currentPlayer: Player?
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let initialModel = HomeScreenViewModel(
      wakeUpTimeText: "When would you like to wake up?",
      wakeUpTimeDate: Date().addingTimeInterval(60),
      startText: "Start",
      stopText: "Stop",
      playbackState: .stopped
    )
    homeScreenView = HomeScreenView(frame: view.bounds, model: initialModel)
    view.addSubview(homeScreenView)
    NSLayoutConstraint.activate([
      homeScreenView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      homeScreenView.topAnchor.constraint(equalTo: view.topAnchor),
      homeScreenView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      homeScreenView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    homeScreenView.onStartStopButtonTap = onStartStop
    homeScreenView.onDateChanged = { [weak self] date in
      guard let self = self else { return }
      self.wakeUpDate = date
      self.homeScreenView.model.wakeUpTimeDate = date
    }
  }
  
  private func onStartStop() {
    switch homeScreenView.model.playbackState {
    case .stopped, .paused:
      start()
      homeScreenView.model.playbackState = .playing
    case .playing:
      currentPlayer?.stop()
      homeScreenView.model.playbackState = .stopped
    }
  }
  
  private func start() {
    let sounds = [
      "rain-01",
      "fire-1",
      "birds"
    ]
    
    let tracks = TracksFactory.makeTracks(wakeUpDate: wakeUpDate, sounds: sounds)
    
    currentPlayer?.stop()
    currentPlayer = Player(tracks: tracks)
    currentPlayer?.play()
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
}

