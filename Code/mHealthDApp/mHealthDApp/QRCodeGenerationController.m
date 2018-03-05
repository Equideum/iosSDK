//
//  QRCodeGenerationController.m
//  mHealthDApp
//
//  Created by Sonam Agarwal on 12/4/17.
//  Copyright © 2017 Sonam Agarwal. All rights reserved.
//

#import "QRCodeGenerationController.h"
#import "Constants.h"

@interface QRCodeGenerationController ()

@end

@implementation QRCodeGenerationController

- (void)viewDidLoad {
    DebugLog(@"");
    [super viewDidLoad];
    NSString *info = @"www.fhirblocks.org";
    
    // Generation of QR code image
    NSData *qrCodeData = [info dataUsingEncoding:NSISOLatin1StringEncoding]; // recommended encoding
    CIFilter *qrCodeFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [qrCodeFilter setValue:qrCodeData forKey:@"inputMessage"];
    [qrCodeFilter setValue:@"M" forKey:@"inputCorrectionLevel"]; //default of L,M,Q & H modes
    
    CIImage *qrCodeImage = qrCodeFilter.outputImage;
    
    CGRect imageSize = CGRectIntegral(qrCodeImage.extent); // generated image size
    CGSize outputSize = CGSizeMake(240.0, 240.0); // required image size
    CIImage *imageByTransform = [qrCodeImage imageByApplyingTransform:CGAffineTransformMakeScale(outputSize.width/CGRectGetWidth(imageSize), outputSize.height/CGRectGetHeight(imageSize))];
    
    UIImage *qrCodeImageByTransform = [UIImage imageWithCIImage:imageByTransform];
    self.imgViewQRCode.image = qrCodeImageByTransform;
    
    // Generation of bar code image
    CIFilter *barCodeFilter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    NSData *barCodeData = [info dataUsingEncoding:NSASCIIStringEncoding]; // recommended encoding
    [barCodeFilter setValue:barCodeData forKey:@"inputMessage"];
    [barCodeFilter setValue:[NSNumber numberWithFloat:7.0] forKey:@"inputQuietSpace"]; //default whitespace on sides of barcode
    
    CIImage *barCodeImage = barCodeFilter.outputImage;
    self.imgViewBarCode.image = [UIImage imageWithCIImage:barCodeImage];
    
}
- (IBAction)backButtonTapped:(id)sender
{
    DebugLog(@"");
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    DebugLog(@"");
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


