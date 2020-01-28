//
//  Utility.m
//
//
//  Created by shahn on 2020/01/25.
//  Copyright © 2020 shahn. All rights reserved.
//

#import "Utility.h"

@implementation Utility

//MARK: Application
+ (NSString *)getVersion {
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    return version;
}

+ (NSString*)getBundleID {
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    return bundleIdentifier;
}

+ (BOOL)appInstallYn:(NSString *)scheme {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:scheme]]) {
        return YES;
    }
    
    return NO;
}

+ (void)goAppWithOptionAndHandler:(NSString *)scheme
                          Options:(NSDictionary *)options
                          Handler:(void ( ^ _Nullable)(BOOL))handler {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme] options:options completionHandler:handler];
}

//MARK: NUllCheck
+ (NSString *)nilToString:(NSString *)str {
    if( str == nil ||
       [str isKindOfClass:[NSNull class]] ||
       [str isEqualToString:@""] ||
       [str isEqualToString:@"nil"] ||
       [str isEqualToString:@"null"] ||
       [str isEqualToString:@"(null)"] ||
       [str isEqualToString:@"<null>"] ||
       [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
    {
        str = @"";
    }
    return str;
}

//MARK: Date
+ (NSString *)dateStringToStringWithFormat:(NSString *)strDate Foramt: (NSString *)format {
    NSDateFormatter *formatterDataBase = [[NSDateFormatter alloc] init] ;
    
    [formatterDataBase setDateFormat:@"yyyyMMddHHmmss"]; //this is the sqlite's format
    NSDate *date = [formatterDataBase dateFromString:strDate];
    
    NSDateFormatter *formatterWant = [[NSDateFormatter alloc] init] ;
    [formatterWant setDateFormat:format];
    
    return [formatterWant stringFromDate:date];
}

+ (NSDate *)dateStringToDateWithFormat:(NSString*)strDate Format: (NSString *)format {
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];

    [dateformat setDateFormat:format];
    
    NSDate *convertTime = [dateformat dateFromString:strDate];
    
    return convertTime;
}

//MARK: String
+ (NSString *)trimString:(NSString *)string {
    if(![[self nilToString:string] isEqualToString:@""]){
        NSCharacterSet* whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        string = [string stringByTrimmingCharactersInSet:whitespace];
    }
    
    return string;
}

+ (NSString *)subWordOfString:(NSString *)string Word:(NSString *)word {
    NSRange range = [string rangeOfString:word];

    if (range.location == NSNotFound) {
        ulog(@"Cannot SubWord");
        return @"";
    } else {
        @try {
            string = [string substringWithRange:NSMakeRange(range.location + range.length
                                                            ,string.length - range.location - range.length)];
            ulog(@"Subed Word -> %lu %lu %@", (unsigned long)range.location, (unsigned long)range.length, string);
        } @catch (NSException *exception) {
            ulog(@"Exception ::: %@", exception);
            return @"";
        } @finally {
            return string;
        }
    }
}

+ (NSString *)addCommaToNumber:(NSNumber *)number {
    
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formatted = [formatter stringFromNumber:number];
    
    return formatted;
}

+(BOOL)isNumeric:(NSString *)string {
    NSCharacterSet* notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound)
    {
        return YES;
    }
    return NO;
}

+(BOOL)isNumberSpecialCharacterInString:(NSString *)string {
    NSString *regex = @"[^0-9\{}\[]/?.,;:|)*~`!^-_+<>@#$%&\\=\(\'\"]";
    NSRange r = [string rangeOfString:regex options:NSRegularExpressionSearch];
    
    if(r.length == 0)
    {
        return NO;
    }
    return YES;
}

//MARK: UIAlert
+ (void)initAlert:(UIViewController*)parent
            title:(NSString *)title
          message:(NSString *)message
               ok:(NSString*)ok
           cancle:(NSString*)cancle
          handler:(void (^)( UIAlertAction *commonAction))handler {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  

    if ((ok != nil) && ![ok isEqualToString:@""]) {
        UIAlertAction* okAction = [UIAlertAction
                                  actionWithTitle:ok
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                    if(handler){handler(action);}
                                    [alertVC dismissViewControllerAnimated:YES completion:nil];
                                  }];
        [alertVC addAction:okAction];
    }
    
     if ((cancle != nil) && ![cancle isEqualToString:@""]) {
         UIAlertAction* cancleAction = [UIAlertAction
                                       actionWithTitle:cancle
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           if(handler){handler(action);}
                                           [alertVC dismissViewControllerAnimated:YES completion:nil];
                                       }];
         [alertVC addAction:cancleAction];
     }
    
    if (parent == nil ) {
        parent =  UIApplication.sharedApplication.keyWindow.rootViewController;
    }

    [parent presentViewController:alertVC animated:YES completion:nil];
}

//MARK: UIViewController
+ (UIViewController *)getStoryBoardWithController: (NSString *)strSBName strVCName:(NSString *)strVCName {
    if ([[Utility nilToString:strSBName] isEqualToString: @""]) {
        return nil;
    }
    if ([[Utility nilToString:strVCName] isEqualToString: @""]) {
        return nil;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:strSBName bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier: strVCName];
    return vc;
    
}

//MARK: UIColor
+(UIColor *)hexToUIColor:(int)hexColor{
    return [UIColor colorWithRed:((float)((hexColor & 0xFF0000) >> 16))/255.0
                           green:((float)((hexColor & 0xFF00) >> 8))/255.0
                            blue:((float)(hexColor & 0xFF))/255.0
                           alpha:1.0];
}

@end

