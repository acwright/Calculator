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
        [self setOperation:CashRegisterCalculatorOperationNone];
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

# pragma mark - Actions

- (void)input:(NSString *)value {
    if ([[[self class] operations] containsObject:value]) {
        if ([value isEqualToString:@"Clear"]) {
            [self clear];
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
            [self calculate];
        }
    } else if ([[[self class] operands] containsObject:value]) {
        [self concatenate:value];
    } else {
        NSLog(@"Invalid Input: %@", value);
    }
}

- (void)clear {
    [self _clearAll];
}

- (void)invert {
    [self _invert];
}

- (void)percent {
    [self _percent];
}

- (void)divide {
    [self _calculate];
    [self setOperation:CashRegisterCalculatorOperationDivide];
    [self setStringAmount:nil];
}

- (void)multiply {
    [self _calculate];
    [self setOperation:CashRegisterCalculatorOperationMultiply];
    [self setStringAmount:nil];
}

- (void)add {
    [self _calculate];
    [self setOperation:CashRegisterCalculatorOperationAdd];
    [self setStringAmount:nil];
}

- (void)subtract {
    [self _calculate];
    [self setOperation:CashRegisterCalculatorOperationSubtract];
    [self setStringAmount:nil];
}

- (void)calculate {
    [self _shift];
    [self _calculate];
    [self setStringAmount:nil];
}

- (void)concatenate:(NSString *)value {
    if ([value isEqualToString:@"."] && [self.stringAmount containsString:@"."]) {
        return;
    }
    
    if (self.stringAmount != nil) {
        [self setStringAmount:[self.stringAmount stringByAppendingString:value]];
    } else {
        [self _shift];
        [self setStringAmount:value];
    }
    
    NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithString:self.stringAmount];
    
    [self setXAmount:amount];
}

# pragma mark - Operations

- (void)_calculate {
    switch (self.operation) {
        case CashRegisterCalculatorOperationDivide:
            [self _divide];
            break;
        case CashRegisterCalculatorOperationMultiply:
            [self _multiply];
            break;
        case CashRegisterCalculatorOperationAdd:
            [self _add];
            break;
        case CashRegisterCalculatorOperationSubtract:
            [self _subtract];
            break;
        case CashRegisterCalculatorOperationNone:
            break;
        default:
            break;
    }
}

- (void)_shift {
    [self setYAmount:self.xAmount];
}

- (void)_clear {
    [self setXAmount:[[NSDecimalNumber alloc] initWithInteger:0]];
    [self setStringAmount:nil];
}

- (void)_clearAll {
    [self setOperation:CashRegisterCalculatorOperationNone];
    [self setXAmount:[[NSDecimalNumber alloc] initWithInteger:0]];
    [self setYAmount:[[NSDecimalNumber alloc] initWithInteger:0]];
    [self setStringAmount:nil];
}

- (void)_invert {
    NSDecimalNumber *xAmount = self.xAmount;
    NSDecimalNumber *multiplier = [[NSDecimalNumber alloc] initWithInteger:-1];
    NSDecimalNumber *amount = [xAmount decimalNumberByMultiplyingBy:multiplier];
    
    [self setXAmount:amount];
}

- (void)_percent {
    NSDecimalNumber *xAmount = self.xAmount;
    NSDecimalNumber *multiplier = [[NSDecimalNumber alloc] initWithDouble:0.01];
    NSDecimalNumber *amount = [xAmount decimalNumberByMultiplyingBy:multiplier];
    
    [self setXAmount:amount];
}

- (void)_divide {
    NSDecimalNumber *xAmount = self.xAmount;
    NSDecimalNumber *yAmount = self.yAmount;
    NSDecimalNumber *calculatedAmount = [yAmount decimalNumberByDividingBy:xAmount];
    
    [self setXAmount:calculatedAmount];
}

- (void)_multiply {
    NSDecimalNumber *xAmount = self.xAmount;
    NSDecimalNumber *yAmount = self.yAmount;
    NSDecimalNumber *calculatedAmount = [yAmount decimalNumberByMultiplyingBy:xAmount];
    
    [self setXAmount:calculatedAmount];
}

- (void)_add {
    NSDecimalNumber *xAmount = self.xAmount;
    NSDecimalNumber *yAmount = self.yAmount;
    NSDecimalNumber *calculatedAmount = [yAmount decimalNumberByAdding:xAmount];
    
    [self setXAmount:calculatedAmount];
}

- (void)_subtract {
    NSDecimalNumber *xAmount = self.xAmount;
    NSDecimalNumber *yAmount = self.yAmount;
    NSDecimalNumber *calculatedAmount = [yAmount decimalNumberBySubtracting:xAmount];
    
    [self setXAmount:calculatedAmount];
}

- (void)debug:(NSString *)message {
    NSLog(@"%@ - X: %@, Y: %@, A: %@", message, @([self.xAmount doubleValue]), @([self.xAmount doubleValue]), @([self.amount doubleValue]));
}

@end
