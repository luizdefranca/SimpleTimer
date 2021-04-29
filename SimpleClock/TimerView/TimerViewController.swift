//
//  ViewController.swift
//  SimpleClock
//
//  Created by Luiz on 4/14/21.
//

import UIKit
import UserNotifications
import AVFoundation

protocol TimerViewControllerDelegate : AnyObject{
    func stopTimer()
}

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
    let notificationManager = NotificationManager.shared
    var alarmSound: AVAudioPlayer?

    var resignedActiveTime  = Date()

    //MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        timePickerView.delegate = self
        timePickerView.dataSource = self

        addNotifications()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if !UserDefaults.standard.bool(forKey: "hasViewedWalkthrough") {
            showWalkthrough()
        }
    }


    //MARK: - Actions
    @IBAction func actionButton(_ sender: UIButton) {

        notificationManager.askPermission()

        if isTimerRunning {
            stopTimer()
        } else {
            startTimer()
        }
    }

    //MARK: - Functions

    @objc func goesBackground() {
        print("App goes resign")
        resignedActiveTime = Date()
    }

    @objc func goesActive(){
        let elapsedTime = Int(Date().timeIntervalSince(resignedActiveTime))
        if elapsedTime >= (selectedTimeValue - seconds){
            stopTimer()
        } else {
            seconds = elapsedTime
        }
    }


    func startTimer(){

        notificationManager.scheduleNotification(id: 1, timeInterval: Double(selectedTimeValue), title: "Alarm", body: "The time is over! :)")

        self.timePickerView.isHidden = true
        self.timeLabel.text = selectedTimeValue.description
        self.timeLabel.isHidden = false
        startButton.setTitle("Stop", for: .normal)
        isTimerRunning = !isTimerRunning
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        timer.tolerance = 0
        RunLoop.current.add(self.timer, forMode: .default)
    }

    func stopTimer(){
        notificationManager.cancelNotification()
        seconds = 0
        isTimerRunning = !isTimerRunning
        timer.invalidate()
        self.timePickerView.isHidden = false
        self.timeLabel.isHidden = true
        self.timeLabel.text = "0"
        startButton.setTitle("Start", for: .normal)
    }

    @objc func updateTimer() {

        if self.seconds < self.selectedTimeValue {
            self.seconds += 1
            print(self.seconds)
            self.timeLabel.text = "\((self.selectedTimeValue - self.seconds ))"
        } else {
            print("time is over")
            self.playAlarm()
            self.stopTimer()
        }
    }

    private func playAlarm(){
        shakeView(vw: clockImageView)
        ringAlarm()
    }

    fileprivate func  showWalkthrough() {
        let storyBoard = UIStoryboard(name: Constants.storyboard.walkthroughScreen.rawValue, bundle: nil)
        if let  pageViewController = storyBoard.instantiateViewController(withIdentifier:  "WalkThroughPageViewController") as? WalkThroughPageViewController {
            pageViewController.modalPresentationStyle = .fullScreen
            present(pageViewController, animated: true, completion: nil)
        }
    }

    fileprivate func ringAlarm(){
        let path = Bundle.main.path(forResource: "alarm-ring.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)

        do {
            alarmSound = try AVAudioPlayer(contentsOf: url)
            alarmSound?.play()
        } catch {
            // couldn't load file :(
        }
    }

    fileprivate func addNotifications() {
        //Set a notification for when the app goes resign active
        NotificationCenter.default.addObserver(self, selector: #selector(goesBackground), name: UIApplication.willResignActiveNotification, object: nil)

        //Set a notification for when the app goes back
        NotificationCenter.default.addObserver(self, selector: #selector(goesActive), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    fileprivate func shakeView(vw: UIView) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, -5, 5, -5, 0 ]
        animation.keyTimes = [0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875, 1]
        animation.duration = 0.4
        animation.isAdditive = true

        vw.layer.add(animation, forKey: "shake")
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
