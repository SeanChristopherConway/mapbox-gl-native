#import "NSCompoundPredicate+MGLAdditions.h"

#import "NSPredicate+MGLAdditions.h"
#import "NSExpression+MGLAdditions.h"

class PredicateEvaluator {
public:
    
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
        
        [NSException raise:@"Compound predicate type not handled"
                    format:@""];
        return {};
    }
    
};

@implementation NSCompoundPredicate (MGLAdditions)

- (mbgl::style::Filter)mgl_filter
{
    PredicateEvaluator evaluator;
    return evaluator(self);
}

@end
