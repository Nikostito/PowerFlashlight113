@interface SpringBoard : NSObject
-(BOOL)_handlePhysicalButtonEvent:(id)arg1 ;
@end

@interface SBCCFlashlightSetting : NSObject
@property(assign, nonatomic, getter=isFlashlightOn) BOOL flashlightOn;

- (void)toggleState;
@end

BOOL pressed = NO;
NSTimer *pressedTimer;
SBCCFlashlightSetting *_flashlightSetting;

%hook SBCCFlashlightSetting
    - (id)init {
        self = %orig;
        _flashlightSetting = self;
        return self;
    }
    - (void)dealloc {
        _flashlightSetting = nil;
        %orig;
    }
%end

%hook SpringBoard

	-(_Bool)_handlePhysicalButtonEvent:(UIPressesEvent *)arg1 
	{

		int type = arg1.allPresses.allObjects[0].type; 
		int force = arg1.allPresses.allObjects[0].force;

        // type = 101 -> Home button
        // type = 104 -> Power button

        // force = 0 -> button released
        // force = 1 -> button pressed
		
		if(type == 104 && force == 1) //Power PRESSED
		{
            pressed = YES;
            pressedTimer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(toggleFlashlight) userInfo:nil repeats:NO] retain];
		}

        if(type == 104 && force == 0) //Power RELEASED
        {
            if (pressed) {
                //Lock device
            }
            if (pressedTimer != nil) {
                [pressedTimer invalidate];
                pressedTimer = nil;
            }
        }

		return %orig;
		
	}

    %new
    - (void)toggleFlashlight
    {
        if (pressed) {
            [_flashlightSetting toggleState];
            pressed = NO;
        }
    }
%end



	

