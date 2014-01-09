@interface PicWalkLocationManager : NSObject

-(void)startMonitoringForLocationUpdates:(void(^)(CLLocation *newLocation))locationChangedBlock;
-(void)stopMonitoringForLocationUpdates;

@property (nonatomic, copy) void(^locationChangedBlock)(CLLocation *);
@property (nonatomic, assign) BOOL isMonitoringForLocationUpdates;
@end
