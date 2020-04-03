//
//  Utility.swift
//
//
//
//  Created by shahn on 2020/01/28.
//  Copyright © 2020 shahn. All rights reserved.
//  Last Version: 2020.04.03
//

import Foundation
import UIKit
import CommonCrypto


class Utilty: Any {
    /*
     싱글톤으로 사용할것
     */
    
    static let shared = Utilty()
    
    private init(){}
    
    
    //MARK: Log
    /**
     print() 함수가 DEBUG 플래그일 때만 로그 출력하도록 처리
     - Parameters:
        - filename: 파일이름
        - line: 라인번호
        - funcname: 함수 명
        - output: 출력할 내용
     */
    func print(filename: NSString = #file, line: Int = #line, funcname: String = #function, output: Any...) {
        #if DEBUG
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.sss"
        
        let outputs = output.map { "*** \($0) ***" }.joined(separator: " ")
        Swift.print("[\(dateFormatter.string(from: now))][\(filename.lastPathComponent)[\(funcname)][Line : \(line)] \(outputs)", terminator: "\n")
        #endif
    }
    
    //MARK: Application
    /**
    앱 버전 가져오기
     */
    var getVersion: String {
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }
    
    /**
    앱 Bundle ID 가져오기
     */
    var getBundleID: String {
        return Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
    }
    
    /**
    앱 스키마로 해당 앱 설치 여부 검사
     - Parameters:
        - scheme : 실행 할 앱의 URL Scheme
     - Returns:
     앱 설치 여부
     */
    func appInstallYn(scheme:String) -> Bool {
        if UIApplication.shared.canOpenURL(URL.init(string: scheme)!) {
            return true
        }
        return false
    }
    
    /**
     단말기의 푸시 허용 여부
     - Parameters:
        - handler: 실행 핸들러
        - granted: 푸시 허용 여부
     */
    func checkPushEnable(handler: @escaping (_ granted: Bool) -> Void) {
        if #available(iOS 10.0, *) {
            let current = UNUserNotificationCenter.current()
            current.getNotificationSettings(completionHandler: { (settings) in
                DispatchQueue.main.async {
                    if settings.authorizationStatus == .authorized {
                        handler(true)
                    } else {
                        handler(false)
                    }
                }
            })
        } else {
            let isRegisteredForRemoteNotifications = UIApplication.shared.isRegisteredForRemoteNotifications
            if isRegisteredForRemoteNotifications {
                handler(true)
            } else {
                handler(false)
            }
        }
    }
    
    //MARK: Collection
    /**
     Collection Merge (콜렉션 타입 합성)
     - Parameters:
        - left: Any
        - right: Any
     - Returns:
     Merged Collection
     */
    public func merge <KeyType, ValueType> ( _ left: [KeyType: ValueType], _ right: [KeyType: ValueType]) -> [KeyType: ValueType] {
        var out = left
        
        for (k, v) in right {
            out.updateValue(v, forKey: k)
        }
        
        return out
    }
    
    //MARK: UIViewController
    /**
     Storyboard에서 특정 ViewController를 반환
     - Parameters:
        - strSBName: Storyboard 이름
        - strControllerName: ViewController 이름
     - Returns:
     해당 ViewController. 없으면 nil
     */
    func getStoryboardWithController(strSBName: String, strControllerName: String) -> UIViewController? {
        let str: String? = strSBName
        if (strSBName == "" || str == nil) {
            return nil
        }
        
        let str2 : String? = strControllerName
        if (strControllerName == "" || str2 == nil) {
            return nil
        }
        
        let storyboard = UIStoryboard(name: strSBName, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: strControllerName)
        return vc
    }
    
}

//MARK: String
extension String {
    /**
     md5 해싱
     
    */
    @available(*, deprecated, message: "cryptographically broken and should not be used in security contexts. Clients should migrate to SHA256 (or stronger)")
    var md5: String {
        var digestData = Data(count: Int(CC_MD5_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes{ (digestPointer) -> Bool in
            self.data(using: .utf8)!.withUnsafeBytes { (pointer) -> Bool in
                _ = CC_MD5(pointer.baseAddress,
                           CC_LONG(pointer.count),
                           digestPointer.bindMemory(to: UInt8.self).baseAddress)
                return true
            }
        }
        
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    /**
     SHA256 해싱
     
    */
    var sha256: String {
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes{ (digestPointer) -> Bool in
            self.data(using: .utf8)!.withUnsafeBytes { (pointer) -> Bool in
                _ = CC_SHA256(pointer.baseAddress, CC_LONG(pointer.count), digestPointer.bindMemory(to: UInt8.self).baseAddress)
                return true
            }
        }
        
        return digestData.map { String(format: "%02hhx", $0) }.joined()
    }
    
    /**
     UTF8 Encoding
     
    */
    var encodeUTF8: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    /**
     UTF8 Decoding
     
    */
    var decodeUTF8: String {
        return self.removingPercentEncoding!
    }
    
    /**
     숫자에 콤마 추가하기
     - Parameters:
     - number: 콤마 추가할 숫자
     - Returns:
     콤마 추가된 문자열
     */
    func addCommaToNumber(number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        
        if let str = formatter.string(from: NSNumber(value: number)) {
            return str
        } else {
            return ""
        }
    }
    
    /**
     숫자로 된 문자열 판단
     - Parameters:
        - string: 판단할 문자열
     - Returns:
     숫자로만 이루어졌는지 여부
     */
    func isNumber(string: String) -> Bool {
        return !string.isEmpty && !(string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil)
    }
    
}

//MARK: UIColor
extension UIColor {
    /**
     RGB 값으로 UIColor 생성하여 반환
     - Parameters:
        - red: red 수치
        - green: green 수치
        - blue: blue 수치
     - Returns:
     변환된 UIColor 객체
     */
    func rgbToUIColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.rgbaToUIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    /**
     RGB 값으로 UIColor 생성하여 반환
     - Parameters:
         - red: red 수치
         - green: green 수치
         - blue: blue 수치
         - alpha: alpha 수치
     - Returns:
     변환된 UIColor 객체
     */
    func rgbaToUIColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
    /**
     색상 HEX 값으로 UIColor 생성하여 반환
     - Parameters:
        - hex: hex 코드
     - Returns:
     변환된 UIColor 객체
     */
    func hexToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /**
     DarkMode 컬러를 가진 UIColor 생성
     - Parameters:
        - color: 일반 모드 컬러
        - darkmode: 다크 모드 컬러
     - Returns:
     일반 모드 컬러, 다크모드 컬러를 가진 UIColor 객체
     */
    static func darkmodeColor(_ color: UIColor, darkmode: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor { (traits) -> UIColor in
                traits.userInterfaceStyle == .dark ? darkmode : color
            }
        } else {
            return color
        }
    }
}

//MARK: UIImage
extension UIImage {
    /**
     DarkMode 이미지를 가진 UIImage 생성
     - Parameters:
        - image: 일반 모드 이미지
        - darkmode: 다크 모드 이미지
     - Returns:
     일반 모드 이미지, 다크모드 이미지를 가진 UIImage 객체
     */
    static func darkableImage(_ image: UIImage, darkmode: UIImage) -> UIImage {
        if #available(iOS 13.0, *) {
            image.imageAsset?.register(darkmode, with: UITraitCollection(userInterfaceStyle: .dark))
            return image
        } else {
            return image
        }
    }
}

//MARK: UIDevice
extension UIDevice {
    /**
     기기 이름
     
    */
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS MAX"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad7,11", "iPad7,12":                    return "iPad 7 10.2 Inch"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro 11 Inch 3. Generation"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro 12.9 Inch 3. Generation"
        case "iPad11,1", "iPad11,2":                    return "iPad Mini 5"
        case "iPad11,3", "iPad11,4":                    return "iPad Air 3"
        case "Watch1,1": return "Apple Watch 38mm case"
        case "Watch1,2": return "Apple Watch 42mm case"
        case "Watch2,6": return "Apple Watch Series 1 38mm case"
        case "Watch2,7": return "Apple Watch Series 1 42mm case"
        case "Watch2,3": return "Apple Watch Series 2 38mm case"
        case "Watch2,4": return "Apple Watch Series 2 42mm case"
        case "Watch3,1", "Watch3,3": return "Apple Watch Series 3 38mm case"
        case "Watch3,2", "Watch3,4": return "Apple Watch Series 3 42mm case"
        case "Watch4,1", "Watch4,3": return "Apple Watch Series 4 40mm case"
        case "Watch4,2", "Watch4,4": return "Apple Watch Series 4 44mm case"
        case "Watch5,1", "Watch5,3": return "Apple Watch Series 5 40mm case"
        case "Watch5,2", "Watch5,4": return "Apple Watch Series 5 44mm case"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

//MARK: Date
extension Date {
    
    init(seconds:Int64!) {
        self = Date(timeIntervalSince1970: TimeInterval(Double.init(seconds)))
    }
    
    func toSeconds() -> Int64! {
        return Int64((self.timeIntervalSince1970).rounded())
    }
}

//MARK: CommomAlert
class CommonAlert {
    
    static var viewController: UIViewController? {
        if let navi = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            return navi.viewControllers.first
        }
        return nil
    }
    
    /**
     시스템 알럿 1버튼 타입
     - Parameters:
        - vc: 알럿이 표출될 vc
        - title: 알럿의 제목
        - message: 알럿의 내용
        - completeTitle: 확인 버튼의 타이틀
        - completeHandler: 확인 버튼 완료 핸들러
     */
    static func showAlertType1(vc:UIViewController? = viewController, title:String = "", message:String = "", completeTitle:String = "확인", _ completeHandler:(() -> Void)? = nil){
        if let viewController = vc {
            let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertController.Style.alert)
            let action1 = UIAlertAction(title:completeTitle, style: .default) { action in
                completeHandler?()
            }
            alert.addAction(action1)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    /**
    시스템 알럿 2버튼 타입
    - Parameters:
       - vc: 알럿이 표출될 vc
       - title: 알럿의 제목
       - message: 알럿의 내용
       - cancelTitle: 취소 버튼의 타이틀
       - completeTitle: 확인 버튼의 타이틀
       - cancelHandler: 취소 버튼 완료 핸들러
       - completeHandler: 확인 버튼 완료 핸들러
    */
    static func showAlertType2(vc:UIViewController? = viewController, title:String = "", message:String = "", cancelTitle:String = "취소", completeTitle:String = "확인",  _ cancelHandler:(() -> Void)? = nil, _ completeHandler:(() -> Void)? = nil){
        if let viewController = vc {
            let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertController.Style.alert)
            let action1 = UIAlertAction(title:cancelTitle, style: .cancel) { action in
                cancelHandler?()
            }
            let action2 = UIAlertAction(title:completeTitle, style: .default) { action in
                completeHandler?()
            }
            alert.addAction(action1)
            alert.addAction(action2)
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
