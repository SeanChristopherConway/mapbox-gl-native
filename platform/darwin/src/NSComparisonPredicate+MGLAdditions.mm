#import "NSComparisonPredicate+MGLAdditions.h"

#import "NSPredicate+MGLAdditions.h"
#import "NSExpression+MGLAdditions.h"

class FilterEvaluator {
public:

mbgl::style::Filter operator()(NSComparisonPredicate *predicate) {
    switch (predicate.predicateOperatorType) {
        case NSEqualToPredicateOperatorType: {
            auto filter = mbgl::style::EqualsFilter();
            filter.key = predicate.leftExpression.keyPath.UTF8String;
            filter.value = predicate.rightExpression.mgl_filterValue;
            return filter;
        }
        case NSNotEqualToPredicateOperatorType: {
            auto filter = mbgl::style::NotEqualsFilter();
            filter.key = predicate.leftExpression.keyPath.UTF8String;
            filter.value = predicate.rightExpression.mgl_filterValue;
            return filter;
        }
        case NSGreaterThanPredicateOperatorType: {
            auto filter = mbgl::style::GreaterThanFilter();
            filter.key = predicate.leftExpression.keyPath.UTF8String;
            filter.value = predicate.rightExpression.mgl_filterValue;
            return filter;
        }
        case NSGreaterThanOrEqualToPredicateOperatorType: {
            auto filter = mbgl::style::GreaterThanEqualsFilter();
            filter.key = predicate.leftExpression.keyPath.UTF8String;
            filter.value = predicate.rightExpression.mgl_filterValue;
            return filter;
        }
        case NSLessThanPredicateOperatorType: {
            auto filter = mbgl::style::LessThanFilter();
            filter.key = predicate.leftExpression.keyPath.UTF8String;
            filter.value = predicate.rightExpression.mgl_filterValue;
            return filter;
        }
        case NSLessThanOrEqualToPredicateOperatorType: {
            auto filter = mbgl::style::LessThanEqualsFilter();
            filter.key = predicate.leftExpression.keyPath.UTF8String;
            filter.value = predicate.rightExpression.mgl_filterValue;
            return filter;
        }
        case NSInPredicateOperatorType: {
            auto filter = mbgl::style::InFilter();
            filter.key = predicate.leftExpression.keyPath.UTF8String;
            filter.values = predicate.rightExpression.mgl_filterValues;
            return filter;
        }
        case NSMatchesPredicateOperatorType:
        case NSLikePredicateOperatorType:
        case NSBeginsWithPredicateOperatorType:
        case NSEndsWithPredicateOperatorType:
        case NSCustomSelectorPredicateOperatorType:
        case NSContainsPredicateOperatorType:
        case NSBetweenPredicateOperatorType:
            [NSException raise:@"Operator type not handled"
                        format:@""];
    }
    
    return {};
}
};

@implementation NSComparisonPredicate (MGLAdditions)

- (mbgl::style::Filter)mgl_filter
{
    FilterEvaluator evaluator;
    return evaluator(self);
}

@end
