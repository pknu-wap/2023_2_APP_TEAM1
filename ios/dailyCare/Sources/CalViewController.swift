import UIKit
import SnapKit

class CalViewController: UIViewController {
    
    lazy var dateView: UICalendarView = {
        var view = UICalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsDateDecorations = true
        view.backgroundColor = .white
        return view
    }()
    
    lazy var timeTextField: UITextField = {
            let textField = UITextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = "시간을 선택하세요"
            textField.borderStyle = .roundedRect
            return textField
        }()
    
    lazy var CautionTextField: UITextField = {
            let textField = UITextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = "주의사항"
            textField.borderStyle = .roundedRect
            return textField
        }()
    
    lazy var IllTextField: UITextField = {
            let textField = UITextField()
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.placeholder = "질병명"
            textField.borderStyle = .roundedRect
            return textField
        }()
    
    lazy var stackView : UIStackView = {
        let stack = UIStackView()
        stack.spacing = 30
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var datePicker: UIDatePicker = {
            let picker = UIDatePicker()
            picker.datePickerMode = .time
            picker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
            return picker
        }()
    
    var selectedDate: DateComponents? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyConstraints()
        setCalendar()
        reloadDateView(date: Date())
        
        stackView.addArrangedSubview(timeTextField)
        stackView.addArrangedSubview(CautionTextField)
        stackView.addArrangedSubview(IllTextField)
        
        self.view.addSubview(stackView)
        
        
//        stackView.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(20)
//            make.top.equalTo(dateView.snp.bottom).offset(10)
//            make.bottom.equalTo(dateView.snp.bottom).offset(-10)
//        }
        stackView.backgroundColor = .white
    }

    fileprivate func setCalendar() {
        dateView.delegate = self

        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        dateView.selectionBehavior = dateSelection
    }
    
    fileprivate func applyConstraints() {
        
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(dateView)
        
        
//        let dateViewConstraints = [
//            dateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
//            dateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
//        ]
//        NSLayoutConstraint.activate(dateViewConstraints)
        
//        NSLayoutConstraint.activate([
//            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20),
//            stackView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 10),
//            stackView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
//        
//        ])
        
        timeTextField.inputView = datePicker

    }
    
    func reloadDateView(date: Date?) {
        if date == nil { return }
        let calendar = Calendar.current
        dateView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
    }
    
    @objc func datePickerValueChanged() {
            let selectedDate = datePicker.date
            // Do something with the selectedDate, such as updating the textField's text
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            timeTextField.text = formatter.string(from: selectedDate)
        }
    
}

extension CalViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    // UICalendarView
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let selectedDate = selectedDate, selectedDate == dateComponents {
            return .customView {
                let label = UILabel()
                label.text = "" // 캘린더에 보일 정보
                label.textAlignment = .center
                return label
            }
        }
        return nil
    }
    
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        selection.setSelected(dateComponents, animated: true)
        selectedDate = dateComponents
        reloadDateView(date: Calendar.current.date(from: dateComponents!))
        
        if let selectedDate = selectedDate {
                    let formattedDate = DateFormatter.localizedString(from: Calendar.current.date(from: selectedDate)!, dateStyle: .long, timeStyle: .none)
                    print("Selected Date: \(formattedDate)")
                } else {
                    print("No date selected")
                }
    }
}
