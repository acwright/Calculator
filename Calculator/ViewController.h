//
//  ViewController.h
//  Calculator
//
//  Created by A.C. Wright Design on 3/26/17.
//  Copyright © 2017 A.C. Wright Design. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Calculator;

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *amountLabel;
@property (nonatomic, weak) IBOutlet UILabel *xLabel;
@property (nonatomic, weak) IBOutlet UILabel *yLabel;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;

@property (nonatomic, strong) Calculator *calculator;

- (IBAction)input:(id)sender;

@end
