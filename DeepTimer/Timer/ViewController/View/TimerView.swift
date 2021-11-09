//
//  TimerView.swift
//  Timer
//
//  Created by sunggwang_park on 2021/08/04.
//

// 타이머를 담는 뷰
// '분'을 나타내는 뷰와 '초'를 나타내는 뷰를 하나의 뷰 안에 담는다.


import Foundation
import UIKit

class TimerView: UIView {
    
    // MARK: - Properties

    
    var delegate: UIViewDelegate?
    
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    var timerTextSize: CGFloat = 0.0
    
    var minuteLabel: UILabel = UILabel()
    var secondLabel: UILabel = UILabel()
    var separatorLabel: UILabel = UILabel()
    
    
    // MARK: - Init

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    // MARK: - Override Functions
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.touch()
    }
}


// MARK: - Functions

extension TimerView {
    func setupView() {
        timerTextSize = viewHeight * 0.5
        
        minuteLabel = UILabel(frame: CGRect(x: 0, y: 0, width: viewWidth * 0.45, height: viewHeight))
        separatorLabel = UILabel(frame: CGRect(x: minuteLabel.frame.width, y: -5, width: viewWidth * 0.1, height: viewHeight))
        secondLabel = UILabel(frame: CGRect(x: minuteLabel.frame.width + separatorLabel.frame.width, y: 0, width: viewWidth * 0.45, height: viewHeight))
        
        separatorLabel.text = ":"
        separatorLabel.font = UIFont.boldSystemFont(ofSize: timerTextSize)
        separatorLabel.textAlignment = .center
        
        minuteLabel.font = UIFont.boldSystemFont(ofSize: timerTextSize)
        minuteLabel.textAlignment = .right
        
        secondLabel.font = UIFont.boldSystemFont(ofSize: timerTextSize)
        secondLabel.textAlignment = .left
        
        self.addSubview(minuteLabel)
        self.addSubview(separatorLabel)
        self.addSubview(secondLabel)
    }
}

// MARK: - Protocol

protocol UIViewDelegate {
    func touch() -> Void
}
