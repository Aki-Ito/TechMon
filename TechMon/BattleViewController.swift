//
//  BattleViewController.swift
//  TechMon
//
//  Created by 伊藤明孝 on 2020/09/16.
//  Copyright © 2020 com.litech. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel: UILabel!
    @IBOutlet var playerTPLabel: UILabel!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    let techMonManager = TechMonManager.shared//音楽再生などで使う便利クラス
    
    var playerHP=100
    var playerMP=0
    var enemyHP=100
    var enemyMP=0
    
    var player: Character!
    var enemy: Character!
    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true

    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        //キャラクターの読み込み
        player = techMonManager.player
        enemy = techMonManager.enemy
        //プレイヤーのステータスを変換
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        playerHPLabel.text = "\(playerHP)/100"
        playerMPLabel.text = "\(playerMP)/100"
        
        
        //敵のステータスを変換
        enemyNameLabel.text = "龍"
        enemyImageView.image = UIImage(named: "monster.png")
        enemyHPLabel.text = "\(enemyHP)/100"
        enemyMPLabel.text = "\(enemyMP)/100"
        
        
        //ゲームスタート
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                         selector: #selector(updateGame), userInfo: nil, repeats: true)
        
        gameTimer.fire()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        
        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }

    //0.1秒ごとにゲームの状態を更新する
    
    @objc func updateGame(){
        
        //プレイヤーのステータスを更新
        playerMP+=1
        
        if playerMP>=20 {
            isPlayerAttackAvailable = true
            playerMP = 20
        
        } else {
            isPlayerAttackAvailable = false
        }
        
        //敵のステータスを更新
        enemyMP+=1
        if enemyMP >= 35{
            
            enemyAttack()
            enemyMP = 0
       }
        
        playerMPLabel.text = "\(playerMP)/20"
        enemyMPLabel.text = "\(enemyMP)/35"
    }


    //的の攻撃
    func enemyAttack(){
        
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        playerHP-=20
        
        playerHPLabel.text = "\(playerHP)/100"
        
        if playerHP <= 0 {
            
           finishBattle(VanishImageView: playerImageView, isPlayerWin: false)
        }
    }
    
    //勝敗が決したときの処理
    func finishBattle(VanishImageView: UIImageView, isPlayerWin: Bool){
        
        techMonManager.vanishAnimation(imageView: VanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable=false
        
        var finishMessage: String = ""
        
        if isPlayerWin {
            
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！！"
        } else {
            
            techMonManager.playSE(fileName:  "SE_gameover")
            finishMessage = "勇者の敗北..."
        }
        
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //ボタンを押したときの処理、0.1秒毎に画面が更新されるのでステータスのみを変える
    @IBAction func attackAction(){
        
               if isPlayerAttackAvailable {
                   
                   techMonManager.damageAnimation(imageView: enemyImageView)
                   techMonManager.playSE(fileName: "SE_attack")
                
                   enemy.currentHP-=player.attackPoint
                   
                   player.currentTP+=10
                if player.currentTP >= player.maxTP{
                    
                    player.currentTP = player.maxTP
                }
                    player.currentMP = 0
                    
                    judgeBattle()
               }
           }
    @IBAction func fireaction(){
        
        if isPlayerAttackAvailable && player.currentTP >= 40{
            
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_fire")
            
            enemy.currentHP -= 100
            player.currentTP -= 40
            if player.currentTP<=0 {
                
                player.currentTP=0
            }
            player.currentMP=0
            
            judgeBattle()
        }
    }
 //ステータスの反映
    func updateUI(){
        //プレイヤーのステータスを変換
        playerHPLabel.text = "\(player.currentHP) / \(player.maxHP)"
        playerMPLabel.text = "\(player.currentMP) / \(player.maxMP)"
        playerTPLabel.text = "\(player.currentTP) / \(player.maxTP)"
        //敵のステータスを変換
        enemyHPLabel.text = "\(enemy.currentHP) / \(enemy.maxHP)"
        enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP)"
    }
    
    
    //勝敗を決定する
    func judgeBattle(){
        if player.currentHP <= 0 {
            
            finishBattle(VanishImageView: playerImageView, isPlayerWin: false)
        }else if enemy.currentHP<=0 {
            
            finishBattle(VanishImageView: enemyImageView, isPlayerWin: true)
        }
    }
    
    @IBAction func tameruAction(){
        
        if isPlayerAttackAvailable {
            
            techMonManager.playSE(fileName: "SE_charge")
            player.currentTP+=40
            if player.currentTP>=player.maxTP {
                
                player.currentTP = player.maxTP
            }
            player.currentMP = 0
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

}
