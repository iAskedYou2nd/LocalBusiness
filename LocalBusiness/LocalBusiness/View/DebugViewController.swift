//
//  DebugViewController.swift
//  LocalBusiness
//
//  Created by iAskedYou2nd on 10/11/22.
//

import UIKit

protocol DebuggerDelegate: AnyObject {
    func restartApp()
}

class DebugViewController: UIViewController {

    lazy var resetAppButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Reset App", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 15.0
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addTarget(self, action: #selector(self.resetAppButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var throttleStepper: UIStepper = {
        let stepper = UIStepper(frame: .zero)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        stepper.minimumValue = 0
        stepper.maximumValue = 5
        stepper.value = Double(DebugSettings.shared.throttleTime)
        stepper.addTarget(self, action: #selector(self.throttleStepperValueChanged(sender:)), for: .valueChanged)
        return stepper
    }()
    
    lazy var throttleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Throttle Time: \(DebugSettings.shared.throttleTime)"
        return label
    }()
    
    lazy var latitudeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Latitude:"
        return label
    }()
    
    lazy var latitudeTextField: UITextField = {
        let textfield = UITextField(frame: .zero)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.layer.cornerRadius = 15.0
        textfield.layer.borderColor = UIColor.black.cgColor
        textfield.layer.borderWidth = 1.0
        textfield.text = "\(DebugSettings.shared.lattitude)"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        textfield.leftViewMode = .always
        textfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return textfield
    }()
    
    lazy var longitudeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Longitude:"
        return label
    }()
    
    lazy var longitudeTextField: UITextField = {
        let textfield = UITextField(frame: .zero)
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.layer.cornerRadius = 15.0
        textfield.layer.borderColor = UIColor.black.cgColor
        textfield.layer.borderWidth = 1.0
        textfield.text = "\(DebugSettings.shared.longitude)"
        textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 44))
        textfield.leftViewMode = .always
        textfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
        return textfield
    }()
    
    weak var delegate: DebuggerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buildUI()
    }
    
    private func buildUI() {
        self.view.backgroundColor = .white
        
        let screenStack = UIStackView(frame: .zero)
        screenStack.translatesAutoresizingMaskIntoConstraints = false
        screenStack.axis = .vertical
        screenStack.spacing = 2
        
        screenStack.addArrangedSubview(self.resetAppButton)
        
        let throttleStack = UIStackView(frame: .zero)
        throttleStack.translatesAutoresizingMaskIntoConstraints = false
        throttleStack.axis = .horizontal
        throttleStack.spacing = 2
        
        throttleStack.addArrangedSubview(self.throttleStepper)
        throttleStack.addArrangedSubview(self.throttleLabel)
        
        let latitudeStack = UIStackView(frame: .zero)
        latitudeStack.translatesAutoresizingMaskIntoConstraints = false
        latitudeStack.axis = .horizontal
        latitudeStack.spacing = 2
        
        latitudeStack.addArrangedSubview(self.latitudeLabel)
        latitudeStack.addArrangedSubview(self.latitudeTextField)
        
        let longitudeStack = UIStackView(frame: .zero)
        longitudeStack.translatesAutoresizingMaskIntoConstraints = false
        longitudeStack.axis = .horizontal
        longitudeStack.spacing = 2
        
        longitudeStack.addArrangedSubview(self.longitudeLabel)
        longitudeStack.addArrangedSubview(self.longitudeTextField)
        
        screenStack.addArrangedSubview(throttleStack)
        screenStack.addArrangedSubview(latitudeStack)
        screenStack.addArrangedSubview(longitudeStack)
        screenStack.addArrangedSubview(UIView.generateBufferView())
        
        self.view.addSubview(screenStack)
        
        screenStack.bindToSuperView()
    }
    
    @objc
    func resetAppButtonPressed() {
        DebugSettings.shared.lattitude = Double(self.latitudeTextField.text ?? "0") ?? 0.0
        DebugSettings.shared.longitude = Double(self.longitudeTextField.text ?? "0") ?? 0.0
        
        self.delegate?.restartApp()
    }
    
    @objc
    func throttleStepperValueChanged(sender: UIStepper) {
        DebugSettings.shared.throttleTime = Int(sender.value)
        self.throttleLabel.text = "Throttle Time: \(DebugSettings.shared.throttleTime)"
    }

}
