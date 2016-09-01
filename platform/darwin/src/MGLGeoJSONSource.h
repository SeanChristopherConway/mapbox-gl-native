#import "MGLSource.h"

#import "MGLTypes.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MGLFeature;

/**
 The value of this option is an `NSNumber` object containing a boolean. If the data
 is a collection of point features, setting this to true clusters the points by 
 radius into groups. The default value is false.
 */
extern NSString * const MGLGeoJSONClusterOptionName;

/**
 The value of this option is an `NSNumber` object containing an integer. It controls
 the radius of each cluster when clustering points, measured in 1/512ths of a tile.
 The default value is 50.
 */
extern NSString * const MGLGeoJSONClusterRadiusOptionName;

/**
 The value of this option is an `NSNumber` object containing an integer. It controls 
 the maximum zoom to cluster points on. Defaults to one zoom less than the value 
 of `MGLGeoJSONMaxZoomLevelOptionName` (so that last zoom features are not clustered).
 */
extern NSString * const MGLGeoJSONClusterMaximumZoomLevelOptionName;

/**
 The value of this option is an `NSNumber` object containing an integer. It controls
 the maximum zoom level at which to create vector tiles (higher means greater detail 
 at high zoom levels). The default value is 18.
 */
extern NSString * const MGLGeoJSONMaxZoomLevelOptionName;

/**
 The value of this option is an `NSNumber` object containing an integer. It controls
 the tile buffer size on each side (measured in 1/512ths of a tile; higher means 
 fewer rendering artifacts near tile edges but slower performance).
 The default value is 128.
 */
extern NSString * const MGLGeoJSONBufferOptionName;

/**
 The value of this option is an `NSNumber` object containing a double. It controls
 the Douglas-Peucker simplification tolerance (higher means simpler geometries and 
 faster performance). The default value is 0.375.
 */
extern NSString * const MGLGeoJSONToleranceOptionName;

@interface MGLGeoJSONSource : MGLSource

/**
 The contents of the source.
 
 If the receiver was initialized using `-initWithSourceIdentifier:URL:`, this
 property is set to `nil`. This property is unavailable until the receiver is
 passed into `-[MGLStyle addSource]`.
 */
@property (nonatomic, readonly, nullable) NS_ARRAY_OF(id <MGLFeature>) *features;

/**
 A GeoJSON representation of the contents of the source.
 
 Use the `features` property instead to get an object representation of the
 contents. Alternatively, use NSJSONSerialization with the value of this
 property to transform it into Foundation types.
 
 If the receiver was initialized using `-initWithSourceIdentifier:URL:`, this
 property is set to `nil`. This property is unavailable until the receiver is
 passed into `-[MGLStyle addSource]`.
 */
@property (nonatomic, readonly, nullable, copy) NSData *geoJSONData;

/**
 The URL to the GeoJSON document that specifies the contents of the source.
 
 If the receiver was initialized using `-initWithSourceIdentifier:geoJSONData:`,
 this property is set to `nil`.
 */
@property (nonatomic, readonly, nullable) NSURL *URL;

/**
 Initializes a source with the given identifier and GeoJSON data.
 
 @param sourceIdentifier A string that uniquely identifies the source.
 @param geoJSONData An NSData object representing GeoJSON source code.
 */
- (instancetype)initWithSourceIdentifier:(NSString *)sourceIdentifier geoJSONData:(NSData *)data NS_DESIGNATED_INITIALIZER;

/**
 Initializes a source with the given identifier, GeoJSON data, and a dictionary of options for the source.
 
 @param sourceIdentifier A string that uniquely identifies the source.
 @param geoJSONData An NSData object representing GeoJSON source code.
 @param options An NSDictionary attributes for this source specified by the <a href="https://www.mapbox.com/mapbox-gl-style-spec/#sources-geojson">the style specification</a>.
 */
- (instancetype)initWithSourceIdentifier:(NSString *)sourceIdentifier geoJSONData:(NSData *)data options:(NS_DICTIONARY_OF(NSString *, id) *)options NS_DESIGNATED_INITIALIZER;

/**
 Initializes a source with the given identifier and URL.
 
 @param sourceIdentifier A string that uniquely identifies the source.
 @param URL An HTTP(S) URL, absolute file URL, or local file URL relative to the
    current application’s resource bundle.
 */
- (instancetype)initWithSourceIdentifier:(NSString *)sourceIdentifier URL:(NSURL *)url NS_DESIGNATED_INITIALIZER;

/**
 Initializes a source with the given identifier, a URL, and a dictionary of options for the source.
 
 @param sourceIdentifier A string that uniquely identifies the source.
 @param URL An HTTP(S) URL, absolute file URL, or local file URL relative to the
    current application’s resource bundle.
 @param options An NSDictionary attributes for this source specified by the <a href="https://www.mapbox.com/mapbox-gl-style-spec/#sources-geojson">the style specification</a>.
 */
- (instancetype)initWithSourceIdentifier:(NSString *)sourceIdentifier URL:(NSURL *)url options:(NS_DICTIONARY_OF(NSString *, id) *)options NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
