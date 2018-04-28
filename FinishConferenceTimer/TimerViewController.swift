//
//  TimerViewController.swift
//  FinishConferenceTimer
//
//  Created by 大林拓実 on 2018/04/24.
//  Copyright © 2018年 Life is tech. All rights reserved.
//

import UIKit
import AudioToolbox

class TimerViewController: UIViewController {
    
    @IBOutlet var ConferenceNameLabel: UILabel!   //会議名のラベル
    @IBOutlet var CurrentAgendaNameLabel: UILabel!   //今の議題名のラベル
    @IBOutlet var NextAgendaNameLabel: UILabel!     //次の議題名のラベル
    
    @IBOutlet var ConferenceTimerLabel: UILabel!    //会議時間タイマーのラベル
    @IBOutlet var AgendaTimerLabel: UILabel!    //議題時間タイマーのラベル
    
    
    //とりあえずローカルに持たせとく
    var AgendaNameList: [String] = ["議題1", "議題2", "議題3"]    //議題名のString型配列
    var DiscussTimeList: [Int] = [1, 1, 1]   //議論時間のInt型配列(分)
    
    
    var ConferenceNamefrom:String = ""  //ConferenceViewから会議名を受け取る変数
    
    var timer = Timer()    //Timerクラスのインスタンス
    
    //会議合計時間(分)の計算メソッド
    func CalcTotalTimeofMin() -> Int{
        var TotalTime: Int = 0
        for i in DiscussTimeList{
            TotalTime += i
        }
        return TotalTime
    }
    
    //会議合計時間(秒)の計算メソッド
    func CalcTotalTimeofSec() -> Int{
        var TotalTime: Int = 0
        for i in DiscussTimeList{
            TotalTime += i
        }
        return TotalTime*60
    }
    
    //////////////////////////////////////////会議時間タイマー///////////////////////////////////////////////
    //画面遷移後に会議タイマーをスタートさせるメソッド
    func ConferenceTimerStart(){
        //開始時刻を記録
        let startTime = NSDate()
        //終了時刻を計算
        let finishTimeC = NSDate(timeInterval: TimeInterval(CalcTotalTimeofSec()), since: startTime as Date)
        //0.01秒ごとにupdatelabel()を呼び出す      //finishTimeを引数でupdatelabelに渡したいけど直接じゃ無理ぽいのでuserinfo経由
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateClabel), userInfo: finishTimeC, repeats: true)
    }
    
    //会議タイマーの表示を更新させるメソッド
    @objc func updateClabel(_ finishTimeC: Timer) {
        let FinishTime: NSDate = finishTimeC.userInfo as! NSDate //すごい無理やり処理してる感ある
        //残り時間を終了時刻ー現在時刻で取得(秒)
        let leftTime = Int(FinishTime.timeIntervalSinceNow)
        //表示形式に加工
        let minSec = 60
        let leftMin = leftTime / minSec
        let leftSec = leftTime - leftMin * minSec
        let displayString = NSString(format: "%02d:%02d", leftMin, leftSec)
        ConferenceTimerLabel.text = displayString as String
        
        //終了処理
        if leftTime == 0 {
            let soundIDRing: SystemSoundID = 1005
            AudioServicesPlaySystemSound(soundIDRing)
        }
    }

    
    //////////////////////////////////////////議題時間タイマー//////////////////////////////////////////////
    //画面遷移後に議題タイマーをスタートさせるメソッド
    func AgendaTimerStart(){
        for i in 0..<AgendaNameList.count {
            //議題名ラベルをセット
            CurrentAgendaNameLabel.text = AgendaNameList[i]
            if(i == AgendaNameList.count - 1){
                NextAgendaNameLabel.text = "会議終了です"
                
            }else{
                NextAgendaNameLabel.text = AgendaNameList[i + 1]
            }
            //開始時刻を記録
            let startTime = NSDate()
            //終了時刻を計算
            let finishTimeA = NSDate(timeInterval: TimeInterval(DiscussTimeList[i]*60), since: startTime as Date)
//            repeat{
            //0.01秒ごとにupdateAlabel()を呼び出す
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateAlabel), userInfo: finishTimeA, repeats: true)
//            }while(timer.isValid == true)
        }
    }
    
    //議題タイマーの表示を更新させるメソッド
    @objc func updateAlabel(_ finishTimeA: Timer) -> Void {
        let FinishTime: NSDate = finishTimeA.userInfo as! NSDate //すごい無理やり処理してる感ある
        //残り時間を終了時刻ー現在時刻で取得(秒)
        let leftTime = Int(FinishTime.timeIntervalSinceNow)
        //表示形式に加工
        let minSec = 60
        let leftMin = leftTime / minSec
        let leftSec = leftTime - leftMin * minSec
        let displayString = NSString(format: "%02d:%02d", leftMin, leftSec)
        AgendaTimerLabel.text = displayString as String
        
        //終了処理
        if leftTime == 0 {
            let soundIDRing: SystemSoundID = 1000
            AudioServicesPlaySystemSound(soundIDRing)
            timer.invalidate()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ConferenceNameLabel.text = ConferenceNamefrom   //ConferenceViewから受け取った会議名をラベルに代入
        ConferenceTimerStart()
        AgendaTimerStart()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
