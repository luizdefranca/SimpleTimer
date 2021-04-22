//
//  ViewController.swift
//  SimpleClock
//
//  Created by Luiz on 4/14/21.
//

import UIKit
import UserNotifications


class TimerViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var clockImageView: UIImageView!
    @IBOutlet weak var timePickerView: UIPickerView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!

    //MARK: - Properties
    let timeArray = [ 10, 20, 30,  40, 50, 60]
    var selectedTimeValue = 10
    var isTimerRunning  = false
    var timer = Timer()
    var seconds = 0
    var publisher : Timer.TimerPublisher?
    let center = UNUserNotificationCenter.current()

    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        timePickerView.delegate = self
        timePickerView.dataSource = self

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            showWalkthrough()
        }
    }


    //MARK: - Actions
    @IBAction func actionButton(_ sender: UIButton) {

        askPermission()
        if isTimerRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }

    //MARK: - Functions
    func startTimer(){
        self.timePickerView.isHidden = true
        self.timeLabel.text = selectedTimeValue.description
        self.timeLabel.isHidden = false
        startButton.setTitle("Stop", for: .normal)
        isTimerRunning = !isTimerRunning
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        timer.tolerance = 0
        RunLoop.current.add(timer, forMode: .common)
    }

    func stopTimer(){
        seconds = 0
        isTimerRunning = !isTimerRunning
        timer.invalidate()
        self.timePickerView.isHidden = false
        self.timeLabel.isHidden = true
        self.timeLabel.text = "0"
        startButton.setTitle("Start", for: .normal)
    }

    @objc func updateTimer() {
        if seconds < selectedTimeValue {
            seconds += 1
            print(seconds)
            self.timeLabel.text = "\((self.selectedTimeValue - self.seconds ))"
        } else {
            print("time is over")
            stopTimer()
        }

    }

    private func  showWalkthrough() {
        let storyBoard = UIStoryboard(name: Constants.storyboard.walkthroughScreen.rawValue, bundle: nil)
        if let  pageViewController = storyBoard.instantiateViewController(withIdentifier:  "WalkThroughPageViewController") as? WalkThroughPageViewController {
            pageViewController.modalPresentationStyle = .fullScreen
            present(pageViewController, animated: true, completion: nil)
        }
    }

    private func askPermission(){
        center.requestAuthorization(options: [.alert, .sound]) {granted, error in
          if granted {
            print("Temos permissão")
          } else {
            print("Permissão negada")
          }
        }
    }

    private func doNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Olá!"
        content.body = "Eu sou uma notificação local"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(
          timeInterval: 3,
          repeats: false)
        let request = UNNotificationRequest(
          identifier: "MyNotification",
          content: content,
          trigger: trigger)
        center.add(request)
    }
}

//MARK: - Extensions
//MARK: UIPickerViewDelegate
extension TimerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedTimeValue = timeArray[row]
        print("selected value on pickerView: \(selectedTimeValue)")
    }

}
//MARK: UIPickerViewDataSource
extension TimerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(timeArray[row]) seconds"
    }

}
