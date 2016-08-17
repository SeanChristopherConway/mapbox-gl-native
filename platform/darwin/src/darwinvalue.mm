#include "darwinvalue.hpp"

#import <Foundation/Foundation.h>

namespace mbgl {
namespace darwin {
    
    Value::Value(void* _value) : value(_value) {}
    
    Value::~Value() {}
    
    bool Value::isNull() const {
        return value == nullptr;
    }
    
    bool Value::isArray() const {
        return false;
    }
    
    bool Value::isString() const {
        return false;
    }
    
    bool Value::isBool() const {
        return false;
    }
    
    bool Value::isNumber() const {
        return false;
    }
    
    std::string Value::toString() const {
        return "";
    }
    
    float Value::toNumber() const {
        return 0.0f;
    }
    
    bool Value::toBool() const {
        return true;
    }
    
    Value Value::get(const char* key) const {
        NSObject* bridged = CFBridgingRelease(value);
        NSObject* keyobject = [bridged valueForKeyPath:[NSString stringWithCString:key encoding:NSUTF8StringEncoding]];
        return Value((__bridge void *)keyobject);
    }
    
    int Value::getLength() const {
        NSArray* bridged = CFBridgingRelease(value);
        return (int)bridged.count;
    }
    
    Value Value::get(const int index) const {
        NSArray* bridged = CFBridgingRelease(value);
        return Value((__bridge void *)bridged[index]);
    }
}
}

