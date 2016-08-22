#import <Foundation/Foundation.h>

#include <mbgl/style/filter.hpp>

@interface NSPredicate (MGLAdditions)

- (mbgl::style::Filter)mgl_filter;

@end
