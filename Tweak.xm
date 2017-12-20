#import "./FallingSnow/FallingSnow.h"


#define prefPath @"/User/Library/Preferences/com.leftyfl1p.snoverlay.plist"
static BOOL enabled = YES;
static BOOL wallpaperOnly = NO;
static NSMutableDictionary *prefs = nil;

@interface SBStarkLockOutViewController : UIViewController
@end

@interface UIView (Snow)
-(void)makeItSnow;
-(void)stopSnowing;
@end

@interface SBFStaticWallpaperView : UIView
-(void)handlePrefs;
@end


@interface SnoverlaySecureWindow : UIWindow
@end

@implementation SnoverlaySecureWindow

-(id)initWithFrame:(CGRect)frame {
	if(self = [super initWithFrame:frame])
	{
		self.windowLevel = 100000.0f;
		self.userInteractionEnabled = NO;
		self.hidden = NO;
		if(enabled && !wallpaperOnly) {
			[self makeItSnow];
		}
		
		[[NSNotificationCenter defaultCenter] addObserverForName:@"com.leftyfl1p.snoverlay/settingschanged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
				__block SnoverlaySecureWindow *weakSelf = self;

				if(enabled && !wallpaperOnly){
					if(!weakSelf.snowView) {
						HBLogDebug(@"turn on");
						[weakSelf makeItSnow];
					}
					
				} else {
					HBLogDebug(@"turn off");
					[weakSelf stopSnowing];
				}
						
				

		}];

	}
	return self;
}



- (BOOL)_isSecure {
	return YES;
}

- (BOOL)_shouldCreateContextAsSecure {
	return YES;
}

@end


static void loadPrefs()
{
	prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:prefPath];
	enabled = prefs[@"enabled"] ? [prefs[@"enabled"] boolValue] : 1;
	wallpaperOnly = prefs[@"wallpaperOnly"] ? [prefs[@"wallpaperOnly"] boolValue] : 0;
	HBLogDebug(@"wallpaperOnly is %d", wallpaperOnly);
	HBLogDebug(@"enabled is %d", enabled);


	// shouldOverride = prefs[@"override"] ? [prefs[@"override"] boolValue] : 0;
	// showInLS = prefs[@"showInLS"] ? [prefs[@"showInLS"] boolValue] : 1;
	// showInMultitasking = prefs[@"showInMultitasking"] ? [prefs[@"showInMultitasking"] boolValue] : 1;
	// suggestionName = [prefs[@"suggestionName"] length] != 0 ? prefs[@"suggestionName"] : @"Empyreal";

	[[NSNotificationCenter defaultCenter] postNotificationName:@"com.leftyfl1p.snoverlay/settingschanged" object:nil];

}

static void receivedNotification(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	loadPrefs();
}



// iOS 7-10
%hook SBFStaticWallpaperView

-(void)_setupContentView {
	%orig;
	// [[NSNotificationCenter defaultCenter] addObserverForName:@"com.leftyfl1p.snoverlay/settingschanged" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
	// 	__block SBFStaticWallpaperView *weakSelf = self;

	// 	if(enabled && wallpaperOnly){
	// 		if(!weakSelf.snowView) {
	// 			HBLogDebug(@"turn on2");
	// 			[weakSelf makeItSnow];
	// 		}
			
	// 	} else {
	// 		HBLogDebug(@"turn off2");
	// 		[weakSelf stopSnowing];
	// 	}
				
		

	// }];

	 [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(handlePrefs) 
        name:@"com.leftyfl1p.snoverlay/settingschanged"
        object:nil];

	[self handlePrefs];
}

%new
-(void)handlePrefs {
	if(enabled && wallpaperOnly){
		if(!self.snowView) {
			HBLogDebug(@"turn on2");
			[self makeItSnow];
		}
		
	} else {
		HBLogDebug(@"turn off2");
		[self stopSnowing];
	}
}

-(void)layoutSubviews {
	%orig;
	//[self stopSnowing];
	//[self makeItSnow];
}

%end

// CarPlay
%hook SBStarkLockOutViewController

-(void)viewDidAppear:(BOOL)arg1 {
	%orig;
	[self.view makeItSnow];
}

%end


%ctor {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *block) {
		CGRect frame = [UIScreen mainScreen].bounds;
		SnoverlaySecureWindow *window = [[SnoverlaySecureWindow alloc] initWithFrame:frame];
		window.windowLevel = 100000.0f;
		// XMASFallingSnowView *overlayView = [[XMASFallingSnowView alloc] initWithFrame:frame];
		// [window addSubview:overlayView];
		window.userInteractionEnabled = NO;
		window.hidden = NO;
		// [overlayView beginSnowAnimation];
	}];
	[pool drain];

	loadPrefs();

	CFNotificationCenterAddObserver(
	CFNotificationCenterGetDarwinNotifyCenter(),
	NULL,
	receivedNotification,
	CFSTR("com.leftyfl1p.snoverlay/settingschanged"),
	NULL,
	CFNotificationSuspensionBehaviorCoalesce);

	%init;

}