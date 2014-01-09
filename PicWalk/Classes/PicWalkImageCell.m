#import "PicWalkImageCell.h"

@implementation PicWalkImageCell {
    UIImageView *imageView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

-(void)setImageForCell:(UIImage *)imageForCell {
    if (imageView == nil) {
        imageView = [[UIImageView alloc] initWithImage:imageForCell];
        [self.contentView addSubview:imageView];
        [self addImageLayoutConstraints];
    } else {
        imageView.image = imageForCell;
    }
}

-(void)addImageLayoutConstraints {

    NSDictionary *bindings = NSDictionaryOfVariableBindings(imageView);
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]" options:0 metrics:nil views:bindings]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView]" options:0 metrics:nil views:bindings]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
