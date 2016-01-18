//
//  PurchaseViewController.m
//  CurrencyExchange
//
//  Created by Senthil Kumar T.S on 1/18/16.
//  Copyright © 2016 Senthil Kumar T.S. All rights reserved.
//

#import "PurchaseViewController.h"
#import "CurrencyRequest.h"
#import "Reachability.h"
#import "Currency.h"

@interface PurchaseViewController () <CurrencyRequestDelegate, UIPickerViewDataSource> {
    
    // Holds the modal of currency.
    NSArray *_currencies;
    
    // Holds the currency name from Plist.
    NSArray *_currenciesToLoad;
}
@property (weak, nonatomic) IBOutlet UIView *pickerView;
@property (weak, nonatomic) IBOutlet UIPickerView *currencyPicker;

@property (weak, nonatomic) IBOutlet UILabel *totalPurchased;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoader;

@property (weak, nonatomic) IBOutlet UIButton *selectedCurrency;

@property (weak, nonatomic) IBOutlet UILabel *milkCount;
@property (weak, nonatomic) IBOutlet UILabel *eggCount;
@property (weak, nonatomic) IBOutlet UILabel *peasCount;
@property (weak, nonatomic) IBOutlet UILabel *beansCount;

@end

NSString *kPounds = @"GBP";
@implementation PurchaseViewController

+(instancetype)purchaseViewController {
    
    PurchaseViewController *purchaseViewController = [[PurchaseViewController alloc] initWithNibName:@"PurchaseViewController" bundle:[NSBundle mainBundle]];
    
    return purchaseViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *refresh = [[UIBarButtonItem alloc] initWithTitle:@"RefreshData" style:UIBarButtonItemStylePlain target:self action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = refresh;
    
    [self setCurrencyName];
    [self getCurrenciesWith:kPounds];
}

#pragma UIPickerViewDataSource

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _currenciesToLoad.count;
}

#pragma UIPickerViewDelegate

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
//    Currency *currency = _currencies[row];
    return _currenciesToLoad[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    // Read plist from bundle and get Root Dictionary out of it
    NSDictionary *currencyDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"]];
    
    if (![kPounds isEqualToString:currencyDictionary.allKeys[row]]) {
        
        Currency *currency = [_currencies filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"currencyCode = %@", currencyDictionary.allKeys[row]]].lastObject;
        float total = currency.currencyRate.floatValue * ((_eggCount.text.floatValue * 2.10) + (_milkCount.text.floatValue * 1.30) + (_peasCount.text.floatValue * 95.0) + (_beansCount.text.floatValue * 73.0));
        _totalPurchased.text = [NSString stringWithFormat:@"Total Purchased: %f %@", total, currencyDictionary.allKeys[row]];
    } else {
        
        _totalPurchased.text = [NSString stringWithFormat:@"Total Purchased: %f %@", ((_eggCount.text.floatValue * 2.10) + (_milkCount.text.floatValue * 1.30) + (_peasCount.text.floatValue * 95.0) + (_beansCount.text.floatValue * 73.0)), currencyDictionary.allKeys[row]];
    }
}

#pragma Local Methods

- (void)refresh:(id)sender {
    
    [_activityLoader startAnimating];
    [self getCurrenciesWith:kPounds];
}

- (void)setCurrencyName {
    
    // Read plist from bundle and get Root Dictionary out of it
    NSDictionary *currencyDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Currency" ofType:@"plist"]];
    _currenciesToLoad = currencyDictionary.allValues;
    [_currencyPicker reloadAllComponents];
}

// Show alert view with title and message.
- (void)setAlert:(NSString *)title withMessage:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

// Method to invoke the Fixer webservice with Pound currency code.
- (void)getCurrenciesWith:(NSString *)currencyCode {
    
    if([[Reachability sharedReachability]internetConnectionStatus] != NotReachable) {
        
        CurrencyRequest *currencyRequest = [[CurrencyRequest alloc] initWithDelegate:self andCurrencyCode:currencyCode];
        [currencyRequest startRequest];
    } else {
        
        [_activityLoader stopAnimating];
        [self setAlert:@"Error" withMessage:@"Internet Connection Failed!"];
    }
}

// Increments or decrements the purchased item.
- (void)basketItemsWith:(BOOL)isAdd andItemSelected:(NSInteger)itemTag {
    
    switch (itemTag) {
        case 1:
            _milkCount.text = isAdd ? [NSString stringWithFormat:@"%d", _milkCount.text.intValue + 1] : [NSString stringWithFormat:@"%d", _milkCount.text.intValue - 1 <= 0 ? 0 : _milkCount.text.intValue - 1];
            break;
        case 2:
            _eggCount.text = isAdd ? [NSString stringWithFormat:@"%d", _eggCount.text.intValue + 1] : [NSString stringWithFormat:@"%d", _eggCount.text.intValue - 1 <= 0 ? 0 : _eggCount.text.intValue - 1];
            break;
        case 3:
            _peasCount.text = isAdd ? [NSString stringWithFormat:@"%d", _peasCount.text.intValue + 1] : [NSString stringWithFormat:@"%d", _peasCount.text.intValue - 1 <= 0 ? 0 : _peasCount.text.intValue - 1];
            break;
        case 4:
            _beansCount.text = isAdd ? [NSString stringWithFormat:@"%d", _beansCount.text.intValue + 1] : [NSString stringWithFormat:@"%d", _beansCount.text.intValue - 1 <= 0 ? 0 : _beansCount.text.intValue - 1];
            break;
            
        default:
            
            _eggCount.text = @"0";
            _milkCount.text = @"0";
            _peasCount.text = @"0";
            _beansCount.text = @"0";
            _totalPurchased.text = @"";
            break;
    }
}

#pragma IBAction Methods

// Invoked via UI to add the item in the basket.
- (IBAction)AddItem:(UIButton *)sender {
    
    [self basketItemsWith:YES andItemSelected:sender.tag];
}

// Invoked via UI to remove the item from the basket.
- (IBAction)DecreaseItem:(UIButton *)sender {
    
    [self basketItemsWith:NO andItemSelected:sender.tag];
}

- (IBAction)DismissPicker:(id)sender {
    
    _pickerView.hidden = !_pickerView.isHidden;
}

// Invoked via UI to Calculate the total amount of items purchased.
- (IBAction)CheckOut:(id)sender {
    
    _pickerView.hidden = !_pickerView.isHidden;
}

// Invoked via UI to select the currency.
- (IBAction)SelectCurrency:(id)sender {
    
    [_activityLoader stopAnimating];
}

// Invoked via UI to remove all the items from the basket.
- (IBAction)ResetAllItems:(UIButton *)sender {
    
    [self basketItemsWith:NO andItemSelected:sender.tag];
}

#pragma CurrencyRequestDelegate Methods

- (void)currencyRequestSucceded:(CurrencyRequest *)currencyRequest {
    
    [_activityLoader stopAnimating];
    _currencies = currencyRequest.currencies;
}

- (void)currencyRequestFailed:(CurrencyRequest *)currencyRequest withError:(NSString *)error {
    
    [_activityLoader stopAnimating];
    [self setAlert:@"Error" withMessage:error];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
