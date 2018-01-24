//
//  BackView.swift
//  tanchishe
//
//  Created by 邝子涵 on 2018/1/16.
//  Copyright © 2018年 上海仁菜网络科技有限公司. All rights reserved.
//

import UIKit



enum SnakeDirection {
    case down;
    case left;
    case up;
    case right;
}

class BackView: UIView {
    // 🐍当前方向
    var snakeDirection:SnakeDirection = .right
    // 🐍身长度
    var snakeLength = 5
    // 🐍身颜色
    var snakeColor:UIColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    // 食物个数 默认10个
    var foodNum = 10
    // 记录当前移动位置，用于吃食物所用
    var headpoint:CGPoint?


    // MARK: - 🐍运动路径
    lazy var snakePoints: [NSValue] = {
        var snakePoints = [NSValue]()

        let value = NSValue(cgPoint: CGPoint(x: 95, y: 95))
        snakePoints.append(value)

        for i in 0..<self.snakeLength {
            let value = NSValue(cgPoint: CGPoint(x: 85-i*10, y: 95))
            snakePoints.append(value)
        }

        // 调换位置
        for x in 0..<self.snakeLength {
            for y in 0..<self.snakeLength-x {
                let value = snakePoints[y]
                snakePoints[y] = snakePoints[y+1]
                snakePoints[y+1] = value
            }
        }

        return snakePoints
    }()


    // MARK: - 食物
    lazy var foods: [UIView] = {
        var foods = [UIView]()
        for i in 0..<self.foodNum {
            let food = createFood()
            foods.append(food)
        }
        return foods
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        // 初始化食物
        _ = foods
    }


    override func layoutSubviews() {
        super.layoutSubviews()

//        snakeLength = 5
//        snakeDirection = .right
//        snakeColor = UIColor.magenta
    }

    // MARK: - 创建食物视图
    private func createFood() -> UIView {
        let food = UIView()
        let point = foodPoint()
        food.frame = CGRect(x: point.x, y: point.y, width: 10, height: 10)
        food.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        food.layer.cornerRadius = 5
        addSubview(food)
        return food
    }


    // MARK: - 创建食物位置
    private func foodPoint() -> CGPoint {
        let x = Int(arc4random_uniform(33) * 10 + 20)
        let y = Int(arc4random_uniform(62) * 10 + 20)
        return CGPoint(x: x, y: y)
    }


    private func eatFood() {
        for view in foods {
            eatWithFood(food: view)
        }
    }


    private func eatWithFood(food: UIView) {
        if headpoint?.x == food.center.x && headpoint?.y == food.center.y  {
            var point = foodPoint()
            for value in snakePoints {
                let bodyPoint = value.cgPointValue
                if bodyPoint == point {
                    let newPoint = foodPoint()
                    point = newPoint
                }
            }

            food.layer.position = CGPoint(x: point.x - 5, y: point.y - 5)
            snakeLength += 1

            let value = NSValue(cgPoint: .zero)
            snakePoints.append(value)

            // 调换位置
            for i in (1...snakeLength).reversed() {
                let value = snakePoints[i]
                snakePoints[i] = snakePoints[i-1]
                snakePoints[i-1] = value
            }
            setNeedsDisplay()
        }
    }


    override func draw(_ rect: CGRect) {
        // 画🐍头
        let path = UIBezierPath()
        path.lineWidth = 2.5
        guard let point = snakePoints.last?.cgPointValue else { return }
        path.move(to: point)
        path.addArc(withCenter: point, radius: 5, startAngle: 0, endAngle: CGFloat(Double.pi*2), clockwise: true)
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1).set()
        path.stroke()


        // 画🐍身体
        for i in (0...snakeLength-1).reversed() {
//            print(snakePoints[i])
            // 创建上下文
            let contexRef = UIGraphicsGetCurrentContext()
            contexRef?.setLineWidth(10)
            let point = snakePoints[i].cgPointValue
            contexRef?.move(to: point)
            contexRef?.addLine(to: point)
            contexRef?.setStrokeColor(snakeColor.cgColor)
            contexRef?.setLineCap(.round)
            contexRef?.setLineJoin(.round)
            contexRef?.drawPath(using: .stroke)
        }

        // 边框
        let lineContextRef = UIGraphicsGetCurrentContext()
        lineContextRef?.setLineWidth(10)
        lineContextRef?.addRect(CGRect(x: 5, y: 5, width: frame.width - 10, height: frame.height - 10))
        lineContextRef?.setStrokeColor(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))
        lineContextRef?.drawPath(using: .stroke)

//        print("============= 执行一次 ===========")

        eatFood()
    }


    func moveWithDirection(direction: SnakeDirection) {
        snakePoints.remove(at: 0)
        guard let point = snakePoints.last?.cgPointValue else { return }
        headpoint = point

        switch direction {
        case .left:
            if direction != .right {
                let point = CGPoint(x: point.x - 10, y: point.y)

//                if point.x < 10 {
//                    point.x = getThresholdX()
//                }
                let value = NSValue(cgPoint: point)
                snakePoints.append(value)
                setNeedsDisplay()
                snakeDirection = .left
            }
            break
        case .up:
            if direction != .down {
                let point = CGPoint(x: point.x, y: point.y - 10)

//                if point.y < 10 {
//                    point.y = getThresholdY()
//                }

                let value = NSValue(cgPoint: point)
                snakePoints.append(value)
                setNeedsDisplay()
                snakeDirection = .up
            }
            break
        case .right:
            if direction != .left {
                let point = CGPoint(x: point.x + 10, y: point.y)

//                if point.x > frame.width - 10 {
//                    point.x = 15
//                }

                let value = NSValue(cgPoint: point)
                snakePoints.append(value)
                setNeedsDisplay()
                snakeDirection = .right
            }
            break
        case .down:
            if direction != .up {
                let point = CGPoint(x: point.x, y: point.y + 10)

//                if point.y > frame.height - 10 {
//                    point.y = 15
//                }

                let value = NSValue(cgPoint: point)
                snakePoints.append(value)
                setNeedsDisplay()
                snakeDirection = .down
            }
            break
        }
    }


    func getThresholdY() -> CGFloat {
        if UIScreen.main.bounds.size.height == 667 {
            return 655
        } else if UIScreen.main.bounds.size.height == 736 {
            return 725
        } else if UIScreen.main.bounds.size.height == 568 {
            return 555
        }
        return 0
    }

    func getThresholdX() -> CGFloat {
        if UIScreen.main.bounds.size.width == 375 {
            return 355
        } else if UIScreen.main.bounds.size.width == 414 {
            return 395
        } else if UIScreen.main.bounds.size.width == 320 {
            return 305
        }
        return 0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}




