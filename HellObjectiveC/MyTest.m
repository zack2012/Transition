#import "MyTest.h"

@protocol ContextEx <Test>

- (void)hello;

@end

@implementation MyTest

- (void)foo { 
  
}

- (void)bar:(id<ContextEx>)context {
  [context hello];
}

@end
