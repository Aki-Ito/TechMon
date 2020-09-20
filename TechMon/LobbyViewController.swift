//
//  LobbyViewController.swift
//  TechMon
//
//  Created by 伊藤明孝 on 2020/09/16.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var staminaLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var stamina: Int = 100
    var staminaTimer: Timer!
    
    
    //アプリが起動したときに一度だけ呼ばれる
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIの設定
        nameLabel.text = "勇者"
        staminaLabel.text = "\(stamina)/100"
        //タイマーの設定
        staminaTimer = Timer.scheduledTimer(
            timeInterval: 3,
            target: self,
            selector: #selector(updateStaminaValue),
            userInfo: nil,
            repeats: true)
        staminaTimer.fire()
        // Do any additional setup after loading the view.
    }
    
    
    //ロビー画面が見えるようになるときに現れる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "lobby")
    }

    //ロビー画面が見えなくなるときに呼ばれる
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
    //
    @IBAction func toBattle(){
        //スタミナが50以上あればスタミナを50消費して先頭画面へ
        if stamina>=50 {
            
            stamina-=50
            staminaLabel.text="\(stamina)/100"
            performSegue(withIdentifier: "toBattle", sender: nil)
            
        }else{
            
        let alert = UIAlertController(title: "バトルに行けません", message: "スタミナが足りません", preferredStyle: .alert)
       
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
     }
    }
    
    //スタミナの回復
    @objc func updateStaminaValue() {
            
            if stamina<100{
                
                stamina+=1
                staminaLabel.text="\(stamina)/100"
            }
        }
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



