#import <Foundation/Foundation.h>

#include <mbgl/style/filter.hpp>

@interface NSCompoundPredicate (MGLAdditions)

- (mbgl::style::Filter)mgl_filter;

@end
