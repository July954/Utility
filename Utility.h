//
//  Utility.h
//  
//
//  Created by shahn on 2020/01/25.
//  Copyright © 2020 shahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//MARK: Log
/**
    #Custom Log
 */
#ifdef DEBUG
#define ulog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define ulog(...) ((void)0)

#endif


@interface Utility : NSObject

//MARK: Application
/**
    앱 버전 가져오기
    - Parameters:
    - Returns:
        - NSString *
*/
+ (NSString * _Nonnull)getVersion;

/**
    앱 Bundle ID 가져오기
    - Parameters:
    - Returns:
        - NSString *
*/
+ (NSString * _Nonnull)getBundleID;

/**
    앱 스키마로 해당 앱 설치 여부 검사
    - Parameters:
        - NSString *scheme : 실행 할 앱의 URL Scheme
    - Returns:
        - BOOL *
*/
+ (BOOL)appInstallYn:(NSString * _Nonnull)scheme;

/**
    앱 스키마로 해당 앱 실행
    # Handler 주의사항
    핸들러의 Bool = 앱 실행 성공 여부 재정의해서 사용할 것 (ex : (BOOL success){ })
    - Parameters:
        - NSString *scheme      : 실행 할 앱의 URL Scheme
        - NSDictionary *options : 실행 옵션 Dict
        - (void) handler        : 실행 후 액션 핸들러
    - Returns:
        - NSString *
*/
+ (void)goAppWithOptionAndHandler:(NSString * _Nonnull)scheme
                          Options:(NSDictionary * _Nonnull)options
                          Handler:(void ( ^ _Nullable)(BOOL))handler;

//MARK: NUllCheck
/**
    nil 값을 NSString 으로 안전하게 변환
    # 데이터가 없을 경우 0 반환
    - Parameters: NSString
    - Returns: NSString
*/
+ (NSString * _Nonnull)nilToString:(NSString * _Nonnull)str;

/**
    DataBase기준 Date String -> Formatted String 변환
    # String -> Date  20120304112233 -> 12.03.04
    - Parameters:
        - NSString *strDate         : Date String
        - NSString *format          : To Make Date Format (ex : yy.mm.dd)
    - Returns:
        - NSString *
*/
+ (NSString * _Nonnull)dateStringToStringWithFormat:(NSString * _Nonnull)strDate
                                             Foramt:(NSString * _Nonnull)format;

//MARK: Date
/**
    NSString -> Formatted Date 변환
    # Format 주의 사항
    AM,PM으로 할 경우 hh, 24시간으로 할 경우 HH
    - Parameters:
        - NSString *strDate         : Date String
        - NSString *format          : To Make Date Format (ex : yy.mm.dd)
    - Returns:
        - NSDate *
*/
+ (NSDate * _Nonnull)dateStringToDateWithFormat:(NSString * _Nonnull)strDate
                                         Format:(NSString * _Nonnull)format;

//MARK: String
/**
    String Trim 문자열 공백 제거
    - Parameters:
        - NSString *string      : 공백 제거 할 문자열
    - Returns:
        - NSString *
*/
+ (NSString * _Nonnull)trimString:(NSString * _Nonnull)string;

/**
    Sub Word 문자열에서 단어 추출
    - Parameters:
        - NSString *string      : 전체 문자열
        - NSString *word        : 추출할 단어
    - Returns:
        - NSString *
*/
+ (NSString * _Nonnull)subWordOfString:(NSString * _Nonnull)string Word:(NSString * _Nonnull)word;

/**
    숫자에 콤마 추가 /20000 - > 20,000
    - Parameters:
        - NSNumber *number      : Comma 추가할 숫자
    - Returns:
        - NSString *
*/
+ (NSString * _Nonnull)addCommaToNumber:(NSNumber * _Nonnull)number;

/**
    문자열이 숫자로된 문자열인지 판단
    - Parameters:
        - NSString *string      : 판단할 문자열
    - Returns:
        - BOOL *
*/
+(BOOL)isNumeric:(NSString * _Nonnull)string;

/**
    문자열에 숫자나 특수문자 포함인지 판단
    - Parameters:
        - NSString *string      : 판단할 문자열
    - Returns:
        - BOOL *
*/
+(BOOL)isNumberSpecialCharacterInString:(NSString * _Nonnull)string;

//MARK: UIAlert
/**
    공통 시스템 알럿
    #사용 예시
    1) 확인이 단순 팝업이면
        [UIAlertController initAlert:self
                            title:nil
                          message:@"잠시 후 다시 시도해 주시기 바랍니다."
                               ok:@"확인"
                      cancle:nil handler:nil];
    2) 확인이나 취소가 액션이 있을때
        [UIAlertController initAlert:self
                               title:nil
                             message:@"실행하시겠습니까?"
                                  ok:@"확인"
                              cancle:@"취소"
                             handler:^(UIAlertAction * _Nullable commonAction) {
             if ([commonAction.title isEqualToString:STR_OK]) {
                   .. custom coding
             }
        }];
    - Parameters:
        - UIViewController *parent          : 알럿이 노출될 VC
        - NSString *title                   : 알럿 타이틀
        - NSString *message                 : 알럿 내용
        - NSString *ok                      : 'Ok' 버튼 타이틀
        - NSString *cancle                  : 'Cancel' 버튼 타이틀
        - void *handler                     : UIAlertAction
    - Returns:
        - BOOL *
*/
+ (void)initAlert:(nullable UIViewController*)parent
            title:(nullable NSString *)title
          message:(nullable NSString *)message
               ok:(nullable NSString*)ok
           cancle:(nullable NSString*)cancle
          handler:(void (^ __nullable)( UIAlertAction * _Nullable commonAction))handler;

@end
