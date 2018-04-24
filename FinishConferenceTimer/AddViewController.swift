//
//  AddViewController.swift
//  FinishConferenceTimer
//
//  Created by 大林拓実 on 2018/04/24.
//  Copyright © 2018年 Life is tech. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet var NameTextField: UITextField!
    @IBOutlet var TimePickerView: UIPickerView!
    
    var AgendaList: [Dictionary<String, Int>] = []
    let saveData = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveAgenda(){
        
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
