#import "MGLStyleLayerTests.h"

@interface MGLFilterTests : MGLStyleLayerTests {
    MGLGeoJSONSource *source;
    MGLLineStyleLayer *layer;
}
@end

@implementation MGLFilterTests

- (void)setUp
{
    [super setUp];
    NSString *filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"amsterdam" ofType:@"geojson"];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSData *geoJSONData = [NSData dataWithContentsOfURL:url];
    source = [[MGLGeoJSONSource alloc] initWithSourceIdentifier:@"test-source" geoJSONData:geoJSONData];
    [self.mapView.style addSource:source];
    layer = [[MGLLineStyleLayer alloc] initWithLayerIdentifier:@"test-layer" sourceIdentifier:@"test-source"];
}

- (void)tearDown
{
    [self.mapView.style removeLayer:layer];
    [self.mapView.style removeSource:source];
}

- (NSArray<NSPredicate *> *)predicates
{
    NSPredicate *equalPredicate = [NSPredicate predicateWithFormat:@"type == 'neighborhood'"];
    NSPredicate *notEqualPredicate = [NSPredicate predicateWithFormat:@"type != 'park'"];
    NSPredicate *greaterThanPredicate = [NSPredicate predicateWithFormat:@"%K > %@", @"stroke-width", @1];
    NSPredicate *greaterThanOrEqualToPredicate = [NSPredicate predicateWithFormat:@"%K >= %@", @"stroke-width", @1];
    NSPredicate *lessThanOrEqualToPredicate = [NSPredicate predicateWithFormat:@"%K <= %@", @"stroke-width", @1];
    NSPredicate *lessThanPredicate = [NSPredicate predicateWithFormat:@"%K < %@", @"stroke-width", @1];
    NSPredicate *inPredicate = [NSPredicate predicateWithFormat:@"type IN %@", @[@"park", @"neighborhood"]];
    NSPredicate *notInPredicate = [NSPredicate predicateWithFormat:@"NOT (type IN %@)", @[@"park", @"neighborhood"]];
    NSPredicate *inNotInPredicate = [NSPredicate predicateWithFormat:@"type IN %@ AND NOT (type IN %@)", @[@"park"], @[@"neighborhood"]];
    return @[equalPredicate, notEqualPredicate, greaterThanPredicate, greaterThanOrEqualToPredicate, lessThanOrEqualToPredicate, lessThanPredicate, inPredicate, notInPredicate, inNotInPredicate];
}

- (void)testPredicateGetter
{
    NSPredicate *predicate = self.predicates[0];
    layer.predicate = predicate;
    
    NSPredicate *getPredicate = layer.predicate;
    
    XCTAssertEqualObjects(predicate, getPredicate);
}

- (void)testPredicates
{
    for (NSPredicate *predicate in self.predicates) {
        layer.predicate = predicate;
    }
    [self.mapView.style addLayer:layer];
}

- (void)testAndPredicates
{
    layer.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:self.predicates];
    [self.mapView.style addLayer:layer];
}

- (void)testOrPredicates
{
    layer.predicate = [NSCompoundPredicate orPredicateWithSubpredicates:self.predicates];
    [self.mapView.style addLayer:layer];
}

- (void)testNotPredicates
{
    NSCompoundPredicate *notPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:self.predicates];
    layer.predicate = [NSCompoundPredicate notPredicateWithSubpredicate:notPredicate];
    [self.mapView.style addLayer:layer];
}

@end
