#import <Foundation/Foundation.h>

#include <mbgl/style/filter.hpp>

@interface NSComparisonPredicate (MGLAdditions)

- (mbgl::style::Filter)mgl_filter;

@end
