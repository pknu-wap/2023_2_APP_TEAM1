//
//  ViewController.swift
//  calView
//
//  Created by 서성원 on 2023/11/19.
//

import UIKit

class CalViewController: UIViewController {
    
    // 날짜 선택 시 뜨는 입력창
    func showInputDialog() {
        let alertController = UIAlertController(title: "", message: nil, preferredStyle: .alert)

        // 시간을 24시간 형식으로 선택할 수 있는 UIDatePicker 추가
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        alertController.view.addSubview(datePicker)

        // 첫 번째 텍스트 필드는 시간 선택을 위한 것이므로, 추가된 datePicker에 대한 참조 저장
        alertController.textFields?.first?.inputView = datePicker

        alertController.addTextField { textField in
            textField.placeholder = "약 정보를 입력하세요."
        }

        let saveAction: (UIAlertAction) -> Void = { [weak self, weak datePicker] _ in
            guard let self = self,
                  let datePicker = datePicker,
                  let textFields = alertController.textFields,
                  textFields.count >= 2, // 최소한 2개 이상의 텍스트 필드가 존재하는지 확인
                  let detailsText = textFields[1].text,
                  let selectedDate = self.selectedDate else {
                return
            }

            // 선택된 시간 가져오기
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let selectedTime = dateFormatter.string(from: datePicker.date)

            self.saveEvent(time: selectedTime, details: detailsText, dateComponents: selectedDate)
        }


        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let saveActionAlert = UIAlertAction(title: "Save", style: .default, handler: saveAction)

        alertController.addAction(cancelAction)
        alertController.addAction(saveActionAlert)

        present(alertController, animated: true)
    }

        func saveEvent(time: String, details: String, dateComponents: DateComponents) {
            
            // 선택된 날짜에 대한 이벤트를 저장하는 과정을 넣어야 됨
            // 데이터베이스에 저장해야됨
            
            print("Selected Date: \(dateComponents.year ?? 0)-\(dateComponents.month ?? 0)-\(dateComponents.day ?? 0)")
            print("Selected Time: \(time)")
            print("Event Details: \(details)")
        }
    
    lazy var dateView: UICalendarView = {
        var view = UICalendarView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.wantsDateDecorations = true
        return view
    }()
    
    var selectedDate: DateComponents? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        applyConstraints()
        setCalendar()
        reloadDateView(date: Date())
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
            dateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ]
        NSLayoutConstraint.activate(dateViewConstraints)
    }
    
    func reloadDateView(date: Date?) {
        if date == nil { return }
        let calendar = Calendar.current
        dateView.reloadDecorations(forDateComponents: [calendar.dateComponents([.day, .month, .year], from: date!)], animated: true)
    }
}

extension CalViewController: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        if let selectedDate = selectedDate, selectedDate == dateComponents {
            return .customView {
                let label = UILabel()
                label.text = "🐶"
                label.textAlignment = .center
                return label
            }
        }
        return nil
    }
    
    // 달력에서 날짜 선택했을 경우 행동
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            selection.setSelected(dateComponents, animated: true)
            selectedDate = dateComponents
            reloadDateView(date: Calendar.current.date(from: dateComponents!))
            
            // 날짜 선택 시 입력창 띄우기
            showInputDialog()
        }
    }


