#import "NSPredicate+MGLAdditions.h"

@implementation NSPredicate (MGLAdditions)

- (mbgl::style::Filter)mgl_filter
{
    [NSException raise:@"A specific predicate must override this method." format:@""];
    return {};
}

+ (instancetype)mgl_predicateWithFilter:(mbgl::style::Filter)filter
{
    return nil;
}

@end
