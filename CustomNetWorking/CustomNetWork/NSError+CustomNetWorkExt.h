//
//  NSError+CustomNetWorkExt.h
//  CustomNetWorking
//
//  Created by 李雪阳 on 2020/6/27.
//  Copyright © 2020 XueYangLee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (CustomNetWorkExt)

/** 错误码 */
@property (nonatomic,copy) NSNumber *statusCode;
/** 错误信息 */
@property (nonatomic,copy) NSString *errorMessage;

@end

NS_ASSUME_NONNULL_END
