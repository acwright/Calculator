//
//  Calculator.h
//  CashierFu
//
//  Created by A.C. Wright Design on 3/26/17.
//  Copyright © 2017 A.C. Wright Design. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    CashRegisterCalculatorOperationNone,
    CashRegisterCalculatorOperationDivide,
    CashRegisterCalculatorOperationMultiply,
    CashRegisterCalculatorOperationAdd,
    CashRegisterCalculatorOperationSubtract,
    CashRegisterCalculatorOperationEqual,
} CashRegisterCalculatorOperation;

@interface Calculator : NSObject

@property (nonatomic, strong) NSDecimalNumber *xAmount;
@property (nonatomic, strong) NSDecimalNumber *yAmount;
@property (nonatomic, readonly) NSDecimalNumber *amount;
@property (nonatomic, readonly) NSString *clearLabel;
@property (nonatomic, strong) NSString *stringAmount;
@property (nonatomic, assign) CashRegisterCalculatorOperation previousOperation;
@property (nonatomic, assign) CashRegisterCalculatorOperation currentOperation;

- (void)input:(NSString *)value;
- (void)concatenate:(NSString *)value;

- (void)clear;
- (void)clearAll;
- (void)invert;
- (void)percent;
- (void)divide;
- (void)multiply;
- (void)add;
- (void)subtract;
- (void)calculate:(CashRegisterCalculatorOperation)operation shift:(BOOL)shift;

@end
