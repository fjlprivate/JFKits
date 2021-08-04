//
//  TestScaleImageVC.m
//  JFKitDemo
//
//  Created by 冯金龙(EX-FENGJINLONG001) on 2021/6/23.
//  Copyright © 2021 JohnnyFeng. All rights reserved.
//

#import "TestScaleImageVC.h"
#import <TZImagePickerController.h>


@interface TestScaleImageVC () <TZImagePickerControllerDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation TestScaleImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.imageView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(200);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.centerY.mas_equalTo(0);
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(clickedSelect:)];
    
}

- (IBAction) clickedSelect:(id)sender {
    TZImagePickerController* picker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    [self presentViewController:picker animated:YES completion:nil];
}

# pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    NSLog(@"+++++++++++scrollViewWillBeginZooming.imageView.center[%@], contentSize[%@]", NSStringFromCGPoint(self.imageView.center), NSStringFromCGSize(scrollView.contentSize));
//    scrollView.contentInset = UIEdgeInsetsZero;
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                        scrollView.contentSize.height * 0.5 + offsetY);
    NSLog(@"+++++++++++scrollViewDidZoom.imageView.center[%@], contentSize[%@]", NSStringFromCGPoint(self.imageView.center), NSStringFromCGSize(scrollView.contentSize));

}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    NSLog(@"+++++++++++scrollViewDidEndZooming.imageView.center[%@], contentSize[%@]", NSStringFromCGPoint(self.imageView.center), NSStringFromCGSize(scrollView.contentSize));
    CGFloat insetV = 0;
    CGFloat insetH = 0;
    if (scrollView.contentSize.width < scrollView.bounds.size.width) {
        insetH = (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5;
    }
    else if (scrollView.contentSize.height < scrollView.bounds.size.height) {
        insetV = (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5;
    }
    scrollView.contentInset = UIEdgeInsetsMake(insetV, insetH, insetV, insetH);
}


# pragma mark - TZImagePickerControllerDelegate
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    self.imageView.image = photos.firstObject;
    
    CGFloat minScale = 1;
    CGSize imageSize =  self.imageView.image.size;
    CGFloat boundsWidth = self.scrollView.bounds.size.width;
    CGFloat boundsHeight = self.scrollView.bounds.size.height;
    CGFloat insetV = 0;
    CGFloat insetH = 0;

    if (imageSize.width > imageSize.height) {
        minScale = boundsWidth / imageSize.width;
        insetV = (boundsHeight - imageSize.height * minScale) * 0.5;
    }
    else {
        minScale = self.scrollView.bounds.size.height / imageSize.height;
        insetH = (boundsWidth - imageSize.width * minScale) * 0.5;
    }
    NSLog(@"+++++++++++imagePickerController.minScale[%lf], scrollview.bounds[%@]", minScale, NSStringFromCGRect(self.scrollView.bounds));
    self.scrollView.minimumZoomScale = minScale;
    [self.scrollView setZoomScale:minScale animated:NO];
    
    self.scrollView.contentInset = UIEdgeInsetsMake(insetV, insetH, insetV, insetH);

}

# pragma mark - getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = JFRGBAColor(0, 0.1);
        _scrollView.maximumZoomScale = 5;
    }
    return _scrollView;
}
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = JFRGBAColor(0x00ff00, 0.1);
    }
    return _imageView;
}
@end
