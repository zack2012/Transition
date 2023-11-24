#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Test <NSObject>
- (void)foo;
@end

@protocol Context <NSObject>
- (void)bar:(id<Test>)context;
@end

@interface MyTest : NSObject<Context>
@end

NS_ASSUME_NONNULL_END
