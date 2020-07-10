//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

/*:
 ## 这是一个注释
 */

class HLLAttributeBuilder {
    
    fileprivate struct AttributeObject {
        
        var attributedString : NSAttributedString
        
        init(attString:NSAttributedString) {
            self.attributedString = attString
        }
    }
    // 结构体和枚举是值类型。默认情况下，值类型的属性不能在它的实例方法中被修改。
    // 如果你确实需要在某个特定的方法中修改结构体或者枚举的属性，你可以为这个方法选择可变(mutating
    fileprivate var defaultStyle : Dictionary<String,Any> = [NSForegroundColorAttributeName:UIColor.black,
                                                             NSFontAttributeName:UIFont.systemFont(ofSize: 16)]
    fileprivate var attributeObjects = Array<Any>()
    fileprivate var originalString : String = ""
    
    init() {
    }
    
    init(with defaultStyle : Dictionary<String ,Any>) {
        
        self.defaultStyle = defaultStyle
    }
    
    public func appendString(_ string : String) -> HLLAttributeBuilder {
        
        return self.appendString(string, withStyle: self.defaultStyle)
    }
    
    public func appendString(_ string : String ,withStyle : Dictionary<String, Any>) -> HLLAttributeBuilder {
        
        assert(!string.isEmpty, "请输入有效的字符串")
        
        let mergeStyle = NSMutableDictionary.init(dictionary:self.defaultStyle)
        mergeStyle.addEntries(from: withStyle)
        
        let attString = NSAttributedString.init(string: string, attributes: mergeStyle as? [String : Any])
        self.attributeObjects.append(AttributeObject.init(attString: attString))
        
        return self
    }
    
    public func attributedString() -> NSAttributedString? {
        
        guard attributeObjects.isEmpty else {
            
            let outPut = NSMutableAttributedString()
            self.attributeObjects.forEach({ (attObj) in
                outPut.append((attObj as! AttributeObject).attributedString)
            })
            return outPut
        }
        return nil
    }
}

extension HLLAttributeBuilder{
    
    fileprivate func appendAttachment(_ attachment : NSTextAttachment) -> HLLAttributeBuilder {
        
        let attString = NSAttributedString.init(attachment: attachment)
        self.attributeObjects.append(AttributeObject.init(attString: attString))
        return self
    }
}

extension HLLAttributeBuilder{
    
    
    convenience init(with originalString:String) {
        self.init()
        self.originalString = originalString
        self.appendString(originalString)
    }
    
    convenience init(with originalString:String ,defaultStyle : Dictionary<String,Any>) {
        self.init(with: defaultStyle)
        self.originalString = originalString
        self.appendString(originalString)
    }
    
    public func configString(_ string : String ,with style:Dictionary<String, Any>) -> HLLAttributeBuilder {
        
        assert(!string.isEmpty, "请输入有效的字符串")
        
        let mergeStyle = NSMutableDictionary.init(dictionary: self.defaultStyle)
        mergeStyle.addEntries(from: style)
        
        assert(!attributeObjects.isEmpty,"请使用`builderWithString:`或者`builderWithString:defaultStyle:`初始化 HLLAttributedBuilder ")
        
        let attObj = self.attributeObjects[0] as! AttributeObject
        
        let attributedText = NSMutableAttributedString.init(attributedString: attObj.attributedString)
        
        do {
            let regExp = try NSRegularExpression.init(pattern: string, options: .ignoreMetacharacters)
            let originalStringRange = NSMakeRange(0, self.originalString.characters.count)
            let matches = regExp.matches(in: self.originalString,
                                         options: .withTransparentBounds,
                                         range: originalStringRange)
            matches.forEach({ (match) in
                attributedText.addAttributes(mergeStyle as! [String : Any], range: match.range)
            })
            self.attributeObjects.removeAll()
            self.attributeObjects.append(AttributeObject.init(attString: attributedText))
            return self
        } catch {
            return self
        }
    }
}

let attBuilder = HLLAttributeBuilder()
    .appendString("nihao")
    .appendString("Hello world", withStyle: [NSForegroundColorAttributeName:UIColor.green,
                                             NSUnderlineColorAttributeName:UIColor.orange,
                                             NSUnderlineStyleAttributeName:NSNumber.init(value: 2)]).attributedString()

let image = UIImage.init(named: "ic_icon_red")

let att = NSTextAttachment()
att.image = image
att.bounds = CGRect.init(origin: .zero, size: CGSize.init(width: 9, height: 9))
HLLAttributeBuilder().appendString("nihao").appendAttachment(att).appendString("Hello").attributedString()

let nihaoAtt : Dictionary = [NSUnderlineColorAttributeName:UIColor.red,
                             NSUnderlineStyleAttributeName:NSNumber.init(value: 1),
                             NSForegroundColorAttributeName:UIColor.orange]
let hAtt : Dictionary = [NSBackgroundColorAttributeName:UIColor.yellow]

let attB = HLLAttributeBuilder.init(with: "nihao = Hello = 你好")
    .configString("nihao", with: nihaoAtt)
    .configString("H", with: hAtt)
    .attributedString()

