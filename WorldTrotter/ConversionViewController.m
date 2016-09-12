//
//  ViewController.m
//  WorldTrotter
//
//  Created by Rodney Sampson on 9/11/16.
//  Copyright © 2016 Rodney Sampson II. All rights reserved.
//

#import "ConversionViewController.h"

@interface ConversionViewController () <UITextFieldDelegate>

@property (nonatomic) IBOutlet UILabel *celsiusLabel;
@property (nonatomic) IBOutlet UITextField *fahrenheitField;
@property (nonatomic) double fahrenheitValue;
@property (nonatomic) double celsiusValue;

@end

@implementation ConversionViewController

// MARK: - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"MapViewController loaded its view.");
}

- (void)setFahrenheitValue:(double)fahrenheitValue {
    _fahrenheitValue = fahrenheitValue;
    [self updateCelsiusLabel];
}

- (void)setCelsiusValue:(double)celsiusValue {
    self.fahrenheitValue = celsiusValue * (9.0/5.0) + 32;
}

- (double)celsiusValue {
    return (self.fahrenheitValue - 32) * (5.0/9.0);
}

- (void)updateCelsiusLabel {
    self.celsiusLabel.text = [self.numberFormatter stringFromNumber:@(self.celsiusValue)];
}

- (IBAction)fahrenheitFieldEditingChanged:(UITextField *)textField {
    NSNumber *num = [self.numberFormatter numberFromString:textField.text];
    if (num != nil) {
        self.fahrenheitValue = num.doubleValue;
    } else {
        self.celsiusLabel.text = @"???";
    }
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.fahrenheitField resignFirstResponder];
}

- (NSNumberFormatter *)numberFormatter {
    static NSNumberFormatter *formatter = nil;
    if (formatter == nil) {
        formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = 1;
    }
    return formatter;
}

// MARK: - Text Field Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *validChars = [NSCharacterSet characterSetWithCharactersInString:@"0123456789.,"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if (![validChars characterIsMember:c]) {
            return NO;
        }
    }
    
    NSRange existingRange = [textField.text rangeOfString:NSLocaleDecimalSeparator];
    BOOL hasExistingDecimalSeparator = (existingRange.location != NSNotFound);
    NSRange newRange = [string rangeOfString:NSLocaleDecimalSeparator];
    BOOL wantsNewDecimalSeparator = (newRange.location != NSNotFound);
    if (hasExistingDecimalSeparator && wantsNewDecimalSeparator) {
        return NO;
    } else {
        return YES;
    }
}

@end
