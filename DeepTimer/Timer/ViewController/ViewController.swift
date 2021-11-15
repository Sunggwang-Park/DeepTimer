//
//  ViewController.swift
//  Timer
//
//  Created by sunggwang_park on 2021/08/02.
//

import UIKit
//import Foundation

class ViewController: UIViewController, UIViewDelegate {
    
    
    // MARK: - Properties
    var timerView: TimerView = TimerView()
    var timerReset: UIButton = UIButton()
    let timerType: UILabel = UILabel()
    
    var viewWidth:CGFloat = 0.0
    var viewHeight:CGFloat = 0.0

    private lazy var viewModel = ViewModel()
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
        
        
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: {didAllow,Error in
//            print(didAllow)
        })

        

        // Do any additional setup after loading the view.
    
        viewWidth = self.view.frame.width
        viewHeight = self.view.frame.height

        self.view.addSubview(timerView)
        self.view.addSubview(timerType)
        self.view.addSubview(timerReset)
        
        
        //타이머 타입 레이블 코드 레이아웃
        self.timerType.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.timerType.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            self.timerType.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: viewHeight/3 * 0.8),
            self.timerType.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            self.timerType.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            self.timerType.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
        self.timerType.text = viewModel.timerType
        self.timerType.font = UIFont.systemFont(ofSize: 20)
        self.timerType.textAlignment = .center
        
        
        
        // 타이머뷰 코드 레이아웃
        timerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerView.widthAnchor.constraint(equalToConstant: viewWidth * 0.8),
            timerView.heightAnchor.constraint(equalToConstant: viewHeight * 0.2),
            timerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            timerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: viewHeight/2 * 0.7)
        ])
        
        timerView.delegate = self
        timerView.viewWidth = viewWidth * 0.8
        timerView.viewHeight = viewHeight * 0.2
        timerView.setupView()
        
        
        // 타이머 리셋 버튼
        timerReset.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timerReset.widthAnchor.constraint(equalToConstant: viewWidth * 0.2),
            timerReset.heightAnchor.constraint(equalToConstant: viewWidth * 0.2),
            timerReset.topAnchor.constraint(equalTo: timerView.bottomAnchor, constant: 50),
            timerReset.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
       
        
        timerReset.setTitle("reset", for: .normal)
        timerReset.setTitleColor(.label, for: .normal)
        timerReset.addTarget(self, action: #selector(reset), for: .touchUpInside)
  
        bindViewModel()

        // 스와이프 제스쳐
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeRecognizer.direction = .left
        self.view.addGestureRecognizer(swipeRecognizer)
        
    }
    

    
}

// MARK: - Functions
extension ViewController {
    func touch() {
        let isTimerFlow = viewModel.flowOrStop()
        if isTimerFlow {
            UIView.animate(withDuration: 0.4) {
                self.timerView.alpha = 0.5
                self.timerView.minuteLabel.font = UIFont.boldSystemFont(ofSize: self.timerView.viewHeight * 0.47)
                self.timerView.secondLabel.font = UIFont.boldSystemFont(ofSize: self.timerView.viewHeight * 0.47)
                self.timerView.separatorLabel.font = UIFont.boldSystemFont(ofSize: self.timerView.viewHeight * 0.47)
            }
        } else {
            UIView.animate(withDuration: 0.7) {
                self.timerView.alpha = 1.0
                self.timerView.minuteLabel.font = UIFont.boldSystemFont(ofSize: self.timerView.timerTextSize)
                self.timerView.secondLabel.font = UIFont.boldSystemFont(ofSize: self.timerView.timerTextSize)
                self.timerView.separatorLabel.font = UIFont.boldSystemFont(ofSize: self.timerView.timerTextSize)
            }
        }
    }
    
    func bindViewModel() {
        //weak self 와 self 의 차이는 약한 참조와 강한 참조
        //이 경우에 약한 참조를 할 필요가 있을까?
        // 답 : 클로저 안에서 강한 참조로 self를 사용하면 강한 참조 순환이 일어날 수 있다. weak self 로 self를 약한 참조 한다면 강한 참조 순환을 피할 수 있다.
        
        //뷰모델과 뷰의 바인딩
        
//        viewModel.
        
        viewModel.updating = { [weak self] in
            DispatchQueue.main.async {
                self?.timerView.minuteLabel.text = "\(self?.viewModel.minute ?? -1)"
                if let second = self?.viewModel.second {
                    self?.timerView.secondLabel.text = second < 10 ? "0\(second)" : "\(second)"
                }

                self?.timerType.text = self?.viewModel.timerType
            }
        }
        
        viewModel.setupMinute()
        viewModel.updating()
        viewModel.setNotifications()
    }
}



// MARK: - Objc Functions
extension ViewController {
    @objc func reset() {
//        viewModel.reset(timerView)
        viewModel.reset()
        UIView.animate(withDuration: 0.7) { 
            self.timerView.alpha = 1.0
            self.timerView.minuteLabel.font = UIFont.boldSystemFont(ofSize: self.timerView.timerTextSize)
            self.timerView.secondLabel.font = UIFont.boldSystemFont(ofSize: self.timerView.timerTextSize)
            self.timerView.separatorLabel.font = UIFont.boldSystemFont(ofSize: self.timerView.timerTextSize)
        }
    }

    
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        let optionVC = OptionVC()
        optionVC.viewModel = viewModel
        navigationController?.pushViewController(optionVC, animated: true)
    }
}
