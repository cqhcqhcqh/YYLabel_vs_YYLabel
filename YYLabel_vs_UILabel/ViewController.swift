//
//  ViewController.swift
//  YYLabel_vs_UILabel
//
//  Created by chengqihan on 2020/2/15.
//  Copyright © 2020 chengqihan. All rights reserved.
//

import UIKit
import VSText

class ViewController: UIViewController {
    lazy var modify: VSTextLinePositionModifier = {
       let modify = VSTextLinePositionModifier()
        modify.font = UIFont.systemFont(ofSize: 20.0)
        return modify
    }()
    
    let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 200)
    let yylabel = YYLabel()
    let uilabel = UILabel()
    lazy var textShadow: NSShadow = {
        let textShadow = NSShadow()
        textShadow.shadowColor = UIColor(white: 0.0, alpha: 0.25)
        textShadow.shadowOffset = CGSize(width: 0.0, height: 1.0)
        textShadow.shadowBlurRadius = 3
        return textShadow
    }()
    @IBOutlet weak var input: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

//        yylabel.frame = CGRect(origin: CGPoint(x: 50, y: 100),
//                               size: yylabelSize)
        yylabel.frame.origin = CGPoint(x: 50, y: 100)
        yylabel.layer.borderColor = UIColor.green.cgColor
        yylabel.layer.borderWidth = 1.0
        DebugOption.setDebug(true)
        view.addSubview(yylabel)
        
        uilabel.numberOfLines = 0
        uilabel.layer.borderColor = UIColor.green.cgColor
        uilabel.layer.borderWidth = 1.0
        uilabel.frame = CGRect(origin: CGPoint(x: 150, y: 100), size: .zero)
        uilabel.attributedText = attributedString
        view.addSubview(uilabel)
        
        input.addTarget(self, action: #selector(editingDidEnd), for: .editingDidEnd)
        input.addTarget(self, action: #selector(resignFirstResponder), for: .editingDidEndOnExit)
        input.returnKeyType = .done
        
        editingDidEnd()
    }

    var attributedString: NSAttributedString {
        let string = NSMutableAttributedString(
            string: input.text ?? "", attributes: [NSAttributedString.Key.font : UIFont.customFont(withName: "91ea0c0f-45e7-461f-8861-d0971428d446.ttf", size: 40.0) as Any])
//        let index = arc4random_uniform(3)
//        let alignment = NSTextAlignment(rawValue: Int(index))
//        switch alignment {
//        case .left:
//            yylabel.textVerticalAlignment = .top
//        case .right:
//            yylabel.textVerticalAlignment = .center
//        default:
//            yylabel.textVerticalAlignment = .center
//        }
//        string.yy_strokeColor = .brown
//        string.yy_strokeWidth = 5
        string.yy_alignment = .left
        string.yy_color = .green
        return string
    }
    
    @objc func editingDidEnd() {
//        uilabel.attributedText = attributedString
        let layout = yylabelTextLayout
        let verticalLayout = YYTextLayout(container: layout.container, text: layout.verticalFormTextAddTextRunDelegateIfNeeded())
        verticalLayout?.modifyRunGlyphRangeIfNeeded()
        yylabel.frame.size = verticalLayout!.textBoundingSize
        yylabel.textLayout = verticalLayout
//        yylabel.textColor = .black
//        uilabel.frame.size = uilabelSize
        print("yylabelSize: \(yylabel.frame.size) \n uilabelSize:\(uilabel.frame.size)")
    }
    
//    var uilabelSize: CGSize {
//        return attributedString.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
//    }
//
//    var yylabelSize: CGSize {
//        return yylabelTextLayout.textBoundingSize
//    }
    
    var yylabelTextLayout: YYTextLayout {
        let container = YYTextContainer(size: size, insets: .zero)
        container.isVerticalForm = true
        return YYTextLayout(container: container, text: attributedString)!
    }
}

final class VSTextLinePositionModifier: NSObject {
    var font: UIFont!
    var paddingTop: CGFloat = 0.0
    var paddingBottom: CGFloat = 0.0
    var lineHeightMultiple: CGFloat = 0.0
    
    override init() {
        self.lineHeightMultiple = 1.0
    }
    
    func heightForLineCount(lineCount: Int) -> CGFloat {
        if lineCount == 0 {
            return 0
        } else {
            let ascent = (font?.pointSize)! * 0.86
            let descent = (font?.pointSize)! * 0.14
            let lineHeight = (font?.pointSize)! * lineHeightMultiple
            let height = paddingTop + paddingBottom + ascent + descent
            return height + CGFloat(lineCount - 1) * lineHeight
        }
    }
}

extension VSTextLinePositionModifier: YYTextLinePositionModifier {
    public func copy(with zone: NSZone? = nil) -> Any {
        let one = VSTextLinePositionModifier()
        one.font = font
        one.paddingTop = paddingTop
        one.paddingBottom = paddingBottom
        one.lineHeightMultiple = lineHeightMultiple
        return one
    }
    
    func modifyLines(_ lines: [YYTextLine],
                     fromText text: NSAttributedString,
                     in container: YYTextContainer) {
        let lineHeight = font.lineHeight
        for line in lines {
            var position = line.position
            position.y = paddingTop + font.ascender + CGFloat(line.row) * (lineHeight)
            line.position = position
        }
    }
}

