//
//  AddViewController.swift
//  FinishConferenceTimer
//
//  Created by 大林拓実 on 2018/04/24.
//  Copyright © 2018年 Life is tech. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    let minutesList: [Int] = [0,1,5,10,15,20,25,30,35,40,45,50,55]
    let hoursList: [Int] = [0,1,2,3,4,5,6,7,8,9,10,11,12]
    var registerSeconds:Int = 0    //登録する議論時間を格納（秒）
    var selectHour: Int = 0       // PickerViewで選択されている時間を保持（秒）
    var selectMinute: Int = 0     // PickerViewで選択されている分を保持（秒）
    
    @IBOutlet var nameTextField: UITextField!   //議題入力フィールド
    @IBOutlet var TimePickerView: UIPickerView!
//    @IBOutlet var agendaName: UILabel!  //議題表示ラベル
    @IBOutlet var hourLabel: UILabel!   //時間表示ラベル
    @IBOutlet var minuteLabel: UILabel! //分表示ラベル
    
    var AgendaNameList: [String] = []   //UserDefaultから読み込むための配列
    var DiscussTimeList: [Int] = []     //UserDefaultから読み込むための配列
    
    let saveData = UserDefaults.standard
    
    ////////////////////////////////////TextFieldの設定/////////////////////////////////////////////////////
    // 改行ボタンを押した時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        agendaName?.text = nameTextField.text
        
        // キーボードを隠す
        nameTextField.resignFirstResponder()
        return true
    }
    
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
    //サイズ
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return TimePickerView.bounds.width * 1/2
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
            selectHour = hoursList[row] * 60 * 60
            hourLabel.text = String(hoursList[row]) + " 時間"
        }
        if component == 1{
            selectMinute = minutesList[row] * 60
            minuteLabel.text = String(minutesList[row]) + " 分"
        }
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    @IBAction func SaveData() {
        registerSeconds = selectHour + selectMinute //registerSecondsに選択された時間を格納
        
        if nameTextField.text == "" {    //議題名が入力されていない時の警告
            let alert = UIAlertController(title: "議題名", message: "議題を入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if registerSeconds == 0 {     //時間が設定されてない時の警告
            let alert = UIAlertController(title: "議論時間", message: "時間を設定してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else{   //尽くされていたら登録
            AgendaNameList.append(nameTextField.text!)
            DiscussTimeList.append(registerSeconds)
            
            saveData.set(AgendaNameList, forKey: "AGENDA")
            saveData.set(DiscussTimeList, forKey: "TIME")
            
            //登録を続けるか確認（続けなければ戻る）
            let alert = UIAlertController(title: "保存完了", message: "続けて登録しますか？", preferredStyle: .alert)
            let okAction: UIAlertAction = UIAlertAction(title: "はい", style: .cancel, handler: nil)
            let canselAction: UIAlertAction = UIAlertAction(title: "いいえ", style: .default, handler: {
                (action: UIAlertAction!) -> Void in
                self.performSegue(withIdentifier: "fromAddView", sender: self)
            })
            alert.addAction(okAction)
            alert.addAction(canselAction)
            self.present(alert, animated: true, completion: nil)
            
            
            //画面表示戻す
            nameTextField.text = ""
            TimePickerView.selectRow(0, inComponent: 0, animated: true)
            hourLabel.text = String(hoursList[0]) + " 時間"
            TimePickerView.selectRow(0, inComponent: 1, animated: true)
            minuteLabel.text = String(minutesList[0]) + " 分"
//            agendaName.text = ""
            //変数をクリア
            registerSeconds = 0
            selectMinute = 0
            selectHour = 0
            
        }
    }
    
    func back (segue: UIStoryboardSegue){
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hourLabel.text = "0 時間"
        minuteLabel.text = "0 分"
        
        //Userdefaultからの読み込み
        if saveData.array(forKey: "AGENDA") != nil{
            AgendaNameList = saveData.array(forKey: "AGENDA") as! [String]
        }
        if saveData.array(forKey: "TIME") != nil{
            DiscussTimeList = saveData.array(forKey: "TIME") as! [Int]
        }
        
        //TextFiled周り
        nameTextField.delegate = self
        //TextFieldを改良
        nameTextField.frame.size.height = 50    //高さ
        nameTextField.font = UIFont.systemFont(ofSize: 36)  //フォント変更
        nameTextField.textColor = UIColor.black                        //文字色
        nameTextField.backgroundColor = UIColor(white: 0.9, alpha: 1)   // 背景色
        nameTextField.placeholder = "議題名"                        //プレースホルダー設定
        nameTextField.clearButtonMode = .always                    //全消去ボタン設定
        nameTextField.returnKeyType = .done                        //改行ボタン→完了ボタン
        
        //PickerView周り
        //"時間"の固定ラベル追加
        let hStr = UILabel()
        hStr.font = UIFont(name: "Hiragino Maru Gothic ProN W4", size: hStr.font.pointSize) //フォント変更
        hStr.text = "時間"
        hStr.sizeToFit()
        hStr.frame = CGRect(x : TimePickerView.bounds.width/2 - hStr.bounds.width,y : TimePickerView.bounds.height/2 - hStr.bounds.height/2,width : hStr.bounds.width,height: hStr.bounds.height)
        TimePickerView.addSubview(hStr)
        //"分"の固定ラベル追加
        let mStr = UILabel()
        mStr.font = UIFont(name: "Hiragino Maru Gothic ProN W4", size: mStr.font.pointSize) //フォント変更
        mStr.text = "分"
        mStr.sizeToFit()
        mStr.frame = CGRect(x : TimePickerView.bounds.width - mStr.bounds.width,y : TimePickerView.bounds.height/2 - mStr.bounds.height/2,width : mStr.bounds.width,height: mStr.bounds.height)
        TimePickerView.addSubview(mStr)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //画面外をタッチした時にキーボードをしまう
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.nameTextField.endEditing(true)
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
