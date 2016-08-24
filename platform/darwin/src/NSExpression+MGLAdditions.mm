#import "NSExpression+MGLAdditions.h"

@implementation NSExpression (MGLAdditions)

- (std::vector<mbgl::Value>)mgl_filterValues
{
    if ([self.constantValue isKindOfClass:NSArray.class]) {
        NSArray *values = self.constantValue;
        std::vector<mbgl::Value>convertedValues;
        for (id value in values) {
            convertedValues.push_back([self convertedValueWithValue:value]);
        }
        return convertedValues;
    }
    [NSException raise:@"Values not handled" format:@""];
    return std::vector<mbgl::Value>();
}

- (mbgl::Value)mgl_filterValue
{
    return [self convertedValueWithValue:self.constantValue];
}

- (mbgl::Value)convertedValueWithValue:(id)value
{
    if ([value isKindOfClass:NSString.class]) {
        NSString *string = (NSString *)value;
        return std::string(string.UTF8String);
    } else if ([value isKindOfClass:NSNumber.class]) {
        NSNumber *number = (NSNumber *)value;
        if((strcmp([number objCType], @encode(int))) == 0) {
            return number.intValue;
        } else if ((strcmp([number objCType], @encode(float))) == 0) {
            return number.floatValue;
        } else {
            return number.boolValue;
        }
    }
    [NSException raise:@"Value not handled" format:@""];
    return std::string("");
}

@end
