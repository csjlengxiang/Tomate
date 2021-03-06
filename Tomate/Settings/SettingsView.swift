//
//  SettingsView.swift
//  Tomate
//
//  Created by dasdom on 02.08.14.
//  Copyright (c) 2014 Dominik Hauser. All rights reserved.
//

import UIKit
import QuartzCore

class SettingsView: UIView {
  
  let markerView: UIView
  let workInputHostView: InputHostView
  let breakInputHostView: InputHostView
  //    let longBreakInputHostView: InputHostView
  let workPeriodsLabel: UILabel
  let workPeriodsStepper: UIStepper
  let pickerView: UIPickerView
  var selectedTimerType: TimerType
  
  override init(frame: CGRect) {
    
    markerView = {
      let view = UIView()
      view.layer.cornerRadius = 5
      return view
      }()
    
    let workPeriodsSettingsHostView: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      return view
      }()
    
    workPeriodsLabel = {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
      }()
    workPeriodsSettingsHostView.addSubview(workPeriodsLabel)
    
    workPeriodsStepper = {
      let stepper = UIStepper()
      stepper.translatesAutoresizingMaskIntoConstraints = false
      return stepper
      }()
    workPeriodsSettingsHostView.addSubview(workPeriodsStepper)
    
    
    workInputHostView = InputHostView(frame: CGRectZero)
    workInputHostView.nameLabel.text = NSLocalizedString("Work duration", comment: "Settings name for the work duration")
    workInputHostView.tag = 0
    
    breakInputHostView = InputHostView(frame: CGRectZero)
    breakInputHostView.nameLabel.text = NSLocalizedString("Break duration", comment: "Settings name for the break duration")
    breakInputHostView.tag = 1
    
    //        longBreakInputHostView = InputHostView(frame: CGRectZero)
    //        longBreakInputHostView.nameLabel.text = NSLocalizedString("Long break duration", comment: "Settings name for the long break duration")
    //        longBreakInputHostView.tag = 2
    
    pickerView = {
      let pickerView = UIPickerView()
      pickerView.translatesAutoresizingMaskIntoConstraints = false
      pickerView.showsSelectionIndicator = true
      return pickerView
      }()
    
    selectedTimerType = TimerType.Work
    
    super.init(frame: frame)
    
    backgroundColor = TimerStyleKit.backgroundColor
    markerView.backgroundColor = UIColor.yellowColor()
    
    addSubview(markerView)
    addSubview(workInputHostView)
    addSubview(breakInputHostView)
    //        addSubview(longBreakInputHostView)
    addSubview(pickerView)
    
    let metrics = ["hostViewHeight" : 40, "hostViewGap" : 10]
    
    let views = ["markerView" : markerView, "workInputHostView" : workInputHostView, "breakInputHostView" : breakInputHostView,
      //            "longBreakInputHostView" : longBreakInputHostView,
      "pickerView" : pickerView]
    NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-5-[workInputHostView(breakInputHostView)]-5-|", options: [], metrics: nil, views: views))
    NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[workInputHostView(hostViewHeight,breakInputHostView)]-hostViewGap-[breakInputHostView]", options: .AlignAllLeft, metrics: metrics, views: views))
    
    NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[pickerView]|", options: [], metrics: nil, views: views))
    NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[breakInputHostView][pickerView]", options: [], metrics: nil, views: views))
    
  }
  
  convenience required init(coder aDecoder: NSCoder) {
    self.init(frame: CGRectZero)
  }
  
  func setDurationString(string: String) -> TimerType {
    var timerType = TimerType.Idle
    if CGRectContainsPoint(workInputHostView.frame, markerView.center) {
      setWorkDurationString(string)
      timerType = TimerType.Work
    } else {
      setBreakDurationString(string)
      timerType = TimerType.Break
    }
    return timerType
  }
  
  func setWorkDurationString(string: String) {
    workInputHostView.durationLabel.text = string
  }
  
  func setBreakDurationString(string: String) {
    breakInputHostView.durationLabel.text = string
  }
  
  
  func moveMarkerToView(view: UIView) {
    if CGRectContainsPoint(workInputHostView.frame, view.center) {
      selectedTimerType = .Work
    } else {
      selectedTimerType = .Break
    }
    
    UIView.animateWithDuration(0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 5.0, options: [], animations: {
      self.markerView.frame = CGRectInset(view.frame, -3, -3)
      }, completion: nil)
  }
  
  class InputHostView: UIView {
    let nameLabel: UILabel
    let durationLabel: UILabel
    
    override init(frame: CGRect) {
      let makeLabel = { () -> UILabel in
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //                label.backgroundColor = UIColor.whiteColor()
        label.textColor = TimerStyleKit.timerColor
        label.text = "-"
        return label
      }
      
      nameLabel = makeLabel()
      durationLabel = makeLabel()
      
      super.init(frame: frame)
      
      translatesAutoresizingMaskIntoConstraints = false
      backgroundColor = TimerStyleKit.backgroundColor
      layer.cornerRadius = 5
      
      addSubview(nameLabel)
      addSubview(durationLabel)
      
      let views = ["nameLabel" : nameLabel, "durationLabel" : durationLabel]
      NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[nameLabel]-(>=10)-[durationLabel]-|", options: .AlignAllBaseline, metrics: nil, views: views))
      NSLayoutConstraint.activateConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[nameLabel(durationLabel)]-|", options: .AlignAllBaseline, metrics: nil, views: views))
      
    }
    
    required convenience init(coder aDecoder: NSCoder) {
      self.init(frame: CGRectZero)
    }
  }
}
