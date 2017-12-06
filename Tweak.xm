@interface SBStarkLockOutViewController : UIViewController
@end

@interface UIView (Snow)
-(void)makeItSnow;
-(void)stopSnowing;
@end

// iOS 7-10
%hook SBFStaticWallpaperView

-(void)_setupContentView {
	%orig;
	[self makeItSnow];
}

-(void)layoutSubviews {
	%orig;
	[self stopSnowing];
	[self makeItSnow];
}

%end

// CarPlay
%hook SBStarkLockOutViewController

-(void)viewDidAppear:(BOOL)arg1 {
	%orig;
	[self.view makeItSnow];
}

%end