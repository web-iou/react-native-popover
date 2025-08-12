//
//  RCTNativePopover.m
//  TSun_App
//
//  Created by cc on 2025/3/21.
//

#import <React/RCTUIManager.h>
#import <React/RCTViewManager.h>
#import <React/RCTBridge.h>
#import <React/RCTRootView.h>
#import <objc/runtime.h>
#import "Popover.h"
// 配置默认值结构
@interface ConfigDefaults : NSObject
@property (nonatomic, assign) CGFloat menuWidth;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) CGFloat menuCornerRadius;
@property (nonatomic, assign) CGFloat checkIconSize;
@property (nonatomic, strong) NSString *textColor;
@property (nonatomic, strong) NSString *backgroundColor;
@property (nonatomic, strong) NSString *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) UIEdgeInsets padding;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) NSInteger fontWeight;
@property (nonatomic, strong) NSString *textAlignment;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic, strong) NSString *selectedTextColor;
@property (nonatomic, strong) NSString *separatorColor;
@property (nonatomic, strong) NSString *shadowColor;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGFloat shadowOffsetX;
@property (nonatomic, assign) CGFloat shadowOffsetY;
@end


@implementation ConfigDefaults
- (instancetype)init {
    self = [super init];
    if (self) {
        // 设置默认值
        _menuWidth = 158;
        _menuCornerRadius = 8;
        _textColor = @"#262626";
        _backgroundColor = @"#FFFFFF";
        _borderColor = @"#E5E5E5";
        _checkIconSize=16;
        _borderWidth = 0;
        _padding = UIEdgeInsetsMake(0, 16, 0, 16);
        _fontSize = 15;
        _fontWeight = 500;
        _textAlignment = @"left";
        _animationDuration = 0.2;
        _selectedTextColor = @"#FF891F";
        _separatorColor = @"#E5E5E5";
        _shadowColor = @"#000000";
        _shadowOpacity = 0.25;  // 增加到25%透明度
        _shadowRadius = 8;      // 增加到8点半径
        _shadowOffsetX = 0;
        _shadowOffsetY = 4;     // 增加到4点偏移
        _rowHeight=48;
    }
    return self;
}
@end

@implementation Popover
RCT_EXPORT_MODULE()
NSDictionary<NSNumber *, NSNumber *> *cssToUIFontWeight = @{
    @100: @(UIFontWeightUltraLight),
    @200: @(UIFontWeightThin),
    @300: @(UIFontWeightLight),
    @400: @(UIFontWeightRegular),
    @500: @(UIFontWeightMedium),
    @600: @(UIFontWeightSemibold),
    @700: @(UIFontWeightBold),
    @800: @(UIFontWeightHeavy),
    @900: @(UIFontWeightBlack)
};
- (UIColor *)ColorFromHexCode:(NSString *)hexString{
  NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
  if([cleanString length] == 3) {
      cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                     [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                     [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                     [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
  }
  if([cleanString length] == 6) {
      cleanString = [cleanString stringByAppendingString:@"ff"];
  }
  
  unsigned int baseValue;
  [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
  
  float red = ((baseValue >> 24) & 0xFF)/255.0f;
  float green = ((baseValue >> 16) & 0xFF)/255.0f;
  float blue = ((baseValue >> 8) & 0xFF)/255.0f;
  float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
  
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativePopoverSpecJSI>(params);}


// 安全读取配置值的方法
- (NSString *)getSafeString:(NSDictionary *)config forKey:(NSString *)key {
    if (config && config[key] && [config[key] isKindOfClass:[NSString class]]) {
        return config[key];
    }
    return nil;
}

- (NSNumber *)getSafeNumber:(NSDictionary *)config forKey:(NSString *)key {
    if (config && config[key] && [config[key] isKindOfClass:[NSNumber class]]) {
        return config[key];
    }
    return nil;
}

- (BOOL)getSafeBool:(NSDictionary *)config forKey:(NSString *)key {
    if (config && config[key] && [config[key] isKindOfClass:[NSNumber class]]) {
        return [config[key] boolValue];
    }
    return NO;
}

- (NSDictionary *)getSafeDictionary:(NSDictionary *)config forKey:(NSString *)key {
    if (config && config[key] && [config[key] isKindOfClass:[NSDictionary class]]) {
        return config[key];
    }
    return nil;
}

// 获取配置默认值
- (ConfigDefaults *)getConfigWithDefaults:(NSDictionary *)config {
    ConfigDefaults *defaults = [[ConfigDefaults alloc] init];
    
    if (config) {
        // 读取配置值，如果不存在则使用默认值
        NSNumber *menuWidth = [self getSafeNumber:config forKey:@"menuWidth"];
        if (menuWidth) defaults.menuWidth = [menuWidth floatValue];
        NSNumber *checkIconSize = [self getSafeNumber:config forKey:@"checkIconSize"];
        if (checkIconSize) defaults.checkIconSize = [checkIconSize floatValue];
        
        NSNumber *menuCornerRadius = [self getSafeNumber:config forKey:@"menuCornerRadius"];
        if (menuCornerRadius) defaults.menuCornerRadius = [menuCornerRadius floatValue];
        
        NSString *textColor = [self getSafeString:config forKey:@"textColor"];
        if (textColor) defaults.textColor = textColor;
        
        NSString *backgroundColor = [self getSafeString:config forKey:@"backgroundColor"];
        if (backgroundColor) defaults.backgroundColor = backgroundColor;
        
        NSString *borderColor = [self getSafeString:config forKey:@"borderColor"];
        if (borderColor) defaults.borderColor = borderColor;
        NSNumber *rowHeight = [self getSafeNumber:config forKey:@"rowHeight"];
        if (rowHeight) defaults.rowHeight = [rowHeight floatValue];
        NSNumber *borderWidth = [self getSafeNumber:config forKey:@"borderWidth"];
        if (borderWidth) defaults.borderWidth = [borderWidth floatValue];
        
        // 处理padding
        NSDictionary *paddingDict = [self getSafeDictionary:config forKey:@"padding"];
        if (paddingDict) {
            NSNumber *top = [self getSafeNumber:paddingDict forKey:@"top"];
            NSNumber *left = [self getSafeNumber:paddingDict forKey:@"left"];
            NSNumber *bottom = [self getSafeNumber:paddingDict forKey:@"bottom"];
            NSNumber *right = [self getSafeNumber:paddingDict forKey:@"right"];
            
            defaults.padding = UIEdgeInsetsMake(
                top ? [top floatValue] : 0,
                left ? [left floatValue] : 16,
                bottom ? [bottom floatValue] : 0,
                right ? [right floatValue] : 16
            );
        }
        
        // 处理字体配置
        NSDictionary *textFontDict = [self getSafeDictionary:config forKey:@"textFont"];
        if (textFontDict) {
            NSNumber *fontSize = [self getSafeNumber:textFontDict forKey:@"fontSize"];
            if (fontSize) defaults.fontSize = [fontSize floatValue];
            
            NSNumber *fontWeight = [self getSafeNumber:textFontDict forKey:@"fontWeight"];
            if (fontWeight) defaults.fontWeight = [fontWeight integerValue];
        }
        
        NSString *textAlignment = [self getSafeString:config forKey:@"textAlignment"];
        if (textAlignment) defaults.textAlignment = textAlignment;
        

        
        NSNumber *animationDuration = [self getSafeNumber:config forKey:@"animationDuration"];
        if (animationDuration) defaults.animationDuration = [animationDuration floatValue];
        
        NSString *selectedTextColor = [self getSafeString:config forKey:@"selectedTextColor"];
        if (selectedTextColor) defaults.selectedTextColor = selectedTextColor;
        
        NSString *separatorColor = [self getSafeString:config forKey:@"separatorColor"];
        if (separatorColor) defaults.separatorColor = separatorColor;
        
        NSString *shadowColor = [self getSafeString:config forKey:@"shadowColor"];
        if (shadowColor) defaults.shadowColor = shadowColor;
        
        NSNumber *shadowOpacity = [self getSafeNumber:config forKey:@"shadowOpacity"];
        if (shadowOpacity) defaults.shadowOpacity = [shadowOpacity floatValue];
        
        NSNumber *shadowRadius = [self getSafeNumber:config forKey:@"shadowRadius"];
        if (shadowRadius) defaults.shadowRadius = [shadowRadius floatValue];
        
        NSNumber *shadowOffsetX = [self getSafeNumber:config forKey:@"shadowOffsetX"];
        if (shadowOffsetX) defaults.shadowOffsetX = [shadowOffsetX floatValue];
        
        NSNumber *shadowOffsetY = [self getSafeNumber:config forKey:@"shadowOffsetY"];
        if (shadowOffsetY) defaults.shadowOffsetY = [shadowOffsetY floatValue];
    }
    
    return defaults;
}

// 根据React Native tag获取视图
- (UIView *)getViewWithTag:(double)tag {
    @try {
        // 获取React Native的UIManager
        RCTUIManager *uiManager = [self.bridge.uiManager valueForKey:@"_uiManager"];
        if (!uiManager) {
            NSLog(@"Failed to get UIManager");
            return nil;
        }
        
        // 尝试获取视图
        UIView *view = [uiManager viewForReactTag:@(tag)];
        if (view) {
            NSLog(@"Successfully found view with tag %f", tag);
        } else {
            NSLog(@"Failed to find view with tag %f", tag);
        }
        return view;
    } @catch (NSException *exception) {
        NSLog(@"Error getting view with tag %f: %@", tag, exception.reason);
        return nil;
    }
}

// 创建勾选图标
- (UIImage *)createCheckIconWithSize:(CGSize)size color:(NSString *)colorString {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color = [self ColorFromHexCode:colorString];
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 2.0);
    
    // 绘制勾选符号
    CGContextMoveToPoint(context, size.width * 0.2, size.height * 0.5);
    CGContextAddLineToPoint(context, size.width * 0.4, size.height * 0.7);
    CGContextAddLineToPoint(context, size.width * 0.8, size.height * 0.3);
    
    CGContextStrokePath(context);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)show:(double)anchorViewId menuItems:(NSArray *)menuItems index:(NSNumber*)index config:(JS::NativePopover::PopOverMenuConfiguration &)config resolve:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject {
    
    // 获取配置默认值
    NSMutableDictionary *configDict = [NSMutableDictionary dictionary];
    
    // 安全地访问配置值
    configDict[@"menuWidth"] = @(config.menuWidth());
    
    if (config.menuCornerRadius().has_value()) {
      configDict[@"menuCornerRadius"] = @(config.menuCornerRadius().value());
    }
    
    // 字符串类型直接访问
    if (config.textColor()) {
        configDict[@"textColor"] = config.textColor();
    }
    
    if (config.backgroundColor()) {
        configDict[@"backgroundColor"] = config.backgroundColor();
    }
    
    if (config.borderColor()) {
        configDict[@"borderColor"] = config.borderColor();
    }
    
    if (config.borderWidth().has_value()) {
      configDict[@"borderWidth"] = @(config.borderWidth().value());
    }
    if (config.checkIconSize().has_value()) {
      configDict[@"checkIconSize"] = @(config.checkIconSize().value());
    }
    // padding是对象类型
    if (config.padding()) {
      configDict[@"padding"] = @{
        @"top":@(config.padding().value().top().value()),
        @"left":@(config.padding().value().left().value()),
        @"bottom":@(config.padding().value().bottom().value()),
        @"right":@(config.padding().value().right().value()),
      };
    }
    
    if (config.textFont().has_value()) {
        configDict[@"textFont"] = @{
          @"fontSize": @(config.textFont().value().fontSize().value()),
          @"fontWeight": @(config.textFont().value().fontWeight().value())
        };
    }
//    
    if (config.textAlignment()) {
        configDict[@"textAlignment"] = config.textAlignment();
    }
    if (config.rowHeight()) {
      configDict[@"rowHeight"] = @(config.rowHeight().value());
    }
  
    if (config.animationDuration().has_value()) {
        configDict[@"animationDuration"] = @(config.animationDuration().value());
    }
    
    if (config.selectedTextColor()) {
        configDict[@"selectedTextColor"] = config.selectedTextColor();
    }
    
    if (config.separatorColor()) {
        configDict[@"separatorColor"] = config.separatorColor();
    }
    
    if (config.shadowColor()) {
        configDict[@"shadowColor"] = config.shadowColor();
    }
    
    if (config.shadowOpacity().has_value()) {
        configDict[@"shadowOpacity"] = @(config.shadowOpacity().value());
    }
    
    if (config.shadowRadius().has_value()) {
        configDict[@"shadowRadius"] = @(config.shadowRadius().value());
    }
    
    if (config.shadowOffsetX().has_value()) {
        configDict[@"shadowOffsetX"] = @(config.shadowOffsetX().value());
    }
    
    if (config.shadowOffsetY().has_value()) {
        configDict[@"shadowOffsetY"] = @(config.shadowOffsetY().value());
    }
    
    ConfigDefaults *defaults = [self getConfigWithDefaults:configDict];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 获取根视图控制器
      UIViewController *rootVC = RCTPresentedViewController();
      if (!rootVC) {
            reject(@"E_NO_ROOT_VC", @"Cannot find root view controller", nil);
            return;
      }
        
        // 创建弹出菜单容器
      UIView *popupContainer = [[UIView alloc] init];
      popupContainer.backgroundColor = [self ColorFromHexCode:defaults.backgroundColor];
        popupContainer.layer.cornerRadius = defaults.menuCornerRadius;
        // 移除 masksToBounds，否则阴影会被裁剪
        // popupContainer.layer.masksToBounds = YES;
        
        // 获取锚点视图的位置
      UIView *anchorView = [rootVC.view viewWithTag:(NSInteger)anchorViewId];
      if (!anchorView) {
                reject(@"error", @"Anchor view not found", nil);
                return;
      }
        
        // 添加边框
        if (defaults.borderWidth > 0) {
            popupContainer.layer.borderWidth = defaults.borderWidth;
          popupContainer.layer.borderColor = [self ColorFromHexCode:defaults.borderColor].CGColor;
        }
        
        // 添加阴影
        popupContainer.layer.shadowColor = [self ColorFromHexCode:defaults.shadowColor].CGColor;
        popupContainer.layer.shadowOpacity = defaults.shadowOpacity;
        popupContainer.layer.shadowRadius = defaults.shadowRadius;
        popupContainer.layer.shadowOffset = CGSizeMake(defaults.shadowOffsetX, defaults.shadowOffsetY);
        
        // 确保阴影能够正确渲染
        popupContainer.layer.shouldRasterize = YES;
        popupContainer.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        // 创建垂直布局容器
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.spacing = 0;
        stackView.translatesAutoresizingMaskIntoConstraints = NO;
        [popupContainer addSubview:stackView];
        
        // 设置stackView约束
        [NSLayoutConstraint activateConstraints:@[
            [stackView.topAnchor constraintEqualToAnchor:popupContainer.topAnchor constant:defaults.padding.top],
            [stackView.leadingAnchor constraintEqualToAnchor:popupContainer.leadingAnchor constant:defaults.padding.left],
            [stackView.trailingAnchor constraintEqualToAnchor:popupContainer.trailingAnchor constant:-defaults.padding.right],
            [stackView.bottomAnchor constraintEqualToAnchor:popupContainer.bottomAnchor constant:-defaults.padding.bottom]
        ]];
        int checkIconSize =defaults.checkIconSize;
        // 创建菜单项
        for (NSInteger i = 0; i < menuItems.count; i++) {
            NSString *title = menuItems[i];
            
            // 创建水平布局容器
            UIStackView *itemStack = [[UIStackView alloc] init];
            itemStack.axis = UILayoutConstraintAxisHorizontal;
            itemStack.spacing = 8;

            itemStack.alignment = UIStackViewAlignmentCenter;
            [itemStack.heightAnchor constraintEqualToConstant:defaults.rowHeight].active = YES;

            // 创建标签
            UILabel *label = [[UILabel alloc] init];
            label.text = title;
          NSNumber *weightNum = cssToUIFontWeight[@(defaults.fontWeight)];

          label.font = [UIFont systemFontOfSize:defaults.fontSize weight:(weightNum ? weightNum.doubleValue : UIFontWeightRegular)];
            // 设置文本颜色
            if (index && i == [index intValue]) {
              label.textColor = [self ColorFromHexCode:defaults.selectedTextColor];
            } else {
              label.textColor = [self ColorFromHexCode:defaults.textColor];
            }
            
            // 设置文本对齐
            if ([defaults.textAlignment isEqualToString:@"center"]) {
                label.textAlignment = NSTextAlignmentCenter;
            } else if ([defaults.textAlignment isEqualToString:@"right"]) {
                label.textAlignment = NSTextAlignmentRight;
            } else {
                label.textAlignment = NSTextAlignmentLeft;
            }
            
            // 设置标签宽度约束
            [label setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
            [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [itemStack addArrangedSubview:label];
            
            // 如果是选中项，添加勾选图标
            if (index && i == [index intValue]) {
                UIImageView *checkIcon = [[UIImageView alloc] init];
                checkIcon.image = [self createCheckIconWithSize:CGSizeMake(checkIconSize, checkIconSize) color:defaults.selectedTextColor];
                checkIcon.contentMode = UIViewContentModeScaleAspectFit;
                checkIcon.translatesAutoresizingMaskIntoConstraints = NO;
                
                [itemStack addArrangedSubview:checkIcon];
                
                // 设置图标大小约束
                [NSLayoutConstraint activateConstraints:@[
                    [checkIcon.widthAnchor constraintEqualToConstant:checkIconSize],
                    [checkIcon.heightAnchor constraintEqualToConstant:checkIconSize]
                ]];
            }else{
              UIView *wrap=[[UIView alloc] init ];
              [itemStack addArrangedSubview:wrap];
              [NSLayoutConstraint activateConstraints:@[
                  [wrap.widthAnchor constraintEqualToConstant:checkIconSize],
                  [wrap.heightAnchor constraintEqualToConstant:checkIconSize]
              ]];
            }
            
            // 添加点击手势
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuItemTapped:)];
            itemStack.userInteractionEnabled = YES;
            [itemStack addGestureRecognizer:tapGesture];
            
            // 存储索引
            objc_setAssociatedObject(itemStack, "menuIndex", @(i), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
                        [stackView addArrangedSubview:itemStack];
            
            // 添加分隔线（除了最后一项）
            if (i < menuItems.count - 1) {
                // 添加分隔线上方的间距
                UIView *topSpacer = [[UIView alloc] init];
                topSpacer.translatesAutoresizingMaskIntoConstraints = NO;
                [stackView addArrangedSubview:topSpacer];
                // 添加分隔线
                UIView *separator = [[UIView alloc] init];
                separator.backgroundColor = [self ColorFromHexCode:defaults.separatorColor];
                separator.translatesAutoresizingMaskIntoConstraints = NO;
                [stackView addArrangedSubview:separator];
                
                // 设置分隔线约束（只设置高度，宽度由stackView自动管理）
                [NSLayoutConstraint activateConstraints:@[
                    [separator.heightAnchor constraintEqualToConstant:1]
                ]];
                
                // 添加分隔线下方的间距
                UIView *bottomSpacer = [[UIView alloc] init];
                bottomSpacer.translatesAutoresizingMaskIntoConstraints = NO;
                [stackView addArrangedSubview:bottomSpacer];
            }
        }
        
        // 设置容器宽度约束
        [popupContainer setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [popupContainer setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
        // 创建弹出窗口
        UIWindow *window = nil;
        if (@available(iOS 13.0, *)) {
            if ([UIApplication sharedApplication].windows.count > 0) {
                window = [UIApplication sharedApplication].windows.firstObject;
                for (UIWindow *w in [UIApplication sharedApplication].windows) {
                    if (w.isKeyWindow) {
                        window = w;
                        break;
                    }
                }
            }
        } else {
            window = [UIApplication sharedApplication].keyWindow;
        }
        
        // 安全检查window
        if (!window) {
            if (reject) {
                reject(@"E_NO_WINDOW", @"Cannot find application window", nil);
            }
            return;
        }
        
        CGRect anchorFrame = [anchorView convertRect:anchorView.bounds toView:window];
        // 创建遮罩层并添加到 window，实现模态效果
        UIView *overlay = [[UIView alloc] init];
        overlay.backgroundColor = [UIColor clearColor];
        overlay.translatesAutoresizingMaskIntoConstraints = NO;
        [window addSubview:overlay];
        [NSLayoutConstraint activateConstraints:@[
            [overlay.topAnchor constraintEqualToAnchor:window.topAnchor],
            [overlay.leadingAnchor constraintEqualToAnchor:window.leadingAnchor],
            [overlay.trailingAnchor constraintEqualToAnchor:window.trailingAnchor],
            [overlay.bottomAnchor constraintEqualToAnchor:window.bottomAnchor]
        ]];
        // 将弹出容器添加到遮罩层
        [overlay addSubview:popupContainer];
        
        // 设置弹出窗口约束（与锚点左对齐，yoffset默认6）
        popupContainer.translatesAutoresizingMaskIntoConstraints = NO;
        
        // 计算弹出容器的位置
        CGFloat popupX = anchorFrame.origin.x;
        CGFloat popupY = anchorFrame.origin.y + anchorFrame.size.height + 6;
        
        NSLog(@"Calculated popup position: x=%f, y=%f", popupX, popupY);
        
        // 确保弹出容器不会超出屏幕边界
        CGFloat screenWidth = window.bounds.size.width;
        CGFloat screenHeight = window.bounds.size.height;
        
        NSLog(@"Screen bounds: width=%f, height=%f", screenWidth, screenHeight);
        
        // 检查右边界
        if (popupX + defaults.menuWidth > screenWidth) {
            popupX = screenWidth - defaults.menuWidth - 10; // 留10点边距
            NSLog(@"Adjusted popupX to: %f", popupX);
        }
        
        // 检查下边界
        if (popupY + 200 > screenHeight) { // 假设弹出容器高度约为200
            popupY = anchorFrame.origin.y - 200 - 6; // 显示在锚点上方
            NSLog(@"Adjusted popupY to: %f", popupY);
        }
        
        NSLog(@"Final popup position: x=%f, y=%f", popupX, popupY);
        
        [NSLayoutConstraint activateConstraints:@[
            [popupContainer.widthAnchor constraintEqualToConstant:defaults.menuWidth],
            [popupContainer.leadingAnchor constraintEqualToAnchor:overlay.leadingAnchor constant:popupX],
            [popupContainer.topAnchor constraintEqualToAnchor:overlay.topAnchor constant:popupY]
        ]];
        
        // 存储回调
        objc_setAssociatedObject(popupContainer, "resolveBlock", resolve, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(popupContainer, "rejectBlock", reject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        // 关联遮罩层以便关闭时一并移除
        objc_setAssociatedObject(popupContainer, "overlayView", overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        // 添加点击外部关闭手势
        UITapGestureRecognizer *backgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTapped:)];
        backgroundTap.cancelsTouchesInView = YES; // 模态：拦截点击
        [overlay addGestureRecognizer:backgroundTap];
        
        // 存储弹出窗口引用和标识
        objc_setAssociatedObject(backgroundTap, "popupContainer", popupContainer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        // 显示动画
        popupContainer.alpha = 0;
        popupContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
        
        [UIView animateWithDuration:defaults.animationDuration animations:^{
            popupContainer.alpha = 1;
            popupContainer.transform = CGAffineTransformIdentity;
        }];
    });
}

// 菜单项点击处理
- (void)menuItemTapped:(UITapGestureRecognizer *)gesture {
    UIView *itemStack = gesture.view;
    NSNumber *index = objc_getAssociatedObject(itemStack, "menuIndex");
    UIView *popupContainer = itemStack.superview.superview;
    
    RCTPromiseResolveBlock resolve = objc_getAssociatedObject(popupContainer, "resolveBlock");
    
    // 关闭弹出窗口
    [self dismissPopup:popupContainer];
    
    // 返回选中的索引
    if (resolve) {
        resolve(index);
    }
}

// 背景点击处理
- (void)backgroundTapped:(UITapGestureRecognizer *)gesture {
    UIView *popupContainer = objc_getAssociatedObject(gesture, "popupContainer");
    [self dismissPopup:popupContainer];
}

// 关闭弹出窗口
-(void)dismissPopup:(UIView *)popupContainer {
    ConfigDefaults *defaults = [[ConfigDefaults alloc] init];
    UIView *overlay = objc_getAssociatedObject(popupContainer, "overlayView");
    
    [UIView animateWithDuration:defaults.animationDuration animations:^{
        popupContainer.alpha = 0;
        popupContainer.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        if (overlay) {
            [overlay removeFromSuperview];
        } else {
            [popupContainer removeFromSuperview];
        }
    }];
}

@end
