#import "ChatStatusTableViewController.h"

#import "SVProgressHUD.h"
#import "UIScrollView+EmptyDataSet.h"

#import "EmptyStateView.h"
#import "Helper.h"
#import "MEGAReachabilityManager.h"
#import "MEGASdkManager.h"
#import "MEGA-Swift.h"

static const NSInteger MaxAutoawayTimeout = 1457; // 87420 seconds

@interface ChatStatusTableViewController () <UITextFieldDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, MEGAChatDelegate>

@property (nonatomic) MEGAChatPresenceConfig *presenceConfig;
@property (weak, nonatomic) NSIndexPath *currentStatusIndexPath;

@property (weak, nonatomic) IBOutlet UILabel *onlineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *onlineRedCheckmarkImageView;
@property (weak, nonatomic) IBOutlet UILabel *awayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *awayRedCheckmarkImageView;
@property (weak, nonatomic) IBOutlet UILabel *busyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *busyRedCheckmarkImageView;
@property (weak, nonatomic) IBOutlet UILabel *offlineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *offlineRedCheckmarkImageView;

@property (weak, nonatomic) IBOutlet UILabel *autoAwayLabel;
@property (weak, nonatomic) IBOutlet UISwitch *autoAwaySwitch;
@property (weak, nonatomic) IBOutlet UITextField *autoAwayTimeTextField;
@property (weak, nonatomic) IBOutlet UIButton *autoAwayTimeSaveButton;
@property (nonatomic) NSInteger autoAwayTimeoutInMinutes;

@property (weak, nonatomic) IBOutlet UILabel *statusPersistenceLabel;
@property (weak, nonatomic) IBOutlet UISwitch *statusPersistenceSwitch;

@property (weak, nonatomic) IBOutlet UILabel *lastActiveLabel;
@property (weak, nonatomic) IBOutlet UISwitch *lastActiveSwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *timeAutoAwayCell;

@end

@implementation ChatStatusTableViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    self.navigationItem.title = NSLocalizedString(@"status", @"Title that refers to the status of the chat (Either Online or Offline)");
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SelectableTableViewCell" bundle:nil] forCellReuseIdentifier:@"SelectableTableViewCellID"];
    
    self.onlineLabel.text = NSLocalizedString(@"online", nil);
    self.awayLabel.text = NSLocalizedString(@"away", nil);
    self.busyLabel.text = NSLocalizedString(@"busy", nil);
    self.offlineLabel.text = NSLocalizedString(@"offline", @"Title of the Offline section");
    
    self.autoAwayLabel.text = NSLocalizedString(@"autoAway", nil);
    
    self.statusPersistenceLabel.text = NSLocalizedString(@"statusPersistence", nil);
    [self.autoAwayTimeSaveButton setTitle:NSLocalizedString(@"save", @"Button title to 'Save' the selected option") forState:UIControlStateNormal];
    
    [self setLastActiveLabelAttributedText];
    
    [self updateAppearance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(internetConnectionChanged) name:kReachabilityChangedNotification object:nil];
    
    [[MEGASdkManager sharedMEGAChatSdk] addChatDelegate:self];
    
    self.presenceConfig = [[MEGASdkManager sharedMEGAChatSdk] presenceConfig];
    [self updateUIWithPresenceConfig];
    
    self.autoAwayTimeoutInMinutes = (NSInteger)(self.presenceConfig.autoAwayTimeout / 60);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    
    [[MEGASdkManager sharedMEGAChatSdk] removeChatDelegate:self];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    
    if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
        [self updateAppearance];
    }
    
    if (self.traitCollection.preferredContentSizeCategory != previousTraitCollection.preferredContentSizeCategory) {
        [self setLastActiveLabelAttributedText];
    }
}

#pragma mark - Private

- (void)updateAppearance {
    self.tableView.separatorColor = [UIColor mnz_separatorForTraitCollection:self.traitCollection];
    self.tableView.backgroundColor = [UIColor mnz_backgroundGroupedForTraitCollection:self.traitCollection];
    
    self.autoAwayTimeTextField.textColor = [UIColor mnz_turquoiseForTraitCollection:self.traitCollection];
    [self.autoAwayTimeSaveButton setTitleColor:[UIColor mnz_turquoiseForTraitCollection:self.traitCollection] forState:UIControlStateNormal];
    
    [self.tableView reloadData];
}

- (void)internetConnectionChanged {
    [self.tableView reloadData];
}

- (void)updateUIWithPresenceConfig {
    [self deselectRowWithPreviousStatus];
    
    [self updateCurrentIndexPathForOnlineStatus];
    
    self.autoAwaySwitch.on = self.presenceConfig.isAutoAwayEnabled;
    self.timeAutoAwayCell.hidden = !self.presenceConfig.isAutoAwayEnabled;
    [self updateAutoAwayTimeLabel];
    
    self.statusPersistenceSwitch.on = self.presenceConfig.isPersist;
    
    self.lastActiveSwitch.on = self.presenceConfig.isLastGreenVisible;
    
    [self.tableView reloadData];
}

- (void)setLastActiveLabelAttributedText {
    NSAttributedString *lastSeenString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"Last seen %s", nil), "..."] attributes:@{NSFontAttributeName:[UIFont mnz_preferredFontWithStyle:UIFontTextStyleBody weight:UIFontWeightRegular].fontWithItalic}];
    NSMutableAttributedString *showLastSeenAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", NSLocalizedString(@"Show", @"Label shown next to a feature name that can be enabled or disabled, like in 'Show Last seen...'")]];
    [showLastSeenAttributedString appendAttributedString:lastSeenString];
    
    self.lastActiveLabel.attributedText = showLastSeenAttributedString;
}

- (void)deselectRowWithPreviousStatus {
    if (self.currentStatusIndexPath) {
        SelectableTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentStatusIndexPath];
        cell.redCheckmarkImageView.hidden = YES;
    }
}

- (void)updateCurrentIndexPathForOnlineStatus {
    NSIndexPath *presenceIndexPath;
    switch (self.presenceConfig.onlineStatus) {
        case MEGAChatStatusOffline:
            presenceIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            break;
            
        case MEGAChatStatusAway:
            presenceIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            break;
            
        case MEGAChatStatusOnline:
            presenceIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            break;
            
        case MEGAChatStatusBusy:
            presenceIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            break;
            
        case MEGAChatStatusInvalid:
            break;
    }
    self.currentStatusIndexPath = presenceIndexPath;
    
    SelectableTableViewCell *cell = [self.tableView cellForRowAtIndexPath:self.currentStatusIndexPath];
    cell.redCheckmarkImageView.hidden = NO;
}

- (void)setPresenceAutoAway:(BOOL)boolValue {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
    
    [[MEGASdkManager sharedMEGAChatSdk] setPresenceAutoaway:boolValue timeout:(self.autoAwayTimeoutInMinutes * 60)];
}

- (void)updateAutoAwayTimeLabel {
    NSString *xMinutes;
    if ((self.presenceConfig.autoAwayTimeout / 60) < 2) {
        xMinutes = NSLocalizedString(@"1Minute", nil);
        self.autoAwayTimeTextField.text = xMinutes;
    } else {
        xMinutes = NSLocalizedString(@"xMinutes", nil);
        self.autoAwayTimeTextField.text = [xMinutes stringByReplacingOccurrencesOfString:@"[X]" withString:[NSString stringWithFormat:@"%lld", (self.presenceConfig.autoAwayTimeout / 60)]];
    }
    
    self.autoAwayTimeSaveButton.hidden = YES;
}

#pragma mark - IBActions

- (IBAction)autoAwayValueChanged:(UISwitch *)sender {
    [self setPresenceAutoAway:sender.on];
}

- (IBAction)autoAwayTimeSaveButtonTouchUpInside:(UIButton *)sender {
    [self.autoAwayTimeTextField resignFirstResponder];
    
    self.autoAwayTimeSaveButton.enabled = NO;
    self.autoAwayTimeSaveButton.hidden = YES;
    
    if (self.autoAwayTimeTextField.text.intValue == 0) {
        self.autoAwayTimeTextField.text = @"1";
    }
    
    if (self.autoAwayTimeTextField.text.intValue > MaxAutoawayTimeout) {
        self.autoAwayTimeTextField.text = [NSString stringWithFormat:@"%td", MaxAutoawayTimeout];
    }
    
    if ([self.autoAwayTimeTextField.text isEqualToString:[NSString stringWithFormat:@"%lld", (self.presenceConfig.autoAwayTimeout / 60)]]) {
        [self updateAutoAwayTimeLabel];
        return;
    }
    
    self.autoAwayTimeoutInMinutes = self.autoAwayTimeTextField.text.intValue;
    
    [self setPresenceAutoAway:self.autoAwaySwitch.isOn];
}

- (IBAction)statusPersistenceValueChanged:(UISwitch *)sender {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
    
    [[MEGASdkManager sharedMEGAChatSdk] setPresencePersist:sender.on];
}

- (IBAction)lastGreenValueChanged:(UISwitch *)sender {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD show];
    
    [[MEGASdkManager sharedMEGAChatSdk] setLastGreenVisible:sender.on];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger numberOfSections = 0;
    if ([MEGAReachabilityManager isReachable]) {
        MEGAChatStatus onlineStatus = self.presenceConfig.onlineStatus;
        if (onlineStatus == MEGAChatStatusOnline) {
            if (self.presenceConfig.isPersist) {
                numberOfSections = 3; //If Status Persistence is active = No autoaway
            } else {
                numberOfSections = 4;
            }
        } else if (onlineStatus == MEGAChatStatusOffline) {
            numberOfSections = 2; //No autoaway nor persist
        } else {
            numberOfSections = 3; //No autoaway
        }
    }
    
    return numberOfSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    NSString *titleForFooter;
    switch (section) {
        case 0:
            titleForFooter = nil;
            break;
            
        case 1:
            titleForFooter = NSLocalizedString(@"Allow your contacts to see the last time you were active on MEGA.", @"Footer text to explain the meaning of the functionaly 'Last seen' of your chat status.");
            break;
            
        case 2:
            titleForFooter = NSLocalizedString(@"maintainMyChosenStatusAppearance", @"Footer text to explain the meaning of the functionaly 'Auto-away' of your chat status.");
            break;
            
        case 3:
            if (self.presenceConfig.isAutoAwayEnabled) {
                if ((self.presenceConfig.autoAwayTimeout / 60) >= 2) {
                    titleForFooter = NSLocalizedString(@"showMeAwayAfterXMinutesOfInactivity", @"Footer text to explain the meaning of the functionaly Auto-away of your chat status.");
                    titleForFooter = [titleForFooter stringByReplacingOccurrencesOfString:@"[X]" withString:[NSString stringWithFormat:@"%lld", (self.presenceConfig.autoAwayTimeout / 60)]];
                } else {
                    titleForFooter = NSLocalizedString(@"showMeAwayAfter1MinuteOfInactivity", @"Footer text to explain the meaning of the functionaly Auto-away of your chat status.");
                }
            }
            break;
    }
    
    return titleForFooter;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor mnz_secondaryBackgroundGrouped:self.traitCollection];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.autoAwayTimeTextField.isEditing) {
        [self.autoAwayTimeTextField resignFirstResponder];
    }
    
    if (self.currentStatusIndexPath == indexPath) {
        return;
    }

    if (indexPath.section == 0) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD show];
        
        switch (indexPath.row) {
            case 0: //Online
                [[MEGASdkManager sharedMEGAChatSdk] setOnlineStatus:MEGAChatStatusOnline];
                break;
                
            case 1: //Away
                [[MEGASdkManager sharedMEGAChatSdk] setOnlineStatus:MEGAChatStatusAway];
                break
                ;
            case 2: //Busy
                [[MEGASdkManager sharedMEGAChatSdk] setOnlineStatus:MEGAChatStatusBusy];
                break;
                
            case 3: //Offline
                [[MEGASdkManager sharedMEGAChatSdk] setOnlineStatus:MEGAChatStatusOffline];
                break;
        }
    } else if (indexPath.section == 3 && indexPath.row == 1) { //Auto-away - Number of minutes for Auto-away
        [self.autoAwayTimeTextField becomeFirstResponder];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    textField.text = [NSString stringWithFormat:@"%lld", (self.presenceConfig.autoAwayTimeout / 60)];
    
    self.autoAwayTimeSaveButton.enabled = YES;
    self.autoAwayTimeSaveButton.hidden = NO;
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    self.autoAwayTimeSaveButton.enabled = YES;
    
    return YES;
}

#pragma mark - DZNEmptyDataSetSource

- (nullable UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
    EmptyStateView *emptyStateView = [EmptyStateView.alloc initWithImage:[self imageForEmptyState] title:[self titleForEmptyState] description:[self descriptionForEmptyState] buttonTitle:[self buttonTitleForEmptyState]];
    [emptyStateView.button addTarget:self action:@selector(buttonTouchUpInsideEmptyState) forControlEvents:UIControlEventTouchUpInside];
    
    return emptyStateView;
}

#pragma mark - Empty State

- (NSString *)titleForEmptyState {
    NSString *text = @"";
    if (![MEGAReachabilityManager isReachable]) {
        text = NSLocalizedString(@"noInternetConnection",  @"Text shown on the app when you don't have connection to the internet or when you have lost it");
    }
    
    return text;
}

- (NSString *)descriptionForEmptyState {
    NSString *text = @"";
    if (!MEGAReachabilityManager.isReachable && !MEGAReachabilityManager.sharedManager.isMobileDataEnabled) {
        text = NSLocalizedString(@"Mobile Data is turned off", @"Information shown when the user has disabled the 'Mobile Data' setting for MEGA in the iOS Settings.");
    }
    
    return text;
}

- (UIImage *)imageForEmptyState {
    if (![MEGAReachabilityManager isReachable]) {
        return [UIImage imageNamed:@"noInternetEmptyState"];
    }
    
    return nil;
}

- (NSString *)buttonTitleForEmptyState {
    NSString *text = @"";
    if (!MEGAReachabilityManager.isReachable && !MEGAReachabilityManager.sharedManager.isMobileDataEnabled) {
        text = NSLocalizedString(@"Turn Mobile Data on", @"Button title to go to the iOS Settings to enable 'Mobile Data' for the MEGA app.");
    }
    
    return text;
}

- (void)buttonTouchUpInsideEmptyState {
    if (!MEGAReachabilityManager.isReachable && !MEGAReachabilityManager.sharedManager.isMobileDataEnabled) {
        [UIApplication.sharedApplication openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    }
}

#pragma mark - MEGAChatDelegate

- (void)onChatPresenceConfigUpdate:(MEGAChatSdk *)api presenceConfig:(MEGAChatPresenceConfig *)presenceConfig {
    if (presenceConfig.isPending) {
        return;
    }
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD dismiss];
    
    self.presenceConfig = presenceConfig;
    
    [self updateUIWithPresenceConfig];
}

@end
