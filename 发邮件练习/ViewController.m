//
//  ViewController.m
//  发邮件练习
//
//  Created by Apple on 16/2/24.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MFMailComposeViewController.h>
#import <SKPSMTPMessage.h>
#import <NSData+Base64Additions.h>
@interface ViewController ()<MFMailComposeViewControllerDelegate,SKPSMTPMessageDelegate>

- (IBAction)button1:(id)sender;
- (IBAction)button2:(id)sender;
- (IBAction)button3:(id)sender;

/*MFMailComposeViewController *messageC*/
@property(nonatomic,strong) MFMailComposeViewController *messageC;

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)button1:(id)sender {
   
    NSString *urlStr = [NSString stringWithFormat:@"mailto://Duer@outlook.com?subject=bug报告&body=感谢您的配合!"
                        "错误详情:DCH"];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL: url];
    
    
    
}

- (IBAction)button2:(id)sender {
    self.messageC = [[MFMailComposeViewController alloc]init];
    if (!_messageC) {
        // 在设备还没有添加邮件账户的时候mailViewController为空，下面的present view controller会导致程序崩溃，这里要作出判断
        NSLog(@"设备还没有添加邮件账户");
        return;
    }
    _messageC.mailComposeDelegate = self;
    [_messageC setToRecipients:@[@"duer@outlook.com",@"Mr.duhui@outlook.com"]];
    [_messageC setSubject:@"测试主题"];
    [_messageC setMessageBody:@"测试正文" isHTML:NO];
    // 4.添加附件
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"resicon" ofType:@"png"];
    NSData *attachmentData = [NSData dataWithContentsOfFile:imagePath];
    [_messageC addAttachmentData:attachmentData mimeType:@"image/png" fileName:@"resicon"];
    [self presentViewController:_messageC animated:YES completion:^{
    }];
}

#pragma MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    /*enum MFMailComposeResult {
        MFMailComposeResultCancelled,//用户取消编辑邮件
        MFMailComposeResultSaved,//用户成功保存邮件
        MFMailComposeResultSent,//用户点击发送，将邮件放到队列中
        MFMailComposeResultFailed//用户试图保存或者发送邮件失败
    };*/
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)button3:(id)sender {
   
    SKPSMTPMessage * mm=[[SKPSMTPMessage alloc] init];
    
    [mm setSubject:@"this is subject---标题!"];
    [mm setToEmail:@"duer@outlook.com"];
    [mm setFromEmail:@"398539445@qq.com"];
    [mm setRelayHost:@"smtp.qq.com"];
    [mm setRequiresAuth:YES];
    [mm setLogin:@"398539445@qq.com"];
    [mm setPass:@"dchaizh159523681"];
    [mm setWantsSecure:YES];
    // 文字
    NSDictionary * plainPart=[NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,[NSString stringWithCString:"oooo很多文字" encoding:NSUTF8StringEncoding],kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey, nil];
    
    //图片和视频附件
    //attach image
    NSString *imgPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"png"];
    NSData *imgData = [NSData dataWithContentsOfFile:imgPath];
    NSDictionary *imagePart = [NSDictionary dictionaryWithObjectsAndKeys:@"image/jpg;\r\n\tx-unix-mode=0644;\r\n\tname=\"test.png\"",kSKPSMTPPartContentTypeKey,@"attachment;\r\n\tfilename=\"test.png\"",kSKPSMTPPartContentDispositionKey,[imgData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
    NSDictionary *imagePart1 = [NSDictionary dictionaryWithObjectsAndKeys:@"image/jpg;\r\n\tx-unix-mode=0644;\r\n\tname=\"test.png\"",kSKPSMTPPartContentTypeKey,@"attachment;\r\n\tfilename=\"test.png\"",kSKPSMTPPartContentDispositionKey,[imgData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    // 名片
    NSString *vcfPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"vcf"];
    
    NSData *vcfData = [NSData dataWithContentsOfFile: vcfPath];
    NSDictionary *vcfPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/x-vcard;\r\n\tx-unix-mode=0644;\r\n\tname=\"test.vcf\"",kSKPSMTPPartContentTypeKey,@"attachment;\r\n\tfilename=\"test.vcf\"",kSKPSMTPPartContentDispositionKey,[vcfData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    //attach video
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"20119" ofType:@"mp4"];
    NSData *videoData = [NSData dataWithContentsOfFile: videoPath];
    NSDictionary *videoPart = [NSDictionary dictionaryWithObjectsAndKeys:@"video/mp4;\r\n\tx-unix-mode=0644;\r\n\tname=\"20119.mp4\"",kSKPSMTPPartContentTypeKey,@"attachment;\r\n\tfilename=\"20119.mp4\"",kSKPSMTPPartContentDispositionKey,[videoData encodeBase64ForData],kSKPSMTPPartMessageKey,@"base64",kSKPSMTPPartContentTransferEncodingKey,nil];
    
    [mm setParts:[NSArray arrayWithObjects:plainPart,imagePart,imagePart1,videoPart,vcfPart, nil]];
    mm.delegate=self;
    [mm send];}

-(void)messageSent:(SKPSMTPMessage *)message{
    NSLog(@"已发送：%@",message);
}
-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error{

    NSLog(@"%@",error);

}
@end
