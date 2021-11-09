//
//  ViewModel.swift
//  Timer
//
//  Created by sunggwang_park on 2021/08/10.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ViewModel {
    
    // MARK: - Properties

    let model = Model()
    let acceleration = 1
    
    var focusMinuteVM = 0
    var breakMinuteVM = 0
    var isLightMode = true
    
    var updating: () -> Void = {}
    var updatingOptionVC: () -> Void = {}
    var updatingTimeSelectVC: () -> Void = {}
    
    var minute = 0
    var second: Int = 0 {
        didSet {
            updating()
        }
    }
    var timerType: String = "Focus"
    
    var disposeBag = DisposeBag()
    
    // MARK: - Init

    init() {
        focusMinuteVM = model.minuteFocus
        breakMinuteVM = model.minuteBreak
        

    }
    
    
}

// MARK: - Functions
extension ViewModel {
    
    //타이머를 다시 흐르게 하거나 멈추게 하는 함수
    func flowOrStop() -> Bool {

        if model.isTimerFlow {
            model.timer?.invalidate()
            model.isTimerFlow = !model.isTimerFlow
//            model.publish.onCompleted()
            return true
        } else {
            reload()
            model.isTimerFlow = !model.isTimerFlow
            return false
        }
    }
    
    //타이머를 집중 상태로 되돌리는 함수 - 리셋 버튼을 누를시 호출된다
    func reset() {
        model.timer?.invalidate()
        model.wholeSeconds = model.minuteFocus * 60
        minute = model.minuteFocus
        second = 0
        model.isFocusTime = true
        model.isTimerFlow = true
        
        reload()
        
    }

    
    
    func reload() {
        model.timerAction()
        
        model.publish
        .subscribe(onNext: { wholeSeconds in
            self.minute = wholeSeconds / 60
            self.second = wholeSeconds % 60
            
            self.timerType = self.model.isFocusTime ? "Focus" : "Break"
            print("subjectOne :",wholeSeconds)
        })
        .disposed(by: disposeBag)
    }
    
    func modifyFocusTime(_ focusTime: Int) {
        model.minuteFocus = focusTime
        focusMinuteVM = focusTime
        UserDefaults.standard.set(focusTime, forKey: "focusMinutes")
        updatingOptionVC()
    }
    func modifyBreakTime(_ breakTime: Int) {
        model.minuteBreak = breakTime
        breakMinuteVM = breakTime
        UserDefaults.standard.set(breakTime, forKey: "breakMinutes")
        updatingOptionVC()
    }
    
    func getSectionedCount(_ isFocusBtnSelected: Bool ) -> Int {
        return isFocusBtnSelected ? model.minuteFocus/5 : model.minuteBreak/5
    }
    
    func setupMinute() {
        minute = model.minuteFocus
        model.setupWholeSeconds()
    }
    
    
    func setNotifications() {
            //백그라운드에서 포어그라운드로 돌아올때
            NotificationCenter.default.addObserver(self, selector: #selector(timerEnterForeground(_:)), name: NSNotification.Name("sceneWillEnterForeground"), object: nil)
            //포그라운드에서 백그라운드로 갈때
            NotificationCenter.default.addObserver(self, selector: #selector(timerEnterBackground), name: NSNotification.Name("sceneDidEnterBackground"), object: nil)
    }
    
    func flashToggle() {
        model.flashOn = !model.flashOn
        UserDefaults.standard.set(model.flashOn,forKey: "flashOn")
        updatingOptionVC()
    }
}



// MARK: - objc Functions
extension ViewModel {
    
    @objc func timerEnterBackground() {
        guard model.isTimerFlow else { return }

        model.timer?.invalidate()
        print("backg")
        let content = UNMutableNotificationContent()
        
        content.sound = UNNotificationSound.default
        
        if model.isFocusTime {
            content.title = "Start Break Time"
            content.body = "Take \(model.minuteBreak)minutes break"
            
        } else {
            content.title = "Start Focus Time"
            content.body = "Take \(model.minuteFocus)minutes Focus"
            
        }
        var trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(model.wholeSeconds/acceleration), repeats:false)
        var request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        let focusSec = model.minuteFocus * 60
        let breakSec = model.minuteBreak * 60
        
        if model.isFocusTime {
            content.title = "Break Time"
            content.body = "Take \(model.minuteBreak)minutes break"
            for i in 1...10 {
                let time = TimeInterval( (model.wholeSeconds + (focusSec + breakSec) * i)/acceleration )
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats:false)
                request = UNNotificationRequest(identifier: "break\(i)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
            
            content.title = "Focus Time"
            content.body = "Take \(model.minuteFocus)minutes focus"
            for i in 0...10 {
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(((model.wholeSeconds + breakSec) + (focusSec + breakSec) * i)/acceleration), repeats:false)
                request = UNNotificationRequest(identifier: "focus\(i)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
            
        } else{
            content.title = "Focus Time"
            content.body = "Take \(model.minuteFocus)minutes Focus"
            for i in 1...10 {
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval((model.wholeSeconds + (focusSec + breakSec) * i)/acceleration), repeats:false)
                request = UNNotificationRequest(identifier: "focus\(i)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
            
            content.title = "Break Time"
            content.body = "Take \(model.minuteBreak)minutes break"
            for i in 0...10 {
                trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(((model.wholeSeconds + focusSec) + (focusSec + breakSec) * i)/acceleration), repeats:false)
                request = UNNotificationRequest(identifier: "break\(i)", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
        }
    }

    @objc func timerEnterForeground(_ notification:Notification) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        if model.isTimerFlow {
    //       debugPrint("wholeSec",model.wholeSeconds)
            //노티피케이션센터를 통해 값을 받아옴
            var time = notification.userInfo?["time"] as? Int ?? 0
            time *= acceleration //배속
            
            if time < model.wholeSeconds {  //타이머 전환이 일어나지 않음
                model.wholeSeconds -= time
            } else {
                let focusSec = model.minuteFocus * 60
                let breakSec = model.minuteBreak * 60
                
                if model.isFocusTime {
                    time -= model.wholeSeconds
                    let timeRange = time % (breakSec + focusSec)
                    if timeRange < breakSec {
                        model.isFocusTime = false
                        model.wholeSeconds = breakSec - timeRange
                    } else {
                        model.isFocusTime = true
                        model.wholeSeconds = focusSec - (timeRange - breakSec)
                    }
                } else {
                    time -= model.wholeSeconds
                    let timeRange = time % (focusSec + breakSec)
                    if timeRange < focusSec {
                        model.isFocusTime = true
                        model.wholeSeconds = focusSec - timeRange
                    } else {
                        model.isFocusTime = false
                        model.wholeSeconds = breakSec - (timeRange - focusSec)
                    }
                }
            }

            reload()
        }
    }
}
