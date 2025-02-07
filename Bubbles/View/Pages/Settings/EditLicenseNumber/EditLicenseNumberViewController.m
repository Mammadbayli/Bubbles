//
//  EditLicenseNumberViewController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 9/26/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.
//

#import "EditLicenseNumberViewController.h"
#import "LicensePlateControlNode.h"
#import "ButtonNode.h"
#import "UIFont+NFSFonts.h"
#import "UIColor+NFSColors.h"
#import "TextNode.h"
#import "NSNumber+Dimensions.h"
#import "PersistencyManager.h"
#import "MediaPickerController.h"
#import "ChangeUsernameController.h"
#import "NSError+PromiseKit.h"
#import "Constants.h"

@interface EditLicenseNumberViewController () <MediaPickerControllerDelegate>
@property (strong, nonatomic) LicensePlateControlNode *licensePlateNode;
@property (strong, nonatomic) ButtonNode *button;
@property (strong, nonatomic) TextControlNode *registrationCertificateNode;
@property (strong, nonatomic) ButtonNode *editLicenseNumberNode;
@property (strong, nonatomic) ButtonNode *editRegistrationCertificateNode;
@property (strong, nonatomic) MediaPickerController *mediaPicker;
@property (strong, nonatomic) NSArray *selectedDocuments;
@property (strong, nonatomic) TextNode *statusTextNode;
@property (strong, nonatomic) ButtonNode *resetButtonNode;
@property (strong, nonatomic) ButtonNode *verifyButtonNode;
@property (nonatomic) BOOL isVerified;
@property (nonatomic) BOOL hasRequestedUsernameChange;
@end

@implementation EditLicenseNumberViewController

- (void)setSelectedDocuments:(NSArray *)selectedDocuments {
    _selectedDocuments = selectedDocuments;
    if ([selectedDocuments count] >= 0) {
        [[self editRegistrationCertificateNode] setText:@"✓"];
        [[self editRegistrationCertificateNode] setTintColor:[UIColor NFSGreenColor]];
        [[self editRegistrationCertificateNode] setTextColor:[UIColor NFSGreenColor]];
    } else {
        [[self editRegistrationCertificateNode] setText:@"\ue905"];
        [[self editRegistrationCertificateNode] setTintColor:[UIColor blackColor]];
    }

}

- (LicensePlateControlNode *)licensePlateNode {
    if (!_licensePlateNode) {
        _licensePlateNode = [[LicensePlateControlNode alloc] init];
//        [_licensePlateNode setLicensePlateNumber:[[PersistencyManager sharedInstance] getUsername]];
        
        typeof(self) __weak weakSelf = self;
        [_licensePlateNode setOnTextUpdate:^(NSString * _Nonnull text) {
            [weakSelf validateSubmitButton];
        }];
    }
    
    return _licensePlateNode;
}

- (TextControlNode *)registrationCertificateNode {
    if (!_registrationCertificateNode) {
        _registrationCertificateNode = [[TextControlNode alloc] init];
        [_registrationCertificateNode setFont:[UIFont textFont]];
        [_registrationCertificateNode setColor:[UIColor textColor]];
        [_registrationCertificateNode setMaximumLinesToDisplay:3];
        [_registrationCertificateNode setLineSpacing: 10];
        [_registrationCertificateNode setTextAlignment:NSTextAlignmentCenter];
        [_registrationCertificateNode setText:@"REGISTRATION CERTIFICATE"];
        [_registrationCertificateNode setUserInteractionEnabled:NO];
        [[_registrationCertificateNode style] setMinHeight:ASDimensionMake(100)];
        //        [[_registrationCertificateNode style] setWidth:[[_licensePlateNode style] width]];
    }
    
    return _registrationCertificateNode;
}

- (ButtonNode *)editRegistrationCertificateNode {
    if (!_editRegistrationCertificateNode) {
        _editRegistrationCertificateNode = [ButtonNode buttonWithTitle:@"\ue905"];
        [_editRegistrationCertificateNode setFont:[UIFont icomoonFont]];
//        [[_editRegistrationCertificateNode style] setMinHeight:ASDimensionMake(40)];
//        [_editRegistrationCertificateNode setFont:[UIFont systemFontOfSize:12]];
        [_editRegistrationCertificateNode setTintColor:[UIColor NFSGreenColor]];
        
        typeof(self) __weak weakSelf = self;
        [_editRegistrationCertificateNode setOnCLick:^{
            [weakSelf presentAttachmentOptions];
        }];
    }
    
    return _editRegistrationCertificateNode;
}

- (ButtonNode *)button {
    if (!_button) {
        _button = [ButtonNode greenButtonWithTitle:@"change_username_button_title"];
        [_button setEnabled:NO];
        [[_button style] setSpacingBefore:10];
        
        typeof(self) __weak weakSelf = self;
        [_button setOnCLick:^{
            NSString *newUsername = [[weakSelf licensePlateNode] licensePlateNumber];
            NSArray *documents = [weakSelf selectedDocuments];
            
            [[ChangeUsernameController sharedInstance] requestUsernameChangeToNewUsername:newUsername
                                                                  withSupportingDocuments:documents].then(^(){
                //                [weakSelf setHasRequestedUsernameChange:!![[PersistencyManager sharedInstance] getUsernameChangeRequestId]];
                [weakSelf checkRequestStatus];
                //                [[weakSelf node] setNeedsLayout];
            });
        }];
    }
    
    return _button;
}

- (ButtonNode *)editLicenseNumberNode {
    if (!_editLicenseNumberNode) {
        _editLicenseNumberNode = [ButtonNode buttonWithGreenTitle:@"edit"];
//        [[_editLicenseNumberNode style] setMaxWidth: ASDimensionMake(40)];
    }
    
    return _editLicenseNumberNode;
}

- (TextNode *)statusTextNode {
    if (!_statusTextNode) {
        _statusTextNode = [[TextNode alloc] init];
        [_statusTextNode setTextAlignment:NSTextAlignmentCenter];
        [_statusTextNode setText:@"registration_status_fetching_hint"];
    }
    
    return _statusTextNode;
}

- (ButtonNode *)verifyButtonNode {
    if (!_verifyButtonNode) {
//        typeof(self) __weak weakSelf = self;
        _verifyButtonNode = [ButtonNode greenButtonWithTitle:@"registration_status_verify_now"];
        [_verifyButtonNode setOnCLick:^{
            [[ChangeUsernameController sharedInstance] completeUsernameChange];
        }];
    }

    return _verifyButtonNode;
}

- (ButtonNode *)resetButtonNode {
    if (!_resetButtonNode) {
        typeof(self) __weak weakSelf = self;
        _resetButtonNode = [ButtonNode orangeButtonWithTitle:@"registration_status_try_again"];
        [_resetButtonNode setOnCLick:^{
            //            [[RegistrationController sharedInstance] resetRegistrationAttempt];
            [weakSelf setHasRequestedUsernameChange:NO];
            [[weakSelf node] setNeedsLayout];
        }];
    }

    return _resetButtonNode;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self setNavTitle:@"settings_change_license_plate"];
        
        _mediaPicker = [[MediaPickerController alloc] init];
        [_mediaPicker setDelegate:self];
        [_mediaPicker setHasTextInput:NO];
        [_mediaPicker setAllowsMultipleSelection:YES];
        _selectedDocuments = @[];
        
        [self setExtendedLayoutIncludesOpaqueBars:NO];
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(checkRequestStatus)
            name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [self checkRequestStatus];
        
        typeof(self) __weak weakSelf = self;
        [[self node] setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            if ([weakSelf hasRequestedUsernameChange]) {
                if ([weakSelf isVerified]) {
                    ASLayoutSpec *stackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                        spacing:[NSNumber stackLayoutDefaultSpacing]
                                                                                 justifyContent:ASStackLayoutJustifyContentCenter
                                                                                     alignItems:ASStackLayoutAlignItemsCenter
                                                                                       children:@ [
                                                                                                   [weakSelf statusTextNode],
                                                                                                   [weakSelf verifyButtonNode]
                                                                                                   ]];
                    
                    return stackLayout;
                } else {
                    ASLayoutSpec *stackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                        spacing:[NSNumber stackLayoutDefaultSpacing]
                                                                                 justifyContent:ASStackLayoutJustifyContentCenter
                                                                                     alignItems:ASStackLayoutAlignItemsCenter
                                                                                       children:@ [
                                                                                                   [weakSelf statusTextNode],
                                                                                                   [weakSelf resetButtonNode]
                                                                                                   ]];
                    
                    return stackLayout;
                }
   
            } else {
//                ASCornerLayoutSpec *topRow = [ASCornerLayoutSpec cornerLayoutSpecWithChild:[weakSelf licensePlateNode]
//                                                                                    corner:[weakSelf editLicenseNumberNode]
//                                                                                  location:ASCornerLayoutLocationTopRight];
                
                //                [[weakSelf licensePlateNode] setOffset:CGPointMake(20, 20)];
                [[[weakSelf licensePlateNode] style] setSpacingBefore:20];
                
                
                
                ASCornerLayoutSpec *bottomRow = [ASCornerLayoutSpec cornerLayoutSpecWithChild:[weakSelf registrationCertificateNode]
                                                                                       corner:[weakSelf editRegistrationCertificateNode]
                                                                                     location:ASCornerLayoutLocationTopRight];
                
                [bottomRow setOffset:CGPointMake(20, 20)];
                
                ASLayoutSpec *stackLayout = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                    spacing:[NSNumber stackLayoutDefaultSpacing]
                                                                             justifyContent:ASStackLayoutJustifyContentStart
                                                                                 alignItems:ASStackLayoutAlignItemsCenter
                                                                                   children:@[[weakSelf licensePlateNode],
                                                                                              bottomRow,
                                                                                              [weakSelf button]
                                                                                            ]];
                
                return stackLayout;
            }
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:PUSH_NOTIFICATION_ACTION_ADMIN_USERNAME_CHANGE
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf checkRequestStatus];
        }];
    }
    
    return self;
}

- (void)checkRequestStatus {
    if (![[PersistencyManager sharedInstance] getUsernameChangeRequestId]) {
        return;
    }
    
    [self setHasRequestedUsernameChange:YES];
    
    typeof(self) __weak weakSelf = self;
    [[ChangeUsernameController sharedInstance] getUsernameChangeRequestStatus].then(^(NSNumber *isApproved){
        switch ([isApproved integerValue]) {
            case 0:
                [[weakSelf statusTextNode] setText:@"registration_status_pending_hint"];
                break;
            case 1:
                [[weakSelf statusTextNode] setText:@"registration_status_rejected_incorrect_documents_hint"];
                break;
            case 2:
                [[weakSelf statusTextNode] setText:@"registration_status_rejected_illegible_documents_hint"];
                break;
            case 3:
                [[weakSelf statusTextNode] setText:@"registration_status_approved_hint"];
                break;
                
            default:
                break;
        }
        
        [weakSelf setIsVerified:[isApproved integerValue] == 3];
        [[weakSelf node] setNeedsLayout];
    }).catch(^(NSError *error) {
        [[weakSelf statusTextNode] setText:[error message]];
    });
}

- (void)validateSubmitButton {
    if ([[self licensePlateNode] text] && [[self selectedDocuments] count]) {
        [[self button] setEnabled:YES];
    } else {
        [[self button] setEnabled:NO];
    }
}

- (void)mediaPickerControllerDidFinishPicking:(NSArray *)media andText:(NSString *)text{
    [self setSelectedDocuments:media];
    [self validateSubmitButton];
}

- (void)presentAttachmentOptions {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    NSString *cameraTitle = NSLocalizedString(@"photo_source_camera", nil);
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:cameraTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerWithSource:camera];
    }];
    
    [cameraAction setValue:[UIImage imageNamed:@"action-sheet-camera"] forKey:@"image"];
    [cameraAction setValue:kCAAlignmentLeft forKey:@"titleTextAlignment"];
    [alertController addAction:cameraAction];
    
    NSString *photosTitle = NSLocalizedString(@"photo_source_photos", nil);
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:photosTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showImagePickerWithSource:photos];
    }];
    
    [photoAction setValue:[UIImage imageNamed:@"action-sheet-photo"] forKey:@"image"];
    [photoAction setValue:kCAAlignmentLeft forKey:@"titleTextAlignment"];
    [alertController addAction:photoAction];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    //    [[alertController popoverPresentationController] setSourceView:[[self attachmentButton] view]];
    //    [[alertController popoverPresentationController] setSourceRect:[[self attachmentButton] bounds]];
    [self presentViewController:alertController animated:YES completion:nil];
    //    alertController
}

- (void)showImagePickerWithSource:(MediaPickerControllerSource)source {
    [[self mediaPicker] setDelegate:self];
    [[self mediaPicker] pickMediaFromSource:source];
}

@end
