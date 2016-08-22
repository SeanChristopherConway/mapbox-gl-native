#import "NSPredicate+MGLAdditions.h"

class FilterEvaluator {
public:
    
    mbgl::Value getValue(id obj) {
#warning Only NSNumber are supported for now
        NSNumber *number = (NSNumber *)obj;
        if((strcmp([number objCType], @encode(int))) == 0) {
            return mbgl::Value(number.intValue);
        } else if ((strcmp([number objCType], @encode(float))) == 0) {
            return mbgl::Value(number.floatValue);
        } else {
            return mbgl::Value(number.boolValue);
        }
    }
    
    mbgl::style::Filter operator()(NSComparisonPredicate *predicate) {
        const NSPredicateOperatorType operatorType = predicate.predicateOperatorType;
        switch (operatorType) {
            case NSEqualToPredicateOperatorType:
            {
                auto filter = mbgl::style::EqualsFilter();
                filter.key = predicate.leftExpression.keyPath.UTF8String;
                filter.value = getValue(predicate.rightExpression.constantValue);
                return filter;
            }
                
            default:
            {
                [NSException raise:@"Predicate operator type not handled" format:@""];
                break;
            }
        }
        return mbgl::style::NoneFilter();
    }
};

@implementation NSPredicate (MGLAdditions)

- (mbgl::style::Filter)mgl_filter
{
    if ([self isKindOfClass:NSCompoundPredicate.class]) {
        [NSException raise:@"Nested predicates (NSCompoundPredicate) are not yet implemented" format:@""];
    }
    
    NSComparisonPredicate *predicate = (NSComparisonPredicate *)self;
    FilterEvaluator evaluator;
    auto filter = evaluator(predicate);
    
    return filter;
}

@end
