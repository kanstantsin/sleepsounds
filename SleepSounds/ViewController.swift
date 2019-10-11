//
//  ViewController.swift
//  SleepSounds
//
//  Created by Kanstantsin Charnukha on 10/10/19.
//  Copyright © 2019 Kanstantsin Charnukha. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {
}

class DateCell: UITableViewCell {
  var datePicker: UIDatePicker!
  var onDateChanged: ((Date) -> ())?
  var date: Date {
    get {
      return datePicker.date
    }
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    datePicker = UIDatePicker(frame: .zero)
    datePicker.datePickerMode = .time
    contentView.addSubview(datePicker)
    NSLayoutConstraint.activate([
      datePicker.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      datePicker.topAnchor.constraint(equalTo: contentView.topAnchor),
      datePicker.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      datePicker.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    ])
    datePicker.date = Date()
    datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
  }
  
  @objc func dateChanged(picker: UIDatePicker) {
    onDateChanged?(picker.date)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  enum Cell: Int, CaseIterable {
    case start
    case date
  }
  
  var tableView: UITableView!
  var currentPlayer: Player?
  var wakeUpDate = Date()
  
  init() {
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView = UITableView(frame: view.bounds)
    tableView.delegate = self
    tableView.dataSource = self
    view.addSubview(tableView)
    NSLayoutConstraint.activate([
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    tableView.register(TitleCell.self, forCellReuseIdentifier: "StartCell")
    tableView.register(DateCell.self, forCellReuseIdentifier: "DateCell")
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return Cell.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cellType = Cell(rawValue: indexPath.row) else {
      assertionFailure()
      return UITableViewCell()
    }
    switch cellType {
    case .start:
      let cell = tableView.dequeueReusableCell(withIdentifier: "StartCell")!
      cell.textLabel?.text = "Start"
      return cell
    case .date:
      let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
      cell.onDateChanged = { date in
        self.wakeUpDate = date
      }
      self.wakeUpDate = cell.date
      return cell
    }
    
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let sounds = [
      "rain-01",
      "fire-1",
      "bell",
    ]
    
    let futureWakeUpDate = wakeUpDate < Date() ? wakeUpDate.addingTimeInterval(60 * 60 * 24) : wakeUpDate
    
    let intervalTillWakeUp = futureWakeUpDate.timeIntervalSinceNow
    let intervalForTrack = intervalTillWakeUp / TimeInterval(sounds.count)
    let lastTrackInterval = min(60 * 30, intervalForTrack)
    let firstTracksInterval = (intervalTillWakeUp - lastTrackInterval) / (TimeInterval(sounds.count - 1))
    print("Intervals: \(firstTracksInterval) x \(sounds.count - 1) + \(lastTrackInterval)")
    var tracks = sounds.dropLast().map { Track(url: $0.mp3ResourceUrl, playbackTime: firstTracksInterval) }
    tracks.append(Track(url: sounds.last!.mp3ResourceUrl, playbackTime: lastTrackInterval))
    currentPlayer?.stop()
    currentPlayer = Player(tracks: tracks)
    currentPlayer?.play()
  }
}

private extension String {
  var mp3ResourceUrl: URL {
    let urlString = Bundle.main.path(forResource: self, ofType: "mp3")!
    return URL(fileURLWithPath: urlString)
  }
}

