#import "NSPredicate+MGLAdditions.h"

class FilterEvaluator {
public:
    
    NSArray* getPredicates(std::vector<mbgl::style::Filter> filters) {
        NSMutableArray *predicates = [NSMutableArray arrayWithCapacity:filters.size()];
        for (auto nf : filters) {
            FilterEvaluator evaluator;
            [predicates addObject:mbgl::style::Filter::visit(nf, evaluator)];
        }
        return predicates;
    }
    
    NSArray* getValues(std::vector<mbgl::Value> v) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:v.size()];
        for (std::vector<mbgl::Value>::iterator it = v.begin(); it != v.end(); ++it) {
            [array addObject:getValue(*it)];
        }
        return array;
    }
    
    id getValue (mbgl::Value value) {
        if (value.is<std::string>())
            return @(value.get<std::string>().c_str());
        if (value.is<bool>())
            return @(value.get<bool>());
        if (value.is<int64_t>())
            return @(value.get<int64_t>());
        if (value.is<uint64_t>())
            return @(value.get<uint64_t>());
        if (value.is<double>())
            return @(value.get<double>());
        return nil;
    }
    
    NSPredicate* operator()(mbgl::style::NullFilter filter) {
        return nil;
    }
    
    NSPredicate* operator()(mbgl::style::EqualsFilter filter) {
        return [NSPredicate predicateWithFormat:@"%K == %@", @(filter.key.c_str()), getValue(filter.value)];
    }
    
    NSPredicate* operator()(mbgl::style::NotEqualsFilter filter) {
        return [NSPredicate predicateWithFormat:@"%K != %@", @(filter.key.c_str()), getValue(filter.value)];
    }
    
    NSPredicate* operator()(mbgl::style::GreaterThanFilter filter) {
        return [NSPredicate predicateWithFormat:@"%K > %@", @(filter.key.c_str()), getValue(filter.value)];
    }
    
    NSPredicate* operator()(mbgl::style::GreaterThanEqualsFilter filter) {
        return [NSPredicate predicateWithFormat:@"%K >= %@", @(filter.key.c_str()), getValue(filter.value)];
    }
    
    NSPredicate* operator()(mbgl::style::LessThanFilter filter) {
        return [NSPredicate predicateWithFormat:@"%K < %@", @(filter.key.c_str()), getValue(filter.value)];
    }
    
    NSPredicate* operator()(mbgl::style::LessThanEqualsFilter filter) {
        return [NSPredicate predicateWithFormat:@"%K <= %@", @(filter.key.c_str()), getValue(filter.value)];
    }
    
    NSPredicate* operator()(mbgl::style::InFilter filter) {
        return [NSPredicate predicateWithFormat:@"%K IN %@", @(filter.key.c_str()), getValues(filter.values)];
    }
    
    NSPredicate* operator()(mbgl::style::NotInFilter filter) {
        return [NSPredicate predicateWithFormat:@"NOT (%K IN %@)", @(filter.key.c_str()), getValues(filter.values)];
    }
    
    NSPredicate* operator()(mbgl::style::AnyFilter filter) {
        return [NSCompoundPredicate orPredicateWithSubpredicates:getPredicates(filter.filters)];
    }
    
    NSPredicate* operator()(mbgl::style::AllFilter filter) {
        return [NSCompoundPredicate andPredicateWithSubpredicates:getPredicates(filter.filters)];
    }
    
    NSPredicate* operator()(mbgl::style::NoneFilter filter) {
        return nil;
    }
    
    NSPredicate* operator()(mbgl::style::HasFilter filter) {
        return nil;
    }
    
    NSPredicate* operator()(mbgl::style::NotHasFilter filter) {
        return nil;
    }
    
};

@implementation NSPredicate (MGLAdditions)

- (mbgl::style::Filter)mgl_filter
{
    [NSException raise:@"Not supported"
                format:@"NSPredicate doesn't implement ’-mgl_filter’. Try with NSComparisonPredicate or NSCompoundPredicate instead."];
    return {};
}

+ (instancetype)mgl_predicateWithFilter:(mbgl::style::Filter)filter
{
    FilterEvaluator evaluator;
    return mbgl::style::Filter::visit(filter, evaluator);
}

@end
