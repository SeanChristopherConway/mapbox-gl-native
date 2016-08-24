#import <Foundation/Foundation.h>

#import "NSExpression+MGLAdditions.h"
#include <mbgl/style/filter.hpp>

@interface NSPredicate (MGLAdditions)

- (mbgl::style::Filter)mgl_filter;

@end

namespace mbgl {
namespace darwin {

class FilterEvaluator {
public:

mbgl::style::Filter operator()(NSComparisonPredicate *predicate) {
    switch (predicate.predicateOperatorType) {
        case NSMatchesPredicateOperatorType:
        case NSLikePredicateOperatorType:
        case NSBeginsWithPredicateOperatorType:
        case NSEndsWithPredicateOperatorType:
        case NSCustomSelectorPredicateOperatorType:
        case NSContainsPredicateOperatorType:
        case NSBetweenPredicateOperatorType:
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
    }
    
    [NSException raise:@"Predicate operator type not handled" format:@""];
    return mbgl::style::NoneFilter();
}
    
std::vector<mbgl::style::Filter>getFilters (NSArray<NSPredicate *> *predicates) {
    std::vector<mbgl::style::Filter>filters;
    for (NSPredicate *predicate in predicates) {
        filters.push_back(predicate.mgl_filter);
    }
    return filters;
}
    
mbgl::style::Filter operator()(NSCompoundPredicate *predicate) {
    switch (predicate.compoundPredicateType) {
        case NSNotPredicateType: {
            auto filter = mbgl::style::NoneFilter();
            filter.filters = getFilters(predicate.subpredicates);
            return filter;
        }
        case NSAndPredicateType: {
            auto filter = mbgl::style::AllFilter();
            filter.filters = getFilters(predicate.subpredicates);
            return filter;
        }
        case NSOrPredicateType: {
            auto filter = mbgl::style::AnyFilter();
            filter.filters = getFilters(predicate.subpredicates);
            return filter;
        }
    }
    
    [NSException raise:@"Nested predicates (NSCompoundPredicate) are not yet supported" format:@""];
    return mbgl::style::NoneFilter();
}};

} // darwin
} // mbgl

