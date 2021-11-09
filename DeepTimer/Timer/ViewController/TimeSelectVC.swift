//
//  TimeSelectVC.swift
//  Timer
//
//  Created by sunggwang_park on 2021/08/26.
//
//
import Foundation
import UIKit

// 포커스레이블과 분레이블 조정 필요
class TimeSelectVC: UIViewController, SectionedSliderDelegate {
    
    // MARK: - Properties
    let focusLabel = UILabel()
    let minuteLabel = UILabel()
    let backgroundView = UIView()
    
    var isFocus = true
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    
    var viewModel: ViewModel = ViewModel()
    
    // MARK: - Overrided Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = self.view.frame.width
        height = self.view.frame.height
//        print(height)
//        print(width)
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        navigationController?.popViewController(animated: false)
    }

}

// MARK: - Functions
extension TimeSelectVC {

    func setupUI() {
        
        view.addSubview(backgroundView)
        view.addSubview(focusLabel)
        view.addSubview(minuteLabel)
        
        // 백그라운드뷰
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.widthAnchor.constraint(equalToConstant: width * 0.7),
            backgroundView.heightAnchor.constraint(equalToConstant: height * 0.75),
            backgroundView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
        backgroundView.backgroundColor = .white
        backgroundView.layer.cornerRadius = 35

        view.addSubview(focusLabel)
        view.addSubview(minuteLabel)
       
        // 포커스 레이블
        focusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            focusLabel.widthAnchor.constraint(equalToConstant: width * 0.7),
            focusLabel.heightAnchor.constraint(equalToConstant: height * 0.05),
            focusLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            focusLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: height * 0.02)
        ])
        focusLabel.text = isFocus ? "Focus Time" : "Break Time"
        focusLabel.font = .systemFont(ofSize: height * 0.035)
        focusLabel.textColor = .black
        focusLabel.textAlignment = .center
        
        // 분 레이블
        minuteLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            minuteLabel.widthAnchor.constraint(equalToConstant: width * 0.7),
            minuteLabel.heightAnchor.constraint(equalToConstant: height * 0.12),
            minuteLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            minuteLabel.topAnchor.constraint(equalTo: focusLabel.bottomAnchor)
        ])
        minuteLabel.font = .systemFont(ofSize: height * 0.035)
        minuteLabel.textColor = .black
        minuteLabel.textAlignment = .center
        
        //뷰는 모델을 참조할 수 없다. 뷰모델에 함수를 만들어야 함
//        let sectionCount = isFocus ?  viewModel.model.minuteFocus/5 : viewModel.model.minuteBreak/5
        let sectionCount = viewModel.getSectionedCount(isFocus)
        
        let sectionedSlider = SectionedSlider(
            frame: CGRect(x: width/2 - (width * 0.49)/2, y: height * 0.35, width: width * 0.49, height: height * 0.49), // Choose a 15.6 / 40 ration for width/height
            selectedSection: sectionCount, // Initial selected section
            sections: isFocus ? 12 : 6 , // Number of sections. Choose between 2 and 20
            palette: Palette(
                viewBackgroundColor: .white,
                sliderBackgroundColor: .init(white: 0.7, alpha: 0.5),
                sliderColor: .darkGray
                )
        )
        
        sectionedSlider.delegate = self
        view.addSubview(sectionedSlider)
    
    }
    
    
    func sectionChanged(slider: SectionedSlider, selected: Int) {
        var minute = 0
        if selected == 0 {
            minuteLabel.text = "5"
            minute = 5
        } else {
            minuteLabel.text = "\(selected*5)"
            minute = selected*5
        }
        
        if isFocus {
            viewModel.modifyFocusTime(minute)
        } else {
            viewModel.modifyBreakTime(minute)
        }
        
    }
}
