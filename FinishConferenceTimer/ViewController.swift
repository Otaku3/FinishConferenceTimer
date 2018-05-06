//
//  ViewController.swift
//  FinishConferenceTimer
//
//  Created by 大林拓実 on 2018/04/24.
//  Copyright © 2018年 Life is tech. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var ConferenceName: UITextField!
    
    // 改行ボタンを押した時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを隠す
        ConferenceName.resignFirstResponder()
        return true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ConferenceName.delegate = self
        //TextFieldを改良
        ConferenceName.textColor = UIColor.black                        //文字色
        ConferenceName.backgroundColor = UIColor(white: 0.9, alpha: 1)   // 背景色
        ConferenceName.placeholder = "○○会議"                        //プレースホルダー設定
        ConferenceName.clearButtonMode = .always                    //全消去ボタン設定
        ConferenceName.returnKeyType = .done                        //改行ボタン→完了ボタン
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //UserDefaultのデータ削除
        let userDefaults = UserDefaults.standard
        if let domain = Bundle.main.bundleIdentifier {
            userDefaults.removePersistentDomain(forName: domain)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //スタートボタンタップ時の処理
    @IBAction func startButtonTapped(){
        if ConferenceName.text !=  "" {
            //入力があれば画面遷移
            self.performSegue(withIdentifier: "toConferenceView", sender: nil)
        }else{
            //無ければアラート
            let alert: UIAlertController = UIAlertController(title: "未入力", message: "会議名を入力してください", preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(title: "OK", style: .default, handler: nil)
            )
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //入力された会議名をConferenceViewに渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toConferenceView" {
            let ConferenceVC = segue.destination as! ConferenceViewController
            ConferenceVC.NamefromVC = ConferenceName.text!
            ConferenceName.text = ""
        }
    }
    
    //unwind Segue
    @IBAction func backVC (segue: UIStoryboardSegue){
    }

    
}

