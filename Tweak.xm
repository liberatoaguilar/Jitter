@interface SBIcon : NSObject
-(long long)badgeValue;
-(void)reloadIconImage;
-(void)callTheMethod;
-(BOOL)isFolderIcon;
-(BOOL)isApplicationIcon;
@end
@interface SBIconListView : UIView
  -(id)icons;
  -(id)viewForIcon:(id)arg1 ;
  -(void)setIconsNeedLayout;
  -(void)layoutIconsNow;
@end
@interface SBRootIconListView : SBIconListView
  -(id)icons;
  -(id)viewForIcon:(id)arg1 ;
  -(void)updateJitterNotifs;
@end
@interface SBFolderIconListView : SBIconListView
  -(id)icons;
  -(id)viewForIcon:(id)arg1 ;
  -(void)updateJitterNotifs;
@end
@interface SBFloatingDockIconListView : SBIconListView
  -(id)icons;
  -(id)viewForIcon:(id)arg1 ;
  -(void)updateJitterNotifs;
@end
@interface SBIconView : UIView
@property (nonatomic, assign, readwrite) CGRect *frame;
+(id)_jitterXTranslationAnimation;
+(id)_jitterYTranslationAnimation;
+(id)_jitterRotationAnimation;
-(void)setIsEditing:(BOOL)arg1;
-(void)setIsEditing:(BOOL)arg1 animated:(BOOL)arg2;
-(void)setAllowsJitter:(BOOL)arg1;
-(void)setAllowsCloseBox:(BOOL)arg1;
@end
@interface SBFolderIconView : SBIconView
@end
@interface SBReusableViewMap : NSObject
@end
@interface SBIconViewMap : SBReusableViewMap
-(SBIconView*)mappedIconViewForIcon:(SBIcon*)icon;
@end
@interface SBIconController : UIViewController
@property (nonatomic,readonly) SBIconListView * dockListView;
@property (nonatomic,readonly) SBIconListView * floatingDockListView;
@property (nonatomic,readonly) SBIconListView * effectiveDockListView;
+(id)sharedInstance;
-(id)currentRootIconList;
-(SBIconViewMap *)homescreenIconViewMap;
@end

extern bool hasNotifs;
bool hasNotifs = NO;
extern int indexView;
int indexView = 16;
extern int DockindexView;
int DockindexView = 16;
extern SBRootIconListView *allicons;
SBRootIconListView *allicons = nil;
extern SBIconListView *listViewShared;
SBIconListView *listViewShared = nil;
bool animsfinished = NO;
bool enable = nil;
bool prefs1 = nil;
bool prefs2 = nil;
bool prefs3 = nil;
bool prefs4 = nil;
bool prefs5 = nil;
bool prefs6 = nil;
bool origJitter = nil;
CGFloat speed = nil;
CGFloat SideBounceIntensity = nil;
CGFloat PulseIntensity = nil;
CGFloat BounceIntensity = nil;

%hook SBIconView
+(id)_jitterXTranslationAnimation {
  NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.secondeight1.jitter.plist"];
  enable = [settings objectForKey:@"JitterEnable"] ? [[settings objectForKey:@"JitterEnable"] boolValue] : NO;
  origJitter = [settings objectForKey:@"ClassicJitter"] ? [[settings objectForKey:@"ClassicJitter"] boolValue] : NO;
  prefs1 = [settings objectForKey:@"SideBounce"] ? [[settings objectForKey:@"SideBounce"] boolValue] : NO;
  prefs2 = [settings objectForKey:@"Transform"] ? [[settings objectForKey:@"Transform"] boolValue] : NO;
  speed = [[settings objectForKey:@"Animation Speed"] floatValue];
  SideBounceIntensity = [[settings objectForKey:@"SideBounceIntensity"] floatValue];
  PulseIntensity = [[settings objectForKey:@"PulseIntensity"] floatValue];
  bool onlyJitter = NO;
  if (enable){
    // ClassicJitter
    CABasicAnimation *classic = %orig;
    //classic.duration = nil;

    // SideBounce
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.fromValue = [NSNumber numberWithFloat:SideBounceIntensity];
    animation.toValue = [NSNumber numberWithFloat:(SideBounceIntensity*-1)];
    //animation.duration = 0.2f;
    animation.repeatCount = 3000000000000000000;
    animation.autoreverses = YES;
    // return animation;

    //Transform
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    //transformAnimation.duration = 0.1;
    transformAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(PulseIntensity, PulseIntensity, 1)];
    transformAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    transformAnimation.repeatCount = 3000000000000000000;
    transformAnimation.autoreverses = YES;
    // return transformAnimation;

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.repeatCount = 3000000000000000000;
    group.autoreverses = YES;
    group.duration = speed;

    if (!origJitter){
      if (prefs1 && prefs2){
        group.animations = @[animation, transformAnimation];
      } else if (prefs1 && !prefs2){
        group.animations = @[animation];
      } else if (!prefs1 && prefs2){
        group.animations = @[transformAnimation];
      } else {
        group.animations = nil;
      }
    } else {
      if (prefs1 && prefs2){
        group.animations = @[animation, transformAnimation, classic];
      } else if (prefs1 && !prefs2){
        group.animations = @[animation, classic];
      } else if (!prefs1 && prefs2){
        group.animations = @[transformAnimation, classic];
      } else {
        onlyJitter = YES;
      }
    }
    if(!onlyJitter){
      return group;
    }else{
      return %orig;
    }
  }else{
    return %orig;
  }
}
+(id)_jitterYTranslationAnimation{
  NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.secondeight1.jitter.plist"];
  enable = [settings objectForKey:@"JitterEnable"] ? [[settings objectForKey:@"JitterEnable"] boolValue] : NO;
  origJitter = [settings objectForKey:@"ClassicJitter"] ? [[settings objectForKey:@"ClassicJitter"] boolValue] : NO;
  prefs3 = [settings objectForKey:@"Bouncer"] ? [[settings objectForKey:@"Bouncer"] boolValue] : NO;
  prefs4 = [settings objectForKey:@"Blinkr"] ? [[settings objectForKey:@"Blinkr"] boolValue] : NO;
  speed = [[settings objectForKey:@"Animation Speed"] floatValue];
  BounceIntensity = [[settings objectForKey:@"BounceIntensity"] floatValue];
  bool onlyJitter = NO;
  if(enable){
    // ClassicJitter
    CABasicAnimation *classic = %orig;
    //classic.duration = nil;

    // Bounce
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:(BounceIntensity*-1)];
    //animation.duration = 0.2f;
    animation.repeatCount = 3000000000000000000;
    animation.autoreverses = YES;
    // return animation;

    //Blink
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"hidden"];
    //transformAnimation.duration = 0.2;
    transformAnimation.toValue = [NSNumber numberWithBool:YES];
    transformAnimation.fromValue = [NSNumber numberWithBool:NO];
    transformAnimation.repeatCount = 3000000000000000000;
    transformAnimation.autoreverses = YES;
    // return transformAnimation;
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.repeatCount = 3000000000000000000;
    group.autoreverses = YES;
    group.duration = speed;

    if (!origJitter){
      if (prefs3 && prefs4){
        group.animations = @[animation, transformAnimation];
      } else if (prefs3 && !prefs4){
        group.animations = @[animation];
      } else if (!prefs3 && prefs4){
        group.animations = @[transformAnimation];
      } else {
        group.animations = nil;
      }
    } else {
      if (prefs3 && prefs4){
        group.animations = @[animation, transformAnimation, classic];
      } else if (prefs3 && !prefs4){
        group.animations = @[animation, classic];
      } else if (!prefs3 && prefs4){
        group.animations = @[transformAnimation, classic];
      } else {
        onlyJitter = YES;
      }
    }

    if(!onlyJitter){
      return group;
    }else{
      return %orig;
    }
  }else{
    return %orig;
  }
}
+(id)_jitterRotationAnimation{
  NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.secondeight1.jitter.plist"];
  enable = [settings objectForKey:@"JitterEnable"] ? [[settings objectForKey:@"JitterEnable"] boolValue] : NO;
  origJitter = [settings objectForKey:@"ClassicJitter"] ? [[settings objectForKey:@"ClassicJitter"] boolValue] : NO;
  prefs5 = [settings objectForKey:@"Rotate1"] ? [[settings objectForKey:@"Rotate1"] boolValue] : NO;
  prefs6 = [settings objectForKey:@"Rotate2"] ? [[settings objectForKey:@"Rotate2"] boolValue] : NO;
  speed = [[settings objectForKey:@"Animation Speed"] floatValue];

  bool onlyJitter = NO;
  if (enable){
    // ClassicJitter
    CABasicAnimation *classic = %orig;
    //classic.duration = nil;

    //Rotate
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 1 * 1.0f ];
    //rotationAnimation.duration = 1.0f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 3000000000000000000;
    // return rotationAnimation;

    //Rotate (autoreverse)
    CABasicAnimation* Rotate2;
    Rotate2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    Rotate2.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 1 * 1.0f ];
    //Rotate2.duration = 1.0f;
    Rotate2.cumulative = YES;
    Rotate2.repeatCount = 3000000000000000000;
    Rotate2.autoreverses = YES;
    // return rotationAnimation;

    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.repeatCount = 3000000000000000000;
    group.duration = speed;

    if (!origJitter){
      if (prefs5 && prefs6){
        group.autoreverses = YES;
        group.animations = @[rotationAnimation, Rotate2];
      } else if (prefs5 && !prefs6){
        group.autoreverses = NO;
        group.animations = @[rotationAnimation];
      } else if (!prefs5 && prefs6){
        group.autoreverses = YES;
        group.animations = @[Rotate2];
      } else {
        group.animations = nil;
      }
    } else {
      if (prefs5 && prefs6){
        group.autoreverses = YES;
        group.animations = @[rotationAnimation, Rotate2, classic];
      } else if (prefs5 && !prefs6){
        group.autoreverses = NO;
        group.animations = @[rotationAnimation, classic];
      } else if (!prefs5 && prefs6){
        group.autoreverses = YES;
        group.animations = @[Rotate2, classic];
      } else {
        onlyJitter = YES;
      }
    }

    if(!onlyJitter){
      return group;
    }else{
      return %orig;
    }
  }else{
    return %orig;
  }
}
%end

%hook SBRootIconListView
-(void)layoutSubviews {
  %orig;
  NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.secondeight1.jitter.plist"];
  enable = [settings objectForKey:@"JitterEnable"] ? [[settings objectForKey:@"JitterEnable"] boolValue] : NO;
  if (enable){
    allicons = self;
    [self updateJitterNotifs];
  }
}
%end
%hook SBFloatingDockIconListView
-(void)layoutSubviews {
  %orig;
  NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.secondeight1.jitter.plist"];
  enable = [settings objectForKey:@"JitterEnable"] ? [[settings objectForKey:@"JitterEnable"] boolValue] : NO;
  if (enable){
    //allicons = self;
    [self updateJitterNotifs];
  }
}
%end
%hook SBFolderIconListView
-(void)layoutSubviews {
  %orig;
  NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.secondeight1.jitter.plist"];
  enable = [settings objectForKey:@"JitterEnable"] ? [[settings objectForKey:@"JitterEnable"] boolValue] : NO;
  if (enable){
    //allicons = self;
    [self updateJitterNotifs];
  }
}
%end
%hook SBIconListView
-(id)init{
  listViewShared = self;
  return %orig;
}
%new
-(void)updateJitterNotifs {

  SBIconController *iconController = [NSClassFromString(@"SBIconController") sharedInstance];
  SBIconListView *iconListView = [iconController currentRootIconList];
  for (indexView = 0; indexView <= 20; indexView++){
    SBIcon *appIcon = [iconListView icons][indexView];
    SBIconView *appIconView = [iconController.homescreenIconViewMap mappedIconViewForIcon:appIcon];
    if (appIcon.badgeValue > 0) {
      [appIconView setAllowsCloseBox:NO];
      [appIconView setIsEditing:YES];
      [appIconView setIsEditing:YES animated:YES];
      [appIconView setAllowsJitter:YES];
    } else {
      [appIconView setIsEditing:NO];
      [appIconView setIsEditing:NO animated:NO];
      [appIconView setAllowsJitter:YES];
      [appIconView setAllowsCloseBox:YES];
    }

  }
}

  // SBIconListView *DockiconListView = [iconController dockListView];
  // for (DockindexView = 0; DockindexView <= 8; DockindexView++){
  //   SBIcon *appIcon = [DockiconListView icons][DockindexView];
  //   SBIconView *appIconView = [iconController.homescreenIconViewMap mappedIconViewForIcon:appIcon];
  //   if (appIcon.badgeValue > 0) {
  //     [appIconView setIsEditing:YES];
  //     [appIconView setIsEditing:YES animated:YES];
  //     [appIconView setAllowsJitter:YES];
  //     [appIconView setAllowsCloseBox:NO];
  //   }
  // }
  //
  // SBIconListView *FloatingDockiconListView = [iconController floatingDockListView];
  // for (DockindexView = 0; DockindexView <= 8; DockindexView++){
  //   SBIcon *appIcon = [FloatingDockiconListView icons][DockindexView];
  //   SBIconView *appIconView = [iconController.homescreenIconViewMap mappedIconViewForIcon:appIcon];
  //   if (appIcon.badgeValue > 0) {
  //     [appIconView setIsEditing:YES];
  //     [appIconView setIsEditing:YES animated:YES];
  //     [appIconView setAllowsJitter:YES];
  //     [appIconView setAllowsCloseBox:NO];
  //   }
  // }
%end

%hook SBHomeHardwareButton
-(void)singlePressUp:(id)arg1{
  NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.secondeight1.jitter.plist"];
  enable = [settings objectForKey:@"JitterEnable"] ? [[settings objectForKey:@"JitterEnable"] boolValue] : NO;
  if (enable){
    [listViewShared setIconsNeedLayout];
    [listViewShared layoutIconsNow];
    [allicons updateJitterNotifs];
  }
  %orig;
}
%end

%hook SpringBoard
-(void)frontDisplayDidChange:(id)newDisplay {
  NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.secondeight1.jitter.plist"];
  enable = [settings objectForKey:@"JitterEnable"] ? [[settings objectForKey:@"JitterEnable"] boolValue] : NO;
  if (enable){
    if (newDisplay == nil) {
      [listViewShared setIconsNeedLayout];
      [listViewShared layoutIconsNow];
      [allicons updateJitterNotifs];
    } else if ([newDisplay isKindOfClass:%c(SBDashBoardViewController)]) {
      [listViewShared setIconsNeedLayout];
      [listViewShared layoutIconsNow];
      [allicons updateJitterNotifs];
    } else if ([newDisplay isKindOfClass:%c(SBApplication)]) {
      [listViewShared setIconsNeedLayout];
      [listViewShared layoutIconsNow];
      [allicons updateJitterNotifs];
    }
  }
  %orig(newDisplay);
}
%end

%hook SBIcon
-(void)setBadge:(id)arg1 {
  %orig;
  NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.secondeight1.jitter.plist"];
  enable = [settings objectForKey:@"JitterEnable"] ? [[settings objectForKey:@"JitterEnable"] boolValue] : NO;
  if (enable){
    [listViewShared setIconsNeedLayout];
    [listViewShared layoutIconsNow];
    [allicons updateJitterNotifs];
  }
}
%new
-(void)callTheMethod {
  [listViewShared setIconsNeedLayout];
  [listViewShared layoutIconsNow];
  [allicons updateJitterNotifs];
}
%end

%hook SBFolderIconView
-(void)scrollToFirstGapAnimated:(BOOL)arg1 {
  NSMutableDictionary *settings = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.secondeight1.jitter.plist"];
  enable = [settings objectForKey:@"JitterEnable"] ? [[settings objectForKey:@"JitterEnable"] boolValue] : NO;
  if (!enable){
    %orig;
  }
}
%end
