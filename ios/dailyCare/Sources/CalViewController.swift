import UIKit
import SnapKit

class CalViewController: UIViewController, UITextFieldDelegate {
    
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
    
    var UserInfo : [[String]] = [] // 정보 저장 리스트

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        
        applyConstraints()
        setCalendar()
        reloadDateView(date: Date())
        
        self.view.addSubview(datePicker)
        stackView.addArrangedSubview(timeTextField)
        stackView.addArrangedSubview(CautionTextField)
        stackView.addArrangedSubview(IllTextField)
        self.view.backgroundColor = .white
        
        self.view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            make in make.top.equalTo(dateView.snp.bottom)
            make.left.equalToSuperview().offset(10)
        }
        datePicker.snp.makeConstraints {
            make in make.left.equalTo(stackView.snp.right).offset(10)
            make.top.equalTo(dateView.snp.bottom).inset(5)
        }
        stackView.backgroundColor = .white
        
        CautionTextField.delegate = self
        IllTextField.delegate = self
        
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == CautionTextField {
            // 주의사항 텍스트 필드에서 엔터 키를 눌렀을 때의 동작
            if let text = textField.text {
                print("주의사항: \(text)")
            } else {
                print("주의사항이 입력되지 않았습니다.")
            }
        } else if textField == IllTextField {
            // 질병명 텍스트 필드에서 엔터 키를 눌렀을 때의 동작
            if let text = textField.text {
                print("질병: \(text)")
                appendToDataRecords(date: selectedDate, time: timeTextField.text, caution: CautionTextField.text, illness: text)
                textField.text = "" // 입력값 초기화
            } else {
                print("질병명이 입력되지 않았습니다.")
            }
        }

        textField.resignFirstResponder()
        return true
    }
    
    fileprivate func setCalendar() {
        dateView.delegate = self

        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        dateView.selectionBehavior = dateSelection
    }
    
    fileprivate func applyConstraints() {
        
        view.addSubview(dateView)
        
        let dateViewConstraints = [
            dateView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            dateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

        ]
        NSLayoutConstraint.activate(dateViewConstraints)

    }
    
    func reloadDateView(date: Date?) {
        if date == nil { return }
        let calendar = Calendar.current
        dateView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
    }
    
    @objc func datePickerValueChanged() {
            let selectedDate = datePicker.date
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            timeTextField.text = formatter.string(from: selectedDate)
            print("\(formatter.string(from: selectedDate))")
        
        }
    func appendToDataRecords(date: DateComponents?, time: String?, caution: String?, illness: String?) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        if let selectedDate = date, let timeString = time, let cautionString = caution, let illnessString = illness {
            let formattedDate = formatter.string(from: Calendar.current.date(from: selectedDate)!)
            let record = [formattedDate, timeString, cautionString, illnessString]
            UserInfo.append(record)
            print("사용자 정보:\(record)")
        }
    }
}

extension CalViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
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
            let formattedDate = DateFormatter.localizedString(from: Calendar.current.date(from: selectedDate)!, dateStyle: .medium, timeStyle: .none)
                    print("\(formattedDate)")
                } else {
                    print("선택된 날짜가 없음")
                }
    }
}

