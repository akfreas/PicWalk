#import "PicWalkImageManager.h"
#import <MapKit/MapKit.h>

@implementation PicWalkImageManager

#define DefaultMeterSpan 100

-(NSURL *)urlForLocation:(CLLocation *)aLocation {
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(aLocation.coordinate, DefaultMeterSpan, DefaultMeterSpan);
    CGFloat minY = region.center.latitude - region.span.latitudeDelta/2;
    CGFloat minX = region.center.longitude - region.span.longitudeDelta/2;
    CGFloat maxY = region.center.latitude + region.span.latitudeDelta/2;
    CGFloat maxX = region.center.longitude + region.span.longitudeDelta/2;
    NSString *urlString = [NSString stringWithFormat:@"http://www.panoramio.com/map/get_panoramas.php?set=public&from=0&to=1&minx=%f&miny=%f&maxx=%f&maxy=%f&size=medium&mapfilter=true", MIN(minX, maxX), MIN(minY, maxY), MAX(minX, maxX), MAX(minY, maxY)];
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

-(void)imageForLocation:(CLLocation *)location completion:(void (^)(UIImage *image, NSString *imageID))completionBlock {
    
    [self getImageUrlForLocation:location completion:^(NSURL *imageURL, NSString *imageID) {
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:imageURL];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, UIImage *fetchedImage) {
            if (fetchedImage != nil) {
                completionBlock(fetchedImage, imageID);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
        [operation start];
    }];
}

-(void)getImageUrlForLocation:(CLLocation *)location completion:(void(^)(NSURL *url, NSString *imageID))completion {
    
    NSURL *url = [self urlForLocation:location];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        
        NSArray *photos = responseObject[@"photos"];
        NSDictionary *photoObject = [photos firstObject];
        NSString *photoURLString = photoObject[@"photo_file_url"];
        NSURL *url = [NSURL URLWithString:photoURLString];
        NSString *imageID = photoObject[@"photo_id"];
        completion(url, imageID);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    [operation start];
}

@end
