//
//  HomeScreenView.swift
//  SleepSounds
//
//  Created by Kanstantsin Charnukha on 10/11/19.
//  Copyright © 2019 Kanstantsin Charnukha. All rights reserved.
//

import Foundation
import UIKit

class HomeScreenView: UIView {
  typealias OnDateChanged = (Date) -> ()
  
  private let headerImageView: UIImageView
  private let wakeUpTextLabel: UILabel
  private let wakeUpDatePicker: UIDatePicker
  private let startStopButton: UIButton
  var onStartStopButtonTap: Action?
  var onDateChanged: OnDateChanged?
  var model: HomeScreenViewModel {
    didSet {
      configure(with: model)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  required init(frame: CGRect, model: HomeScreenViewModel) {
    headerImageView = UIImageView()
    headerImageView.translatesAutoresizingMaskIntoConstraints = false
    headerImageView.contentMode = .scaleAspectFit
    headerImageView.animationImages = (0...30).map { UIImage(imageLiteralResourceName: "header\($0).gif") }
    headerImageView.animationDuration = 2;
    headerImageView.animationRepeatCount = 0;
    
    wakeUpTextLabel = UILabel()
    wakeUpTextLabel.translatesAutoresizingMaskIntoConstraints = false
    wakeUpTextLabel.textColor = .systemOrange
    wakeUpTextLabel.numberOfLines = 0
    wakeUpTextLabel.font = .systemFont(ofSize: 30)
    wakeUpTextLabel.textAlignment = .center
    
    wakeUpDatePicker = UIDatePicker()
    wakeUpDatePicker.translatesAutoresizingMaskIntoConstraints = false
    wakeUpDatePicker.datePickerMode = .time
    wakeUpDatePicker.setValue(UIColor.white, forKeyPath: "textColor")
    
    startStopButton = UIButton()
    startStopButton.translatesAutoresizingMaskIntoConstraints = false
    startStopButton.setTitleColor(.systemOrange, for: .normal)
    startStopButton.setTitleColor(.orange, for: .highlighted)
    startStopButton.titleLabel?.font = .boldSystemFont(ofSize: 30)
    self.model = model

    super.init(frame: frame)
    
    addSubview(headerImageView)
    addSubview(wakeUpTextLabel)
    addSubview(wakeUpDatePicker)
    addSubview(startStopButton)
    
    startStopButton.addTarget(self, action: #selector(onStartStopButton), for: .touchUpInside)
    wakeUpDatePicker.addTarget(self, action: #selector(onDatePickerDateChanged), for: .valueChanged)
    
    NSLayoutConstraint.activate([
      startStopButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      startStopButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
      startStopButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40)
    ])
    
    NSLayoutConstraint.activate([
      wakeUpDatePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      wakeUpDatePicker.bottomAnchor.constraint(equalTo: startStopButton.topAnchor, constant: -40),
      wakeUpDatePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor)
    ])
    
    NSLayoutConstraint.activate([
      wakeUpTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      wakeUpTextLabel.bottomAnchor.constraint(equalTo: wakeUpDatePicker.topAnchor, constant: -40),
      wakeUpTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
    ])
    
    var topAnchor = self.topAnchor
    if #available(iOS 11.0, *) {
      topAnchor = self.safeAreaLayoutGuide.topAnchor
    }
    NSLayoutConstraint.activate([
      headerImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
      headerImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
      headerImageView.bottomAnchor.constraint(equalTo: wakeUpTextLabel.topAnchor, constant: -40),
      headerImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
    ])
    
    configure(with: model)
  }
  
  private func configure(with model: HomeScreenViewModel) {
    wakeUpTextLabel.text = model.wakeUpTimeText
    wakeUpDatePicker.date = model.wakeUpTimeDate
    
    // TODO(xardas): handle pause
    switch model.playbackState {
    case .paused, .stopped:
      startStopButton.setTitle(model.startText, for: .normal)
    case .playing:
      startStopButton.setTitle(model.stopText, for: .normal)
    }
    headerImageView.startAnimating()
  }
  
  @objc private func onStartStopButton() {
    onStartStopButtonTap?()
  }
  
  @objc private func onDatePickerDateChanged(picker: UIDatePicker) {
    onDateChanged?(picker.date)
  }
}
