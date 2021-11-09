//
//  optionVC.swift
//  Timer
//
//  Created by sunggwang_park on 2021/08/18.
//

import Foundation
import UIKit

class OptionVC: UIViewController {
    
    // MARK: - Properties
    let focusLabel = UILabel()
    let breakLabel = UILabel()
    let focusButton = UIButton()
    let breakButton = UIButton()
    let flashLabel = UILabel()
    let flashSwitch = UISwitch()
    let licenseButton = UIButton()
        
    
    
    let flashView = UIView()

    
    var viewWidth: CGFloat = 0.0
    var viewHeight: CGFloat = 0.0
    var viewModel = ViewModel()
    
 
    // MARK: - Overrided Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        
        setupUI()

        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        self.view.addGestureRecognizer(swipeRecognizer)
        
        bindViewModel()
        
        flashSwitch.isOn = UserDefaults.standard.bool(forKey: "flashOn")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }
    
    

    

}

// MARK: - Functions
extension OptionVC {

    func setupUI() {
        
        view.addSubview(focusLabel)
        view.addSubview(breakLabel)
        view.addSubview(focusButton)
        view.addSubview(breakButton)
        view.addSubview(flashView)
        view.addSubview(licenseButton)
        
        //포커스 레이블
        focusLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            focusLabel.widthAnchor.constraint(equalToConstant: viewWidth / 2 ),
            focusLabel.heightAnchor.constraint(equalToConstant: viewHeight * 0.1),
            focusLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: viewHeight * 0.2 )
        ])
        focusLabel.text = "Focus"
        focusLabel.textAlignment = .center
        focusLabel.font = .systemFont(ofSize: viewWidth * 0.055)
        
        //포커스 버튼
        focusButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            focusButton.widthAnchor.constraint(equalToConstant: viewWidth * 0.45 ),
            focusButton.heightAnchor.constraint(equalToConstant: viewHeight * 0.05),
            focusButton.centerYAnchor.constraint(equalTo: focusLabel.centerYAnchor),
            focusButton.leadingAnchor.constraint(equalTo: focusLabel.trailingAnchor)
        ])
        focusButton.setTitle("\(viewModel.focusMinuteVM)", for: .normal)
        focusButton.setTitleColor(.label, for: .normal)

        
        //브레이크 레이블
        breakLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            breakLabel.widthAnchor.constraint(equalToConstant: viewWidth / 2 ),
            breakLabel.heightAnchor.constraint(equalToConstant: viewHeight * 0.1),
            breakLabel.topAnchor.constraint(equalTo: focusLabel.bottomAnchor)
        ])
        breakLabel.text = "Break"
        breakLabel.textAlignment = .center
        breakLabel.font = .systemFont(ofSize: viewWidth * 0.055)
        
        //플래시 뷰
        flashView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flashView.widthAnchor.constraint(equalToConstant: viewWidth * 0.4 ),
            flashView.heightAnchor.constraint(equalToConstant: viewHeight * 0.15),
            flashView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: viewWidth * 0.05),
            flashView.topAnchor.constraint(equalTo: breakLabel.bottomAnchor)
        ])
        flashView.backgroundColor = .systemGray6
        flashView.layer.cornerRadius = 20

        
        flashView.addSubview(flashLabel)
        flashView.addSubview(flashSwitch)
        
        //플래시 레이블
        flashLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flashLabel.widthAnchor.constraint(equalTo: flashView.widthAnchor ),
            flashLabel.heightAnchor.constraint(equalTo: flashView.heightAnchor, multiplier: 0.55),
            flashLabel.topAnchor.constraint(equalTo: flashView.topAnchor)
        ])
        flashLabel.text = "Flash On"
        flashLabel.textAlignment = .center
        flashLabel.font = .systemFont(ofSize: viewWidth * 0.055)

        //플래시 스위치
        flashSwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            flashSwitch.topAnchor.constraint(equalTo: flashLabel.bottomAnchor),
            flashSwitch.centerXAnchor.constraint(equalTo: flashView.centerXAnchor)
        ])
        flashSwitch.onTintColor = .systemGray

        
        //브레이크 버튼
        breakButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            breakButton.widthAnchor.constraint(equalToConstant: viewWidth * 0.45 ),
            breakButton.heightAnchor.constraint(equalToConstant: viewHeight * 0.05),
            breakButton.centerYAnchor.constraint(equalTo: breakLabel.centerYAnchor),
            breakButton.leadingAnchor.constraint(equalTo: breakLabel.trailingAnchor)
        ])
        breakButton.setTitle("\(viewModel.breakMinuteVM)", for: .normal)
        breakButton.setTitleColor(.label, for: .normal)
        
        //오픈소스 라이센스 버튼
        licenseButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            licenseButton.widthAnchor.constraint(equalToConstant: viewWidth * 0.70 ),
            licenseButton.heightAnchor.constraint(equalToConstant: viewHeight * 0.05),
            licenseButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            licenseButton.bottomAnchor.constraint(equalTo:view.bottomAnchor)
        ])
        licenseButton.setTitle("open sourse license", for: .normal)
        licenseButton.setTitleColor(.label, for: .normal)
        
        focusButton.layer.borderWidth = 2
        focusButton.layer.cornerRadius = 10
        focusButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        breakButton.layer.borderWidth = 2
        breakButton.layer.cornerRadius = 10
        breakButton.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        focusButton.addTarget(self, action: #selector(clickFocusSelect), for: .touchUpInside)
        breakButton.addTarget(self, action: #selector(clickBreakSelect), for: .touchUpInside)
        licenseButton.addTarget(self, action: #selector(clickLicense), for: .touchUpInside)
        flashSwitch.addTarget(self, action: #selector(clickFlashOn), for: .valueChanged)
    }
    
    
    private func bindViewModel() {
        //뷰모델과 뷰의 바인딩
        viewModel.updatingOptionVC = { [weak self] in
            self?.focusButton.setTitle("\(self?.viewModel.focusMinuteVM ?? -1)", for: .normal)
            self?.breakButton.setTitle("\(self?.viewModel.breakMinuteVM ?? -1)", for: .normal)
            self?.flashSwitch.isOn = UserDefaults.standard.bool(forKey: "flashOn")
            
        }
    }
}

// MARK: - Objc Functions
extension OptionVC {
  
    @objc func swipeAction(_ sender: UISwipeGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func clickFocusSelect() {
        let timeSelectVC = TimeSelectVC()
        navigationController?.pushViewController(timeSelectVC, animated: false)
        timeSelectVC.viewModel = viewModel
        timeSelectVC.isFocus = true
    }
    
    @objc func clickBreakSelect() {
        let timeSelectVC = TimeSelectVC()
        navigationController?.pushViewController(timeSelectVC, animated: false)
        timeSelectVC.viewModel = viewModel
        timeSelectVC.isFocus = false
    }
    
    @objc func clickFlashOn() {
        viewModel.flashToggle()
    }
    
    @objc func clickLicense() {
        let licenseVc = LicenseVC()
        navigationController?.pushViewController(licenseVc, animated: false)
    }
    
}
