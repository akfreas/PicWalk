@interface PicWalkImageManager : NSObject

-(void)imageForLocation:(CLLocation *)location completion:(void (^)(UIImage *image, NSString *imageID))completionBlock;

@end
