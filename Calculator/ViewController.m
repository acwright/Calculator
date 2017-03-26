//
//  ViewController.m
//  Calculator
//
//  Created by A.C. Wright Design on 3/26/17.
//  Copyright © 2017 A.C. Wright Design. All rights reserved.
//

#import "ViewController.h"
#import "Calculator.h"

@implementation ViewController

# pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setCalculator:[[Calculator alloc] init]];
    
    [self update];
}

# pragma mark - Actions

- (void)input:(id)sender {
    [self.calculator input:[sender valueForKeyPath:@"identifier"]];
    [self update];
}

# pragma mark - Methods

- (void)update {
    NSDecimalNumber *amount = [self.calculator amount];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMinimumFractionDigits:0];
    [formatter setMaximumFractionDigits:10];
    
    [self.amountLabel setText:[formatter stringFromNumber:amount]];
    [self.clearButton setTitle:[self.calculator clearLabel] forState:UIControlStateNormal];
}

@end
