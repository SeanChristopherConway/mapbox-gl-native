#import <Foundation/Foundation.h>

#import "MGLTypes.h"
#import "MGLStyleFilter.h"
#include <array>

#include <mbgl/style/filter.hpp>
#include <mbgl/style/filter_evaluator.hpp>

@interface MGLStyleFilter(Private)

+ (instancetype)filterWithMbglFilter:(mbgl::style::Filter)filter;

- (mbgl::style::Filter)mbgl_filter;

@end
