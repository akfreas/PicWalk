#import "MainViewController.h"
#import "PicWalkImageManager.h"
#import "PicWalkLocationManager.h"
#import "PicWalkImageCell.h"
#import <BlocksKit/BlocksKit+UIKit.h>



@interface MainViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MainViewController {
    PicWalkImageManager *imageManager;
    PicWalkLocationManager *locationManager;
    UITableView *imageTableView;
    NSMutableArray *locationArray;
    NSMutableArray *imageArray;
    UIButton *startStopButton;
    NSMutableDictionary *imageIDDict;
}


static NSString *RowID = @"RowID";

- (id)init {
    self = [super init];
    if (self) {
        imageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [imageTableView registerClass:[PicWalkImageCell class] forCellReuseIdentifier:RowID];
        imageTableView.translatesAutoresizingMaskIntoConstraints = NO;
        imageTableView.delegate = self;
        imageTableView.dataSource = self;
        imageManager = [[PicWalkImageManager alloc] init];
        locationManager = [[PicWalkLocationManager alloc] init];
        locationArray = [NSMutableArray array];
        imageArray = [NSMutableArray array];
        imageIDDict = [NSMutableDictionary dictionary];
        self.view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return self;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)setupConstraints {
    
}

-(void)addTableView {
    [self.view addSubview:imageTableView];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(imageTableView,startStopButton);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageTableView]|" options:0 metrics:nil views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[startStopButton][imageTableView]|" options:0 metrics:nil views:bindings]];
}

-(void)addStartStopButton {
    startStopButton = [[UIButton alloc] initWithFrame:CGRectZero];
    startStopButton.translatesAutoresizingMaskIntoConstraints = NO;
    if (locationManager.isMonitoringForLocationUpdates == YES) {
        [startStopButton setTitle:@"Stop" forState:UIControlStateNormal];   
    } else {
        [startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    }
    startStopButton.backgroundColor = [UIColor blueColor];
    [startStopButton bk_addEventHandler:^(UIButton *sender) {
        [self configureButton];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startStopButton];
    NSDictionary *bindings = NSDictionaryOfVariableBindings(startStopButton);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[startStopButton]|" options:0 metrics:nil views:bindings]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[startStopButton(50)]" options:0 metrics:nil views:bindings]];
}

-(void)configureButton {
    
    if (locationManager.isMonitoringForLocationUpdates == NO) {
        [locationManager startMonitoringForLocationUpdates:[self locationChangedBlock]];
        [startStopButton setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [locationManager stopMonitoringForLocationUpdates];
        [startStopButton setTitle:@"Start" forState:UIControlStateNormal];
    }
}

-(void(^)(CLLocation *))locationChangedBlock {
    return ^(CLLocation *ourLocation) {
        [locationArray addObject:ourLocation];
        [imageManager imageForLocation:ourLocation completion:^(UIImage *locationImage, NSString *imageID) {
            if (imageIDDict[imageID] == nil) {
                imageIDDict[imageID] = [NSNumber numberWithBool:YES];
                [imageArray insertObject:locationImage atIndex:0];
                [imageTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }];
    };
}

#pragma mark Table View Delegate

#pragma mark Table View Datasource 

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PicWalkImageCell *cell = (PicWalkImageCell *)[tableView dequeueReusableCellWithIdentifier:RowID];
    cell.imageForCell = [imageArray objectAtIndex:indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    return [imageArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *imageAtIndex = imageArray[indexPath.row];
    return imageAtIndex.size.height;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark UIViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [locationManager stopMonitoringForLocationUpdates];
    [self addStartStopButton];
    [self addTableView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
