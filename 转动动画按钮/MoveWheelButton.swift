
//
//  MoveWheelButton.swift
//  转动动画按钮
//
//  Created by qzp on 15/11/18.
//  Copyright © 2015年 qzp. All rights reserved.
//

import UIKit

/// 按钮中间的旋转线
class QShapeLayer: CAShapeLayer {
/**CAShapeLayer在初始化时也需要给一个frame值,但是,它本身没有形状,它的形状来源于你给定的一个path,
    然后它去取CGPath值,它与CALayer有着很大的区别
    1. 它依附于一个给定的path,必须给与path,而且,即使path不完整也会自动首尾相接
    2. strokeStart以及strokeEnd代表着在这个path中所占用的百分比
    3. CAShapeLayer动画仅仅限于沿着边缘的动画效果,它实现不了填充效果
*/
    
    init(frame: CGRect) {
        super.init()
        self.frame = frame
        initializeUserInterface()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeUserInterface() {
        //大小位置
        self.frame = CGRectMake(0, 0, frame.size.height, frame.size.height)
        //起始角度
        let startAngle = -M_PI_2
        //结束角度
        let endAngle = M_PI * 2 - M_PI_2
        
        let arcCenter = CGPointMake(self.bounds.midX, self.bounds.midY)
        //设置路径,从贝塞尔曲线获取到形状
        self.path = UIBezierPath(arcCenter: arcCenter, radius: frame.height/4, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true).CGPath
        //闭环填充的颜色
        self.fillColor = nil
        //边缘线的颜色
        self.strokeColor = UIColor.whiteColor().CGColor
        
        self.lineWidth = 1
        
        //边缘线的结束位置
        self.strokeEnd = 0.5
        //边缘线的开始位置
        self.strokeStart = 0
        self.hidden = true
     }
    
    /**
    开始动画
    */
    func start() {
        self.hidden = false
        //创建旋转动画，即指定z轴，围绕中心点旋转
        /*ABasicAnimation 自己只有三个property   fromValue  toValue  ByValue
        当你创建一个 CABasicAnimation 时,你需要通过-setFromValue 和-setToValue 来指定一个开始值和结束值。 当你增加基础动画到层中的时候,它开始运行。当用属性做动画完成时,例如用位置属性做动画,层就会立刻 返回到它的初始位置
        */
        let basicAnimation = CABasicAnimation()
        basicAnimation.keyPath = "transform.rotation.z"
        //旋转360度 0 - 2pi
        //初始位置
        basicAnimation.fromValue = 0
        basicAnimation.toValue = M_PI * 2
        //时间
        basicAnimation.duration = 0.4
        //重复次数
        basicAnimation.repeatCount = MAXFLOAT
        //显示方式，线性动画
        basicAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        //用CABasicAnimation执行动画，在动画结束后会回归动画开始前的状态。想要解决的话，必须设置“removedOnCompletion”和“fillMode”这两个属性。
        //kCAFillModeForwards 当动画结束后,layer会一直保持着动画最后的状态
        basicAnimation.removedOnCompletion = false
        basicAnimation.fillMode = kCAFillModeForwards
        self.addAnimation(basicAnimation, forKey: basicAnimation.keyPath)
    }

    /**
    停止动画
    */
    func stop() {
        self.hidden = true
        self.removeAllAnimations()
    }
}


class MoveWheelButton: UIButton {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    var durtion: NSTimeInterval = 0.2
    /// 转角幅度
    var layerCorner: CGFloat? {
        didSet{
            self.layer.cornerRadius = layerCorner!
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    lazy var qshapLayer: QShapeLayer! = {
        let tLayer = QShapeLayer(frame: self.bounds)
        self.layer.addSublayer(tLayer)
        return tLayer
        }()
    
    var tempTitle: String?
    
    /**
    开始动画
    */
    func start() {
        self.layer.cornerRadius = CGRectGetHeight(self.bounds)/2
        //保存title，开始动画时，title为空
        self.tempTitle = titleForState(.Normal)
        setTitle("", forState: .Normal)
        shrinkAnimation()
        userInteractionEnabled = false
        qshapLayer.start()
    }
    
    /**
    结束动画
    */
    func stop() {
        if let lc = layerCorner  {
            self.layer.cornerRadius = lc
        }
        
        layer.removeAllAnimations()
        qshapLayer.stop()
        setTitle(tempTitle, forState: .Normal)
        userInteractionEnabled = true
        
    }
    /**
    按钮收缩动画
    */
    func shrinkAnimation() {
        
        //将按钮自身，宽度 改为 自身高度
        let shrinkAnimation = CABasicAnimation(keyPath: "bounds.size.width")
        shrinkAnimation.fromValue = frame.width
        shrinkAnimation.toValue = frame.height
        shrinkAnimation.duration = durtion
        shrinkAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        shrinkAnimation.fillMode = kCAFillModeForwards
        shrinkAnimation.removedOnCompletion = false //结束时自动复原
        layer.addAnimation(shrinkAnimation, forKey: shrinkAnimation.keyPath)
    }
    
}
