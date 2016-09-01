#import "MGLGeoJSONSource.h"

#import "MGLSource_Private.h"
#import "MGLFeature_Private.h"

#import "NSURL+MGLAdditions.h"

#include <mbgl/style/sources/geojson_source.hpp>

NSString * const MGLGeoJSONClusterOptionName = @"MGLGeoJSONClusterOptionName";
NSString * const MGLGeoJSONClusterRadiusOptionName = @"MGLGeoJSONClusterRadiusOptionName";
NSString * const MGLGeoJSONClusterMaximumZoomLevelOptionName = @"MGLGeoJSONClusterMaximumZoomLevelOptionName";
NSString * const MGLGeoJSONMaxZoomLevelOptionName = @"MGLGeoJSONMaxZoomLevelOptionName";
NSString * const MGLGeoJSONBufferOptionName = @"MGLGeoJSONBufferOptionName";
NSString * const MGLGeoJSONToleranceOptionName = @"MGLGeoJSONOptionsClusterTolerance";

@interface MGLGeoJSONSource ()

@property (nonatomic, readwrite) NSDictionary *options;

@end

@implementation MGLGeoJSONSource

- (instancetype)initWithSourceIdentifier:(NSString *)sourceIdentifier geoJSONData:(NSData *)data
{
    if (self = [super initWithSourceIdentifier:sourceIdentifier])
    {
        _geoJSONData = data;
    }
    return self;
}

- (instancetype)initWithSourceIdentifier:(NSString *)sourceIdentifier geoJSONData:(NSData *)data options:(NS_DICTIONARY_OF(NSString *, id) *)options
{
    if (self = [super initWithSourceIdentifier:sourceIdentifier])
    {
        _geoJSONData = data;
        _options = options;
    }
    return self;
}

- (instancetype)initWithSourceIdentifier:(NSString *)sourceIdentifier URL:(NSURL *)url
{
    if (self = [super initWithSourceIdentifier:sourceIdentifier])
    {
        _URL = url;
    }
    return self;
}

- (instancetype)initWithSourceIdentifier:(NSString *)sourceIdentifier URL:(NSURL *)url options:(NS_DICTIONARY_OF(NSString *, id) *)options
{
    if (self = [super initWithSourceIdentifier:sourceIdentifier])
    {
        _URL = url;
        _options = options;
    }
    return self;
}

- (mbgl::style::GeoJSONOptions)mbgl_geoJSONOptions
{
    auto options = mbgl::style::GeoJSONOptions();
    
    setOptionForKeyWithValue(MGLGeoJSONMaxZoomLevelOptionName, &options.maxzoom, self.options);
    setOptionForKeyWithValue(MGLGeoJSONBufferOptionName, &options.buffer, self.options);
    setOptionForKeyWithValue(MGLGeoJSONToleranceOptionName, &options.tolerance, self.options);
    setOptionForKeyWithValue(MGLGeoJSONClusterRadiusOptionName, &options.clusterRadius, self.options);
    setOptionForKeyWithValue(MGLGeoJSONClusterMaximumZoomLevelOptionName, &options.clusterMaxZoom, self.options);
    
    if ([self.options objectForKey:MGLGeoJSONClusterOptionName])
    {
        BOOL isKindOfNumber = [[self.options objectForKey:MGLGeoJSONClusterOptionName] isKindOfClass:[NSNumber class]];
        if (isKindOfNumber)
        {
            BOOL representsBoolean = strcmp([(NSNumber *)[self.options objectForKey:MGLGeoJSONClusterOptionName] objCType], @encode(char)) == 0;
            if (representsBoolean)
            {
                options.cluster = [self.options[MGLGeoJSONClusterOptionName] boolValue];
            }
        }
    }
    
    return options;
}

template<typename T>
void setOptionForKeyWithValue(NSString *key, T *value, NSDictionary *options)
{
    if (! [options objectForKey:key]) return;
   
    id keyValue = [options objectForKey:key];
    BOOL isKindOfNumber = [keyValue isKindOfClass:[NSNumber class]];
    
    // if we are dealing with an NSNumber then determine the selector to extract
    // its value based on its type and then call that selector, assigning the value
    // to the passed in mbgl options value
    if (isKindOfNumber)
    {
        SEL sel;
        if (strcmp([keyValue objCType], @encode(int)) == 0) {
            sel = @selector(integerValue);
        } else {
            sel = @selector(doubleValue);
        }
        IMP imp = [options[key] methodForSelector:sel];
        T (*func)(id, SEL) = (T (*)(id, SEL))imp;
        *value = func(options[key], sel);
    }
}

- (std::unique_ptr<mbgl::style::Source>)mbgl_source
{
    auto source = std::make_unique<mbgl::style::GeoJSONSource>(self.sourceIdentifier.UTF8String, [self mbgl_geoJSONOptions]);
    
    if (self.URL) {
        NSURL *url = self.URL.mgl_URLByStandardizingScheme;
        source->setURL(url.absoluteString.UTF8String);
    } else {
        NSString *string = [[NSString alloc] initWithData:self.geoJSONData encoding:NSUTF8StringEncoding];
        const auto geojson = mapbox::geojson::parse(string.UTF8String).get<mapbox::geojson::feature_collection>();
        source->setGeoJSON(geojson);
        _features = MGLFeaturesFromMBGLFeatures(geojson);
    }
    
    return std::move(source);
}

@end
