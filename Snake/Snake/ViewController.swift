//
//  ViewController.swift
//  Snake
//
//  Created by 邝子涵 on 2018/1/24.
//  Copyright © 2018年 上海仁菜网络科技有限公司. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentIndex = 0
    
    var direction:SnakeDirection = .right
    
    // MARK: -
    var backView: BackView?
    
    // MARK: - timerInC
    var timerInC: CADisplayLink?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentIndex = 0
        direction = .right
        setupUI()
        
        let timerInC = CADisplayLink(target: self, selector: #selector(moveWithDirection(direction:)))
        // ios10 新推出，每秒触发多少次
        timerInC.preferredFramesPerSecond = 9
        // 加入一个runLoop
        timerInC.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
        self.timerInC = timerInC
        
        setupSwipeGestureRecognizer()
        
    }
    
    
    func setupUI() {
        let backView = BackView()
        view.addSubview(backView)
        self.backView = backView
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: backView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: backView, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: backView, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: backView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
    }
    
    func setupSwipeGestureRecognizer() {
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(changeDirection(sender:)))
        leftRecognizer.direction = .left
        view.addGestureRecognizer(leftRecognizer)
        
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(changeDirection(sender:)))
        rightRecognizer.direction = .right
        view.addGestureRecognizer(rightRecognizer)
        
        let upRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(changeDirection(sender:)))
        upRecognizer.direction = .up
        view.addGestureRecognizer(upRecognizer)
        
        let downRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(changeDirection(sender:)))
        downRecognizer.direction = .down
        view.addGestureRecognizer(downRecognizer)
    }
    
    
    @objc func changeDirection(sender: UISwipeGestureRecognizer) {
        
        if sender.direction == .down && direction != .up {
            direction = .down
        } else if sender.direction == .left && direction != .right {
            direction = .left
        } else if sender.direction == .up && direction != .down {
            direction = .up
        } else if sender.direction == .right && direction != .left {
            direction = .right
        }
    }
    
    
    @objc func moveWithDirection(direction: Int) {
        backView?.moveWithDirection(direction: self.direction)
        changeSpeed()
        dead()
    }
    
    func changeSpeed() {
        guard let backView = backView else { return }
        let snakeLength = backView.snakeLength
        if snakeLength > 8 && snakeLength <= 15 {  // 长度大于8并且小于等于15
            timerInC?.preferredFramesPerSecond = 12
            backView.snakeColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        } else if snakeLength > 15 && snakeLength <= 25 {  // 长度大于15并且小于等于25
            timerInC?.preferredFramesPerSecond = 15
            backView.snakeColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        } else if snakeLength > 25 && snakeLength <= 35 {  // 长度大于25并且小于等于35
            timerInC?.preferredFramesPerSecond = 20
            backView.snakeColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        } else if snakeLength > 35 && snakeLength <= 50 {  // 长度大于35并且小于等于50
            timerInC?.preferredFramesPerSecond = 30
            backView.snakeColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        } else if snakeLength > 50 && snakeLength <= 60 {  // 长度大于50并且小于等于60
            timerInC?.preferredFramesPerSecond = 40
            backView.snakeColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        } else if snakeLength > 60 && snakeLength <= 70 {  // 长度大于60并且小于等于70
            timerInC?.preferredFramesPerSecond = 50
            backView.snakeColor = #colorLiteral(red: 0.5791940689, green: 0.1280144453, blue: 0.5726861358, alpha: 1)
        } else if snakeLength > 100 {  // 超过100
            timerInC?.preferredFramesPerSecond = 60
            backView.snakeColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
    }
    
    
    
    func dead() {
        guard let backView = backView else { return }
        guard let timerInC = timerInC else { return }
        guard let headpoint = backView.headpoint else { return }
        for i in 0..<backView.snakeLength {
            if backView.snakePoints.last == backView.snakePoints[i] ||
                !(CGRect(x: 15, y: 16, width: view.frame.size.width - 30, height: view.frame.size.height - 32).contains(headpoint)){
                timerInC.isPaused = true
                let alertVC = UIAlertController(title: "游戏结束", message: "蛇身长度\(backView.snakeLength)", preferredStyle: .alert)
                
                
                let acSure = UIAlertAction(title: "重新开始", style: UIAlertActionStyle.default) {[weak self] (UIAlertAction) -> Void in
                    self?.backView?.removeFromSuperview()
                    self?.viewDidLoad()
                }
                alertVC.addAction(acSure)
                
                self.present(alertVC, animated: true, completion: nil)
                
                
            }
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

