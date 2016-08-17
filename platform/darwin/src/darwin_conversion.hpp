#pragma once

#import <Foundation/Foundation.h>

#include <mbgl/style/conversion.hpp>
#include <mbgl/util/feature.hpp>
#include <mbgl/util/optional.hpp>

#import "darwinvalue.hpp"

namespace mbgl {
namespace style {
namespace conversion {

inline bool isUndefined(const mbgl::darwin::Value& val) {
    if (!val.value) {
        return true;
    }
    return false;
}
    
inline bool isArray(const mbgl::darwin::Value& val) {
    NSObject* o = CFBridgingRelease(val.value);
    return ([o isKindOfClass:NSArray.class]);
}
    
inline std::size_t arrayLength(const mbgl::darwin::Value& val) {
    NSArray* o = CFBridgingRelease(val.value);
    return [o count];
}

inline const mbgl::darwin::Value& arrayMember(const mbgl::darwin::Value& val, std::size_t i) {
    return val;
}
    
inline bool isObject(const mbgl::darwin::Value& obj) {
    return false;
}

inline optional<mbgl::darwin::Value> objectMember(const mbgl::darwin::Value& value, const char* key) {
    return {};
}
    
template <class Fn>
optional<Error> eachMember(const mbgl::darwin::Value& value, Fn&& fn) {
    return {};
}
    
inline optional<bool> toBool(const mbgl::darwin::Value& value) {
    return {};
}
    
inline optional<float> toNumber(const mbgl::darwin::Value& value) {
    return {};
}
    
inline optional<std::string> toString(const mbgl::darwin::Value& value) {
    return {};
}
    
inline optional<mbgl::darwin::Value> toValue(const mbgl::darwin::Value& value) {
    return {};
}
    
} // conversion
} // style
} // mbgl
