//
//  AccountViewController.m
//  Bubbles
//
//  Created by Javad Mammadbayli on 8/15/19.
//  Copyright © 2019 Javad Mammadbayli. All rights reserved.

#import "AccountViewController.h"

#import "UIFont+NFSFonts.h"
#import "UIColor+NFSColors.h"
#import "NSString+Routes.h"
#import "SettingsViewController.h"
#import "TableNode.h"
#import "AccountCellNode.h"
#import "LicensePlateControlNode.h"
#import "PhotoViewerController.h"
#import "NSNumber+Dimensions.h"
#import "CoreDataStack.h"
#import "Constants.h"
#import "TextNode.h"
#import "MediaPickerController.h"
#import "NSString+Random.h"
#import "Constants.h"
#import "UserPhoto+CoreDataClass.h"
#import "PersistencyManager.h"
#import "NSNumber+Dimensions.h"
#import "ProfileController.h"
#import "ProfilePhotoNode.h"
#import "LoggerController.h"

@interface AccountViewController ()<ASTableDelegate, ASTableDataSource, NSFetchedResultsControllerDelegate, MediaPickerControllerDelegate>
@property (strong, nonatomic) TableNode *tableNode;
@property (strong, nonatomic, readonly) NSString *username;
@property (strong, nonatomic) ProfilePhotoNode *profilePhotoNode;
@property (strong, nonatomic) ASDisplayNode *headerNode;
@property (strong, nonatomic) LicensePlateControlNode *licensePlateNode;
@property (strong, nonatomic, readonly) MediaPickerController *mediaPicker;
@property (strong, nonatomic, readonly) PhotoViewerController *photoViewer;
@property (strong, nonatomic) NSMutableArray *photoNames;
@end

@implementation AccountViewController {
    NSFetchedResultsController *_attributesResultsController;
    NSFetchedResultsController *_photosResultsController;
}

- (void)setPhotoNames:(NSMutableArray *)photoNames {
    _photoNames = photoNames;
    [self setAvatar];
}

- (LicensePlateControlNode *)licensePlateNode {
    if (!_licensePlateNode) {
        _licensePlateNode = [[LicensePlateControlNode alloc] init];
        [_licensePlateNode setLicensePlateNumber:[self username]];
        [_licensePlateNode setUserInteractionEnabled:NO];
        [[_licensePlateNode style] setMaxWidth:ASDimensionMake(200)];
    }
    
    return _licensePlateNode;
}

- (ProfilePhotoNode *)profilePhotoNode {
    if (!_profilePhotoNode) {
        _profilePhotoNode = [[ProfilePhotoNode alloc] init];
        [_profilePhotoNode addTarget:self
                              action:@selector(showPhotos)
                    forControlEvents:ASControlNodeEventTouchUpInside];
    }
    
    return _profilePhotoNode;
}

- (ASDisplayNode*)headerNode {
    if(!_headerNode) {
        _headerNode = [[ASDisplayNode alloc] init];
        [_headerNode setFrame:CGRectMake(0, 0, 0, 200)];
        [_headerNode setAutomaticallyManagesSubnodes:YES];
        [_headerNode setClipsToBounds:YES];
        [_headerNode setUserInteractionEnabled:YES];
        
        TextNode *editProfilePhotoNode = [TextNode textWithIcon:@"\uea19"];
        [editProfilePhotoNode setBackgroundColor:[UIColor NFSOrangeColor]];
        [editProfilePhotoNode setCornerRadius:15];
        [editProfilePhotoNode setClipsToBounds:YES];
        [editProfilePhotoNode addTarget:self
                                 action:@selector(editProfilePhoto)
                       forControlEvents:ASControlNodeEventTouchUpInside];
        
        typeof(self) __weak weakSelf = self;
        [_headerNode setLayoutSpecBlock:^ASLayoutSpec * _Nonnull(__kindof ASDisplayNode * _Nonnull node, ASSizeRange constrainedSize) {
            if([weakSelf isViewingSelf]) {
                ASCornerLayoutSpec *cornerLayout = [ASCornerLayoutSpec cornerLayoutSpecWithChild:[weakSelf profilePhotoNode]
                                                                                          corner:editProfilePhotoNode
                                                                                        location:ASCornerLayoutLocationBottomRight];
                [cornerLayout setOffset:CGPointMake(-20, -20)];
                
                ASStackLayoutSpec *stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                                   spacing:20
                                                                            justifyContent:ASStackLayoutJustifyContentCenter
                                                                                alignItems:ASStackLayoutAlignItemsCenter
                                                                                  children:@[cornerLayout, [weakSelf licensePlateNode]]];
                return stack;
            }
            
            ASStackLayoutSpec *stack = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical
                                                                               spacing:20
                                                                        justifyContent:ASStackLayoutJustifyContentCenter
                                                                            alignItems:ASStackLayoutAlignItemsCenter
                                                                              children:@[[weakSelf profilePhotoNode], [weakSelf licensePlateNode]]];
            return stack;
        }];
    }
    
    return _headerNode;
}

- (NSManagedObjectContext*)managedObjectContext {
    return [[CoreDataStack sharedInstance] mainContext];
}

- (void)updateVCardForKey:(NSString*)key value:(NSString*)value visible:(BOOL)isVisible {
    NSString *username = [self username];
    NSManagedObjectContext *context = [[CoreDataStack sharedInstance] backgroundContext];
    
    [context performBlock:^{
        NSFetchRequest *request = [UserAttribute fetchRequest];
        [request setFetchLimit:1];
        [request setPredicate:[NSPredicate predicateWithFormat:@"username = %@ AND name = %@", username, key]];
        NSArray *results = [context executeFetchRequest:request error:nil];
    
        UserAttribute *attribute = [results firstObject];
        
        if (!attribute) {
            attribute = [[UserAttribute alloc] initWithContext:context];
            [attribute setName:key];
            [attribute setUsername:username];
            [[self attributes] setValue:attribute forKey:key];
        }
        
        [attribute setValue:value];
        [attribute setIsVisible:isVisible];
        
        [[CoreDataStack sharedInstance] saveContext:context];
        
        [[ProfileController sharedInstance] setProfileValue:[attribute json]
                                                     ForKey:[attribute name]
                                                ForUsername:[self username]];
    }];
}

- (void)prepareAttributesResultsController:(NSString * _Nonnull)username {
    NSFetchRequest *request = [UserAttribute fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@", username];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:NO];
    [request setSortDescriptors:@[sortDescriptor]];
    
    _attributesResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                       managedObjectContext:[[CoreDataStack sharedInstance] mainContext]
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil];
    [_attributesResultsController setDelegate:self];
    [_attributesResultsController performFetch:nil];
}

- (void)preparePhotosResultsController:(NSString * _Nonnull)username {
    NSFetchRequest *request = [UserPhoto fetchRequest];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@", username];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    _photosResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                       managedObjectContext:[[CoreDataStack sharedInstance] mainContext]
                                                                         sectionNameKeyPath:nil
                                                                                  cacheName:nil];
    [_photosResultsController setDelegate:self];
    [_photosResultsController performFetch:nil];
    
    [self processProfilePictures];
}

- (TableNode *)tableNode {
    if (!_tableNode) {
        _tableNode = [[TableNode alloc] initWithStyle:UITableViewStylePlain];
        [_tableNode setAllowsSelection:NO];
        [_tableNode setDelegate:self];
        [_tableNode setDataSource:self];
        [[_tableNode view] setTableHeaderView:[[self headerNode] view]];
        [[_tableNode view] setShowsVerticalScrollIndicator:NO];
        [_tableNode setContentInset:UIEdgeInsetsMake(10, 0, 0, 0)];
    }
    
    return _tableNode;
}

- (void)loadAttributes {
    [[self managedObjectContext] performBlock:^{
        NSFetchRequest *attributesRequest = [UserAttribute fetchRequest];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username == %@", [self username]];
        [attributesRequest setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"username" ascending:NO];
        [attributesRequest setSortDescriptors:@[sortDescriptor]];
        
        NSArray *attributes = [[self managedObjectContext] executeFetchRequest:attributesRequest error:nil];
        
        [[self attributes] removeAllObjects];
        
        for (UserAttribute *attr in attributes) {
            [self attributes][[attr name]] = attr;
        }
        
        NSArray *items = @[
            @[
                USER_NAME_KEY,
                USER_SURNAME_KEY,
                USER_PHONE_NUMBER_KEY,
            ],
            @[
                USER_ABOUT_KEY,
                USER_CAREER_KEY,
                USER_EDUCATION_KEY,
                USER_INTERESTS_KEY
            ]
        ];
        
        [self setItems:items];
        
        [[self tableNode] reloadData];
    }];
}

- (instancetype)initWithUser:(NSString *)username {
    return [self initWithUser:username andIsViewingSelf:NO];
}

- (instancetype)initWithUser:(NSString *)username andIsViewingSelf:(BOOL)isViewingSelf {
    self = [super initWithNode:[self tableNode]];
    if (self) {
        [self setNavTitle:@"account"];
        
        [self setEdgesForExtendedLayout:UIRectEdgeTop];
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        
        _username = username;
        _isViewingSelf = isViewingSelf;
        _attributes = [[NSMutableDictionary alloc] init];
        _photoViewer = [[PhotoViewerController alloc] init];
        [_photoViewer setTitle:[username uppercaseString]];
               
        _mediaPicker = [[MediaPickerController alloc] init];
        [_mediaPicker setShouldPreview:NO];
        
        [self prepareAttributesResultsController:username];
        [self preparePhotosResultsController:username];
        
        [self loadAttributes];
        
        [self setTabBarItem:[[UITabBarItem alloc] initWithTitle:nil
                                                          image:[UIImage imageNamed:@"tabbar-gear"]
                                                  selectedImage:nil]];
        
        typeof(self) __weak weakSelf = self;
        [[NSNotificationCenter defaultCenter] addObserverForName:@"change-username"
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
            [weakSelf updateTabbarItem];
        }];
        
        if (isViewingSelf) {
            UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"\uea03"
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(navigateToSettings)];
            
            
            [buttonItem setTitleTextAttributes:@{ NSFontAttributeName: [[UIFont NFSFont] fontWithSize:25] } forState:UIControlStateNormal];
            [buttonItem setTitleTextAttributes:@{ NSFontAttributeName: [[UIFont NFSFont] fontWithSize:25] } forState:UIControlStateSelected];
            [buttonItem setTintColor:[UIColor NFSGreenColor]];
            [[self navigationItem] setRightBarButtonItem: buttonItem];
        }
        
        [self setEdgesForExtendedLayout:UIRectEdgeAll];
        [self setExtendedLayoutIncludesOpaqueBars:YES];
        
        [[ProfileController sharedInstance] getProfileForUsername:username];
    }
    
    return self;
}

- (void)updateTabbarItem {
    if (![[self view] window]) {
//        [self setTabBarItem:[[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"tabbar-gear-badge"] selectedImage:nil]];
        [[self tabBarItem] setBadgeValue:@""];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self tabBarItem] setBadgeValue:nil];
    
    if (![self isViewingSelf]) {
        [[self navigationItem] setLargeTitleDisplayMode:UINavigationItemLargeTitleDisplayModeNever];
    } else {
        [[self navigationItem] setLargeTitleDisplayMode:UINavigationItemLargeTitleDisplayModeAlways];
    }
}

- (void)navigateToSettings {
    [[self navigationController] pushViewController:[[SettingsViewController alloc] init] animated:YES];
}

- (void)editProfilePhoto {
    [[self mediaPicker] setDelegate:self];
    [[self mediaPicker] pickMediaFromSource:photos];
}

- (void)showPhotos {
    [self presentPhotoViewerWithPhotos:[self photoNames]];
}

- (void)presentPhotoViewerWithPhotos:(NSArray *)photos {
    if ([photos count] > 0) {
        if (_isViewingSelf) {
            [[self photoViewer] viewPhotos:photos];
            UIBarButtonItem *deleteBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                                                 target:self
                                                                                                 action:@selector(deletePhoto)];
            [[[self photoViewer]  navigationItem] setLeftBarButtonItem:deleteBarButtonItem];
            
            UIButton *button = [UIButton new];
            [button setImage:[UIImage systemImageNamed:@"person.fill.checkmark"] forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(updateAvatar)
             forControlEvents:UIControlEventTouchUpInside];
            [[[self photoViewer] navigationItem] setTitleView:button];
        } else {
            [[self photoViewer] viewPhotos:photos];
        }
    }
}

- (void)setAvatar {
    [[self profilePhotoNode] setPhotoId:[[self photoNames] firstObject]];
}

- (void)updateAvatar {
    if ([[self photoNames] count]) {
        NSUInteger index = [[self photoViewer] currentIndex];
        NSString *photo = [[self photoNames] objectAtIndex:index];
        [[self photoNames] removeObjectAtIndex:index];
        [[self photoNames] insertObject:photo atIndex:0];
        
        [[self photoViewer] setPhotos:[self photoNames]];
        [self updateProfilePictures];
    }
    
    [self setAvatar];
}

- (void)deletePhoto {
    NSUInteger index = [[self photoViewer] deleteCurrentPhoto];
    [[self photoNames] removeObjectAtIndex:index];
    [self setAvatar];
    [self updateProfilePictures];
}

- (void)updateProfilePictures {
    [[ProfileController sharedInstance] updateProfilePictures:[self photoNames]
                                                  forUsername:[self username]
                                                  withContext:[[CoreDataStack sharedInstance] backgroundContext]];
}

- (AnyPromise *)uploadPhotos:(NSArray *)photos {
    NSMutableArray *promises = [[NSMutableArray alloc] init];
    
    for (UIImage *image in photos) {
        if (image) {
            NSData *data = UIImageJPEGRepresentation(image, 1);
            AnyPromise *promise = [[PersistencyManager sharedInstance] uploadFile:data];
            [promises addObject:promise];
        }
    }
    
    return PMKWhen(promises);
}

- (void)mediaPickerControllerDidFinishPicking:(NSArray *)media andText:(NSString *)text{
    [[self profilePhotoNode] setImage:[media lastObject]];
    [[self profilePhotoNode] showActivityIndicator];
    [[self headerNode] setUserInteractionEnabled:NO];
    
   [self uploadPhotos:media]
        .then(^(NSArray *fileNames){
            for (NSString *fileName in fileNames) {
                [[self photoNames] insertObject:fileName atIndex:0];
            }
            
            [self updateProfilePictures];
        }).ensure(^{
            [[self profilePhotoNode] hideActivityIndicator];
            [[self headerNode] setUserInteractionEnabled:YES];
        });
}

- (void)mediaPickerControllerDidCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)processProfilePictures {
    NSMutableArray __block *photoNames = [[NSMutableArray alloc] init];
    NSArray *userPhotos = [_photosResultsController fetchedObjects];
    
    [userPhotos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UserPhoto *userPhoto = obj;
        
        [photoNames addObject:[userPhoto name]];
    }];
    
    [self setPhotoNames:photoNames];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    if ([[[controller fetchRequest] entityName] isEqualToString:[[UserPhoto entity] name]]) {
        [self processProfilePictures];
    } else {
        [self loadAttributes];
    }
}

@end
