#import <Foundation/Foundation.h>

#include <mbgl/style/filter.hpp>

class ValueEvaluator {
public:
    std::string operator()(mbgl::Value value) {
#warning unimplemented
    if (value.is<std::string>()) {
        return value.get<std::string>();
    } else {
        return {};
    }
}
};
    
class FilterExpressionEvaluator {
public:
    id operator()(mbgl::Value value) {
#warning unimplemented
        auto string = value.get<std::string>();
        return @(string.c_str());
    }
};

@interface NSExpression (MGLAdditions)

- (mbgl::Value)mgl_filterValue;

- (std::vector<mbgl::Value>)mgl_filterValues;

@end
