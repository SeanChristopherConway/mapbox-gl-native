#pragma once

#include <string>

namespace mbgl {
    namespace darwin {
        
        class Value  {
        public:
            
            Value(void *_obj);
            virtual ~Value();
            
            bool isNull() const;
            bool isArray() const;
            bool isObject() const;
            bool isString() const;
            bool isBool() const;
            bool isNumber() const;
            
            std::string toString() const;
            float toNumber() const;
            bool toBool() const;
            Value get(const char* key) const;
            int getLength() const;
            Value get(const int index ) const;
            
            void *value;
        };
        
    }
}