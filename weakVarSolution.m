// weakVarSolution.m
#import <Foundation/Foundation.h>

@interface MyObject : NSObject
@property (nonatomic, strong) NSString *data;
@end

@implementation MyObject
- (instancetype)initWithData:(NSString *)data {
    self = [super init];
    if (self) {
        _data = data;
    }
    return self;
}
@end

void myAsynchronousOperation(void (^completion)(MyObject *)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ 
        MyObject *obj = [[MyObject alloc] initWithData:@"Hello"];
        dispatch_async(dispatch_get_main_queue(), ^{ 
            completion(obj); // Pass the object back to the main queue 
        });
    });
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        myAsynchronousOperation(^(MyObject *obj) {
            if (obj) { //Always check for nil before accessing
                NSLog(@"Data: %@
", obj.data); //Access obj's properties safely
            }
            else{
                NSLog(@"Object is unexpectedly nil!");
            }
        });
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}