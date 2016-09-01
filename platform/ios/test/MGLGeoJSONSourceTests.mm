#import <Mapbox/Mapbox.h>
#import <XCTest/XCTest.h>

#include <mbgl/style/sources/geojson_source.hpp>

@interface MGLGeoJSONSource (Test)
    - (mbgl::style::GeoJSONOptions)mbgl_geoJSONOptions;
@end

@interface MGLGeoJSONSourceTests : XCTestCase

@end

@implementation MGLGeoJSONSourceTests

- (void)testMGLGeoJSONSourceWithOptions {
    NSURL *url = [NSURL URLWithString:@"http://www.mapbox.com/source"];
    
    NSDictionary *options = @{MGLGeoJSONClusterOptionName: @(YES),
                              MGLGeoJSONClusterRadiusOptionName: @42,
                              MGLGeoJSONClusterMaximumZoomLevelOptionName: @98,
                              MGLGeoJSONMaxZoomLevelOptionName: @99,
                              MGLGeoJSONBufferOptionName: @1976,
                              MGLGeoJSONToleranceOptionName: @0.42};
    MGLGeoJSONSource *source = [[MGLGeoJSONSource alloc] initWithSourceIdentifier:@"source-id" URL:url options:options];
    
    auto mbglOptions = [source mbgl_geoJSONOptions];
    XCTAssertTrue(mbglOptions.cluster);
    XCTAssertEqual(mbglOptions.clusterRadius, 42);
    XCTAssertEqual(mbglOptions.clusterMaxZoom, 98);
    XCTAssertEqual(mbglOptions.maxzoom, 99);
    XCTAssertEqual(mbglOptions.buffer, 1976);
    XCTAssertEqual(mbglOptions.tolerance, 0.42);
  
    // when the supplied option cluster value is not of the correct type
    options = @{MGLGeoJSONClusterOptionName: @"number 1"};
    source = [[MGLGeoJSONSource alloc] initWithSourceIdentifier:@"source-id" URL:url options:options];
    mbglOptions = [source mbgl_geoJSONOptions];
    XCTAssertFalse(mbglOptions.cluster);
    
    // when the supplied option cluster value is not of the correct value
    options = @{MGLGeoJSONClusterOptionName: @-2};
    source = [[MGLGeoJSONSource alloc] initWithSourceIdentifier:@"source-id" URL:url options:options];
    mbglOptions = [source mbgl_geoJSONOptions];
    XCTAssertFalse(mbglOptions.cluster);
    
    // when the supplied option for other values are not of the correct type
    options = @{MGLGeoJSONMaxZoomLevelOptionName: @"zoom in"};
    source = [[MGLGeoJSONSource alloc] initWithSourceIdentifier:@"source-id" URL:url options:options];
    mbglOptions = [source mbgl_geoJSONOptions];
    // maxzoom is the default value
    XCTAssertEqual(mbglOptions.maxzoom, 18);
    
    options = @{MGLGeoJSONBufferOptionName: @"a buffer"};
    source = [[MGLGeoJSONSource alloc] initWithSourceIdentifier:@"source-id" URL:url options:options];
    mbglOptions = [source mbgl_geoJSONOptions];
    // buffer is the default value
    XCTAssertEqual(mbglOptions.buffer, 128);
    
    options = @{MGLGeoJSONToleranceOptionName: @"tolerate"};
    source = [[MGLGeoJSONSource alloc] initWithSourceIdentifier:@"source-id" URL:url options:options];
    mbglOptions = [source mbgl_geoJSONOptions];
    // buffer is the default value
    XCTAssertEqual(mbglOptions.tolerance, 0.375);
    
    options = @{MGLGeoJSONClusterRadiusOptionName: @"cluster rad"};
    source = [[MGLGeoJSONSource alloc] initWithSourceIdentifier:@"source-id" URL:url options:options];
    mbglOptions = [source mbgl_geoJSONOptions];
    // buffer is the default value
    XCTAssertEqual(mbglOptions.clusterRadius, 50);
    
    options = @{MGLGeoJSONClusterMaximumZoomLevelOptionName: @"cluster mz"};
    source = [[MGLGeoJSONSource alloc] initWithSourceIdentifier:@"source-id" URL:url options:options];
    mbglOptions = [source mbgl_geoJSONOptions];
    // buffer is the default value
    XCTAssertEqual(mbglOptions.clusterMaxZoom, 17);
}

@end
