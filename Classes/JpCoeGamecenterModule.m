/**
 * Your Copyright Here
 *
 * Appcelerator Titanium is Copyright (c) 2009-2010 by Appcelerator, Inc.
 * and licensed under the Apache Public License (version 2)
 */
#import "JpCoeGamecenterModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"



@implementation JpCoeGamecenterModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"f76be438-bdf0-440a-b7e2-c718424a2af9";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"jp.coe.gamecenter";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];
	
	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably
	
	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup 

//-(void)dealloc
//{
//	// release any resources that have been retained by the module
//	[super dealloc];
//}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added 
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs

-(id)example:(id)args
{
	// example method
	return @"hello world";
}

-(id)exampleProp
{
	// example property getter
	return @"hello world";
}

-(void)setExampleProp:(id)value
{
	// example property setter
}

- (void)authenticateLocalPlayer:(id)args
{
//    ENSURE_UI_THREAD_1_ARG(args);
//    ENSURE_SINGLE_ARG(args,NSDictionary);
//    KrollCallback* onSuccess = [args objectForKey:@"callback"];
//    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
//    [localPlayer authenticateWithCompletionHandler:^(NSError *error) {
//        if (localPlayer.isAuthenticated)
//        {
//            // 認証済みプレーヤーの追加タスクを実行する
//            //success
//            
//            NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(YES),@"auth",nil];
//            
//            [self _fireEventToListener:@"auth" withObject:event listener:onSuccess thisObject:nil];
//        }
//        else {
//            NSDictionary *event = [NSDictionary dictionaryWithObjectsAndKeys:NUMBOOL(NO),@"auth",nil];
//            
//            [self _fireEventToListener:@"auth" withObject:event listener:onSuccess thisObject:nil];
//        }
//    }];
    
    GKLocalPlayer* player = [GKLocalPlayer localPlayer];
    player.authenticateHandler = ^(UIViewController* ui, NSError* error )
    {
        if( nil != ui )
        {
            [[TiApp app] showModalController:ui animated:YES];
            //[self presentViewController:ui animated:YES completion:nil];
        }
        
    };
}


//- (void) reportAchievementIdentifier: (NSString*) identifier percentComplete: (float) percent 
- (void) reportAchievementIdentifier:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args,NSDictionary);
    NSString* identifier = [[args objectForKey:@"key"] string];
    float percent = [[args objectForKey:@"percent"] floatValue];
    GKAchievement *achievement = [[GKAchievement alloc] initWithIdentifier: identifier];
    if (achievement) {
        
        achievement.percentComplete = percent;
        [achievement reportAchievementWithCompletionHandler:^(NSError *error)
         {
             if (error != nil) {
                 // アチーブメントオブジェクトを保持して、後から再試行します(ここには示さない)
             }
         }];
    }
}
//- (void) reportScore: (int64_t) score_gc forCategory: (NSString*) category
- (void) reportScore:(id)args
{
    ENSURE_UI_THREAD_1_ARG(args);
    ENSURE_SINGLE_ARG(args,NSDictionary);
    
    //IDがある場合、指定
    NSString* identifier = [args objectForKey:@"id"];
    if(identifier != nil) leaderboardController.category = identifier;
    
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:identifier];//@"jp.coe.yubitonton.score"];
    NSInteger scoreR = [[args objectForKey:@"score"] intValue];

    //scoreR=スコアの値;
    scoreReporter.value = scoreR;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            // 報告エラーの処理
            NSLog(@"error %@",error);
        }
    }];
    
//    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:category]
//                              autorelease];
//    scoreReporter.value = score_gc;
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            // 報告エラーの処理
//            UIAlertView *alert = [[UIAlertView alloc] init];
//            alert.delegate = self;
//            alert.title = @"スコアの送信に失敗しました";
//            alert.message = @"もう一度送信しますか？";
//            [alert addButtonWithTitle:@"はい"];
//            [alert addButtonWithTitle:@"いいえ"];
//            [alert show];
        }
    }];
}


//リーダーボードを立ち上げる
//-(IBAction)showBord
- (void) showBoard:(id)args
{
    ENSURE_UI_THREAD(showBoard,args);
    ENSURE_SINGLE_ARG(args,NSDictionary);
    leaderboardController = [[GKLeaderboardViewController alloc] init];
    leaderboardController.leaderboardDelegate = self;
    //[self presentModalViewController:leaderboardController animated:YES];
    
    //IDがある場合、指定
    NSString* identifier = [args objectForKey:@"id"];
    if(identifier != nil) leaderboardController.category = identifier;
    
    [[TiApp app] showModalController: leaderboardController animated: YES];
//    leaderboardController = [[GKLeaderboardViewController alloc] init];
//    if (leaderboardController != nil)
//    {
//        leaderboardController.leaderboardDelegate = self;
//         [[TiApp app] showModalController: leaderboardController animated: YES];
//        //[self presentModalViewController: leaderboardController animated: YES];
//    }
}
//リーダーボードで完了を押した時に呼ばれる
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    
    [leaderboardController dismissModalViewControllerAnimated:YES];
}

/*
-(BOOL)scoreReport:(id)value
{
// example property setter
    GKScore *scoreReporter = [[[GKScore alloc] initWithCategory:{リーダーボードのID}] autorelease];
    scoreReporter.value = rand() % 1000000;	// とりあえずランダム値をスコアに
    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if (error != nil)
        {
            // 報告エラーの処理
        }
    }];
}
 */

@end
