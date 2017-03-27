//
//  Calculator.m
//  CashierFu
//
//  Created by A.C. Wright Design on 3/26/17.
//  Copyright © 2017 A.C. Wright Design. All rights reserved.
//

#import "Calculator.h"

@implementation Calculator

# pragma mark - Class Methods

+ (NSArray<NSString *> *)operations {
    return @[@"Clear", @"Invert", @"Percent", @"Divide", @"Multiply", @"Subtract", @"Add", @"Equal"];
}

+ (NSArray<NSString *> *)operands {
    return @[@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"."];
}

# pragma mark - Lifecycle

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setXAmount:[[NSDecimalNumber alloc] initWithInteger:0]];
        [self setYAmount:[[NSDecimalNumber alloc] initWithInteger:0]];
        [self setStringAmount:nil];
        [self setPreviousOperation:CashRegisterCalculatorOperationNone];
        [self setCurrentOperation:CashRegisterCalculatorOperationNone];
    }
    return self;
}

# pragma mark - Properties

- (NSString *)clearLabel {
    return @"AC";
}

- (NSDecimalNumber *)amount {
    return self.xAmount;
}

# pragma mark - Methods

- (void)input:(NSString *)value {
    if ([[[self class] operations] containsObject:value]) {
        if ([value isEqualToString:@"Clear"]) {
            [self clearAll];
        } else if ([value isEqualToString:@"Invert"]) {
            [self invert];
        } else if ([value isEqualToString:@"Percent"]) {
            [self percent];
        } else if ([value isEqualToString:@"Divide"]) {
            [self divide];
        } else if ([value isEqualToString:@"Multiply"]) {
            [self multiply];
        } else if ([value isEqualToString:@"Subtract"]) {
            [self subtract];
        } else if ([value isEqualToString:@"Add"]) {
            [self add];
        } else if ([value isEqualToString:@"Equal"]) {
            [self equal];
        }
    } else if ([[[self class] operands] containsObject:value]) {
        [self concatenate:value];
    } else {
        NSLog(@"Invalid Input: %@", value);
    }
}

- (void)concatenate:(NSString *)value {
    if ([value isEqualToString:@"."] && [self.stringAmount containsString:@"."]) {
        return;
    }
    
    if (self.stringAmount != nil) {
        [self setStringAmount:[self.stringAmount stringByAppendingString:value]];
    } else {
        [self shift];
        [self setStringAmount:value];
    }
    
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:self.stringAmount];
    
    [self setXAmount:amount];
}

- (void)clear {
    [self setXAmount:[[NSDecimalNumber alloc] initWithInteger:0]];
    [self setStringAmount:nil];
}

- (void)clearAll {
    [self setPreviousOperation:CashRegisterCalculatorOperationNone];
    [self setCurrentOperation:CashRegisterCalculatorOperationNone];
    [self setXAmount:[[NSDecimalNumber alloc] initWithInteger:0]];
    [self setYAmount:[[NSDecimalNumber alloc] initWithInteger:0]];
    [self setStringAmount:nil];
}

- (void)invert {
    NSDecimalNumber *xAmount = self.xAmount;
    NSDecimalNumber *multiplier = [[NSDecimalNumber alloc] initWithInteger:-1];
    NSDecimalNumber *amount = [xAmount decimalNumberByMultiplyingBy:multiplier];
    
    [self setXAmount:amount];
}

- (void)percent {
    NSDecimalNumber *xAmount = self.xAmount;
    NSDecimalNumber *multiplier = [[NSDecimalNumber alloc] initWithDouble:0.01];
    NSDecimalNumber *amount = [xAmount decimalNumberByMultiplyingBy:multiplier];
    
    [self setXAmount:amount];
}

- (void)divide {
    if (self.stringAmount != nil) [self calculate:self.currentOperation shift:YES];
    [self setCurrentOperation:CashRegisterCalculatorOperationDivide];
}

- (void)multiply {
    if (self.stringAmount != nil) [self calculate:self.currentOperation shift:YES];
    [self setCurrentOperation:CashRegisterCalculatorOperationMultiply];
}

- (void)add {
    if (self.stringAmount != nil) [self calculate:self.currentOperation shift:YES];
    [self setCurrentOperation:CashRegisterCalculatorOperationAdd];
}

- (void)subtract {
    if (self.stringAmount != nil) [self calculate:self.currentOperation shift:YES];
    [self setCurrentOperation:CashRegisterCalculatorOperationSubtract];
}

- (void)equal {
    if (self.currentOperation != CashRegisterCalculatorOperationEqual) {
        [self calculate:self.currentOperation shift:YES];
        [self setCurrentOperation:CashRegisterCalculatorOperationEqual];
    } else {
        [self calculate:self.previousOperation shift:NO];
    }
}

- (void)calculate:(CashRegisterCalculatorOperation)operation shift:(BOOL)shift {
    NSDecimalNumber *xAmount = self.xAmount;
    NSDecimalNumber *yAmount = self.yAmount;
    NSDecimalNumber *calculatedAmount;
    
    switch (operation) {
        case CashRegisterCalculatorOperationDivide:
            if ([self.xAmount doubleValue] != 0) {
                calculatedAmount = [yAmount decimalNumberByDividingBy:xAmount];
                if (shift) [self shift];
                [self setXAmount:calculatedAmount];
            }
            break;
        case CashRegisterCalculatorOperationMultiply:
            calculatedAmount = [yAmount decimalNumberByMultiplyingBy:xAmount];
            if (shift) [self shift];
            [self setXAmount:calculatedAmount];
            break;
        case CashRegisterCalculatorOperationAdd:
            calculatedAmount = [yAmount decimalNumberByAdding:xAmount];
            if (shift) [self shift];
            [self setXAmount:calculatedAmount];
            break;
        case CashRegisterCalculatorOperationSubtract:
            calculatedAmount = [yAmount decimalNumberBySubtracting:xAmount];
            if (shift) [self shift];
            [self setXAmount:calculatedAmount];
            break;
        case CashRegisterCalculatorOperationNone:
            [self shift];
            break;
        default:
            break;
    }
    
    if (shift) [self setPreviousOperation:self.currentOperation];
    
    [self setStringAmount:nil];
}

- (void)shift {
    [self setYAmount:self.xAmount];
}

@end
