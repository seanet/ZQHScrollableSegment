//
//  UIView+ForwardMessage.m
//  lingmiapp
//
//  Created by lmwl123 on 12/21/14.
//  Copyright (c) 2014 LingMi. All rights reserved.
//

#import "UIView+ForwardMessage.h"
#import <objc/runtime.h>

#define SELECTORNAME_IDENTIFIER @"selectorNameIdentifier"
#define VIEWCONTROLLER_IDENTIFIER @"viewControllerIdentifier"

@implementation UIView (ForwardMessage)

-(id)viewController{
    return (id)objc_getAssociatedObject(self, (__bridge const void *)VIEWCONTROLLER_IDENTIFIER);
}

-(void)setViewController:(id)viewController{
    objc_setAssociatedObject(self, (__bridge const void *)VIEWCONTROLLER_IDENTIFIER, viewController, OBJC_ASSOCIATION_ASSIGN);
}

-(NSString *)selectorName{
    return (NSString *)objc_getAssociatedObject(self, (__bridge const void *)SELECTORNAME_IDENTIFIER);
}

-(void)setSelectorName:(NSString *)selectorName{
    objc_setAssociatedObject(self, (__bridge const void *)SELECTORNAME_IDENTIFIER, selectorName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)triggerForwardMessage:(id)obj1,...{
    if(!self.selectorName||!self.viewController) return;
    
    SEL selecor=NSSelectorFromString(self.selectorName);
    NSMethodSignature *sig=[[self.viewController class]instanceMethodSignatureForSelector:selecor];
    NSInvocation *invocation=[NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:self.viewController];
    [invocation setSelector:selecor];
    
    id obj=obj1;
    va_list argumentList;
    va_start(argumentList, obj1);
    
    NSInteger index=2;
    while (![obj isEqual:FM_END_FLAG]) {
        [invocation setArgument:&obj atIndex:index];
        obj=va_arg(argumentList, id);
        index++;
    }
    va_end(argumentList);
    
    [invocation retainArguments];
    [invocation invoke];
}

@end
