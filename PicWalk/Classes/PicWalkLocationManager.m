#import "PicWalkLocationManager.h"

@interface PicWalkLocationManager () <CLLocationManagerDelegate>

@end

@implementation PicWalkLocationManager {
    
    CLLocationManager *manager;
    CLCircularRegion *currentlyMonitoredRegion;
    CLCircularRegion *hitTestedRegionForNewRegion;
}
#define DefaultRadius 100
-(id)init {
    self = [super init];
    if (self) {
        manager = [[CLLocationManager alloc] init];
        manager.delegate = self;
        
    }
    return self;
}

-(void)createAndMonitorRegionForCenterLocation:(CLLocation *)location {
    [manager stopMonitoringForRegion:currentlyMonitoredRegion];
    currentlyMonitoredRegion = nil;
    currentlyMonitoredRegion = [[CLCircularRegion alloc] initWithCenter:location.coordinate radius:DefaultRadius identifier:@"PicWalkLocationID"];
    [manager startMonitoringForRegion:currentlyMonitoredRegion];
}

-(void)startMonitoringForLocationUpdates:(void (^)(CLLocation *))aLocationChangedBlock {
    self.isMonitoringForLocationUpdates = YES;
    [manager startUpdatingLocation];
    self.locationChangedBlock = aLocationChangedBlock;
}

-(void)stopMonitoringForLocationUpdates {
    self.isMonitoringForLocationUpdates = NO;
    currentlyMonitoredRegion = nil;
    [manager stopUpdatingLocation];
}

#pragma mark CLLocationManager Delegate

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    NSLog(@"Err: %@", error);
}

-(void)locationManager:(CLLocationManager *)aManager didExitRegion:(CLRegion *)region {
    [self createAndMonitorRegionForCenterLocation:aManager.location];
    if (self.locationChangedBlock != NULL) {
        self.locationChangedBlock(aManager.location);
    }
}

-(void)locationManager:(CLLocationManager *)aManager didUpdateLocations:(NSArray *)locations {
    CLLocation *latestLocation = [locations lastObject];
    if ([currentlyMonitoredRegion containsCoordinate:latestLocation.coordinate]) {
        [self locationManager:aManager didExitRegion:currentlyMonitoredRegion];
    }
    if (currentlyMonitoredRegion == nil) {
        [self createAndMonitorRegionForCenterLocation:latestLocation];
    }
}

@end
