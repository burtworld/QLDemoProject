//
//  QRCodeViewController.m
//  QLDemoProject
//
//  Created by paramita on 2018/11/1.
//  Copyright © 2018 paramita. All rights reserved.
//

#import "QRCodeViewController.h"
#import <QLQRCodeUtils.h>
#import <SVProgressHUD.h>

@interface QRCodeViewController ()<QLQRCodeViewControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
    @property (weak, nonatomic) IBOutlet UISwitch *generatWithImage;
    @property (weak, nonatomic) IBOutlet UITextView *qrInfoTextView;
    @property (weak, nonatomic) IBOutlet UIImageView *qrCodeImageView;
    
@end

@implementation QRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.qrInfoTextView.text = @"https://www.baidu.com";
    
    // Do any additional setup after loading the view.
}

- (IBAction)swipQrCode:(id)sender {
    QLQRCodeViewController *vc = [QLQRCodeViewController new];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)generateQrCodeImage:(id)sender {
    if (!self.qrInfoTextView.text.length) {
        [SVProgressHUD showErrorWithStatus:@"请输入要生成二维码的字符串"];
        [SVProgressHUD dismissWithDelay:2.0f];
        return;
    }
    [UIImage generatorQrCode:self.qrInfoTextView.text size:CGSizeMake(100, 100) addImage:[UIImage imageNamed:@"^001"] corner:5.0f result:^(UIImage *img) {
        self.qrCodeImageView.image = img;
    }];
}
- (IBAction)recongnizerQrCodeFromImage:(id)sender {
    // 判断系统是否支持相机
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerController.delegate = self; //设置代理
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片来源
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }


}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    self.qrCodeImageView.image = image;
//    NSArray *ary = [UIImage detectQRCodeFromView:self.qrCodeImageView];
    NSArray *ary = [UIImage detectQRCodeFromImage:image];
    NSMutableString *str = [NSMutableString string];
    for (NSString *str1 in ary) {
        [str appendString:str1];
        [str appendString:@"\n"];
    }
    NSLog(@"str==%@",str);
    self.qrInfoTextView.text = str;
    [picker dismissViewControllerAnimated:YES completion:^{}];
    


}


#pragma mark - QRCodeViewControllerDelegate
- (void)onQRCodeScaned:(NSString *)qrString {
    self.qrInfoTextView.text = qrString;
}
    
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
