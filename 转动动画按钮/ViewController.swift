//
//  ViewController.swift
//  转动动画按钮
//
//  Created by qzp on 15/11/18.
//  Copyright © 2015年 qzp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var wheelButton: MoveWheelButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        wheelButton = MoveWheelButton(frame: CGRectMake(100, 200, 150, 40))
        wheelButton.backgroundColor = UIColor.greenColor()
        wheelButton.setTitle("大家好", forState: .Normal)
        wheelButton.layerCorner = 10
        self.view.addSubview(wheelButton)
        
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func startClick(sender: AnyObject) {
        
        wheelButton.start()
    }
    
    @IBAction func stopClick(sender: AnyObject) {
        
        
        wheelButton.stop()
    }
    
    
    func test1 () {
        let testView = UIView(frame: CGRectMake(100, 100, 200, 200))
        testView.backgroundColor = UIColor ( red: 0.7923, green: 0.7181, blue: 0.4885, alpha: 1.0 )
        
        self.view.addSubview(testView)
        
        let tLayer = CAShapeLayer()
        tLayer.frame = testView.bounds
        tLayer.strokeColor = UIColor.greenColor().CGColor
        tLayer.fillColor = UIColor.redColor().CGColor
        //起始角度
        let startAngle = -0
        //结束角度
        let endAngle = M_PI * 2
        tLayer.strokeEnd = 0.5
        //开始位置
        tLayer.strokeStart = 0
        let arcCenter = CGPointMake(testView.bounds.midX, testView.bounds.midY)
        //设置路径,从贝塞尔曲线获取到形状
        tLayer.path = UIBezierPath(arcCenter: arcCenter, radius: testView.frame.height/4, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true).CGPath
        testView.layer.addSublayer(tLayer)
        
    }

}

