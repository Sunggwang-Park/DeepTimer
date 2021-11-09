//
//  Model.swift
//  Timer
//
//  Created by sunggwang_park on 2021/08/10.
//

import Foundation
import UserNotifications
import AVFoundation
import UIKit

import RxCocoa
import RxSwift

class Model {
    
    // MARK: - Properties

    var isBuilded = false
    var isFocusTime: Bool = true
    var minuteFocus: Int = 25
    var minuteBreak: Int = 5
    var wholeSeconds: Int = 0
    var standardSeconds = 0
    var isTimerFlow: Bool = false
    var timeDistance: Int = 0
    var isLightMode = true
    
    var publish = PublishSubject<Int>()
    
    var flashOn = false {
        willSet {
            print("flashOn: " , newValue)
            UserDefaults.standard.set(newValue,forKey: "flashOn")
            
        }
    }
    
    // MARK: - Init
    
    init() {
        isBuilded = UserDefaults.standard.bool(forKey: "isBuilded")
        print("isBuilded : ",isBuilded)
       
        if isBuilded {
            minuteFocus = UserDefaults.standard.integer(forKey: "focusMinutes")
            minuteBreak = UserDefaults.standard.integer(forKey: "breakMinutes")
            flashOn = UserDefaults.standard.bool(forKey: "flashOn")
            
            
        } else {
            UserDefaults.standard.set(25,forKey: "focusMinutes")
            UserDefaults.standard.set(5,forKey: "breakMinutes")
            UserDefaults.standard.set(false,forKey: "flashOn")
            UserDefaults.standard.set(true,forKey: "isBuilded")
        }
        
        
        
    }

    var timer: Timer?
}

// MARK: - Functions

extension Model {
    
    func timerAction() {
//    onCompleted: @escaping (Int) -> Void
        publish = PublishSubject<Int>()
        DispatchQueue.main.async { [weak self] in
            self?.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
    //                                             withTimeInterval: 0.01666
                guard let self = self else { return }
                
                self.wholeSeconds -= 1
//                onCompleted(self.wholeSeconds)
                
//                self.publish.bind(onNext: <#T##(Int) -> Void#>)
                self.publish.onNext(self.wholeSeconds)
               
                if self.wholeSeconds == 0 {
                    self.isFocusTime = !self.isFocusTime
                    self.wholeSeconds = self.isFocusTime ? self.minuteFocus * 60 : self.minuteBreak * 60
                    
                    if self.flashOn {
                        print("flashOn execution")
                        DispatchQueue.global().sync {
                            
                            var count = 10
                            let _ = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] temp in
                                count -= 1
                                self?.toggleTorch(on: true)
                                self?.toggleTorch(on: false)
                                if count == 0 {
                                    temp.invalidate()
                                }
                            }
                        }
                    }

                }
            }
            self?.timer?.tolerance = 0.1
        }
    }
    
    func setupWholeSeconds() {
        self.wholeSeconds = minuteFocus * 60
    }

    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
    
            }
        } else {

        }
    }
}
