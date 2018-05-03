//
//  AddViewController.swift
//  FinishConferenceTimer
//
//  Created by 大林拓実 on 2018/04/24.
//  Copyright © 2018年 Life is tech. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let minutesList: [Int] = [0,5,10,15,20,25,30,35,40,45,50,55]
    let hoursList: [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12]
    var selectMinute:Int = 0
    
    @IBOutlet var nameTextField: UITextField!   //議題入力フィールド
    @IBOutlet var TimePickerView: UIPickerView!
    @IBOutlet var hourLabel: UILabel!   //時間表示ラベル
    @IBOutlet var minuteLabel: UILabel! //分表示ラベル
    
    var AgendaNameList: [String] = []
    var DiscussTimeList: [Int] = []
    
    let saveData = UserDefaults.standard
    
    ///////////////////////////////////////PickerViewの設定////////////////////////////////////////////////////////
    //列数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    //表示行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0{
        return hoursList.count
        }
        return minutesList.count
    }
    //表示内容
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
        return String(hoursList[row])
        }
        return String(minutesList[row])
    }
    //選択処理
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0{
            selectMinute = hoursList[row] * 60
            hourLabel.text = String(hoursList[row]) + "時間"
        }
        if component == 1{
            selectMinute = minutesList[row]
            minuteLabel.text = String(minutesList[row]) + "分"
        }
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func SaveData() {
        //議題名が入力されていない時の警告
        if nameTextField.text == ""{
            let alert = UIAlertController(title: "議題名", message: "議題を入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            AgendaNameList.append(nameTextField.text!)
            DiscussTimeList.append(selectMinute)
            
            saveData.set(AgendaNameList, forKey: "AGENDA")
            saveData.set(DiscussTimeList, forKey: "TIME")
            
            let alert = UIAlertController(title: "保存完了", message: "議題の登録が完了しました", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            nameTextField.text = ""
        }
    }
    
    @IBAction func back (segue: UIStoryboardSegue){
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Userdefaultからの読み込み
        if saveData.array(forKey: "AGENDA") != nil{
            AgendaNameList = saveData.array(forKey: "AGENDA") as! [String]
        }
        if saveData.array(forKey: "TIME") != nil{
            DiscussTimeList = saveData.array(forKey: "TIME") as! [Int]
        }
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
