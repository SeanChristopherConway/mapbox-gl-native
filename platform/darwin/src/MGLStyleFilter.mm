#import "MGLStyleFilter.h"

#include <mbgl/style/filter.hpp>
#include <mbgl/style/filter_evaluator.hpp>

#include "darwin_conversion.hpp"

#include <mbgl/style/conversion.hpp>
#include <mbgl/style/conversion/filter.hpp>
#include <mbgl/style/filter.hpp>
#include <mbgl/style/filter_evaluator.hpp>

@interface MGLStyleFilter()
@property (nonatomic) NSPredicate *predicate;
@property (nonatomic) BOOL gt;
@end

@implementation MGLStyleFilter

+ (instancetype)filterWithPredicate:(NSPredicate *)predicate
{
    MGLStyleFilter *filter = [[MGLStyleFilter alloc] init];
    filter.predicate = predicate;
    
    //using namespace mbgl::style;
    //using namespace mbgl::darwin;
    //using namespace mbgl::style::conversion;
    
    //Filter f;
    //auto wrapped = Value((__bridge void *)filter);
    //Result<Filter> converted = convert<Filter>(wrapped);
    //f = std::move(*converted);
    //self.layer->as<mbgl::style::FillLayer>()->setFilter(f);
    
    return filter;
}

/*
- (mbgl::style::Filter)mbgl_filter
{
    using namespace mbgl;
    using namespace mbgl::style;
    using namespace mbgl::style::conversion;
    
    const NSObject *obj = nil;
    conversion::Result<Filter> result = conversion::convert<Filter>(&obj);
    return mbgl::style::Filter{};
}*/

+ (instancetype)filterWithMbglFilter:(mbgl::style::Filter)filter
{
    
    return nil;
}

@end
