//
//  PracticeCodesViewController.m
//  TestTabController1
//
//  Created by LRich on 12/5/12.
//  Copyright (c) 2012 LR
//

#import "PracticeCodesViewController.h"

@interface PracticeCodesViewController ()

@end

@implementation PracticeCodesViewController
{
    NSArray *keys;
    NSArray *objects;
    
    }

//@synthesize practiceCode = _practiceCode;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.contentSizeForViewInPopover = CGSizeMake(150.0, 100.0);
      
        
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)setPracticeCodeText:(NSString *)key
{
    
//    keys = [NSArray arrayWithObjects:
//            @"Solicit",
//            @"Fact",
//            @"Procedural",
//            @"Explain",
//            @"Apply",
//            @"Meta",
//            @"New and Old",
//            @"Itinerary",
//            @"Directions",
//            @"Foreshadow",
//            @"Situate",
//            @"Acknowledge",
//            @"Reprase",
//            @"Redirect",
//            @"Correct",
//            @"Praise",
//            @"Give Info",
//            @"Hint",
//            @"Think Aloud",
//            @"Deflect",
//            @"Summarize", nil];
//
    keys = [NSArray arrayWithObjects:
            @"3001",
            @"3002",
            @"3003",
            @"3004",
            @"3005",
            @"3006",
            @"3007",
            @"3008",
            @"3009",
            @"3010",
            @"3011",
            @"3012",
            @"3013",
            @"3014",
            @"3015",
            @"3016",
            @"3017",
            @"3018",
            @"3019",
            @"3020",
            @"3021", nil];
    

    
    objects = [NSArray arrayWithObjects:
               @"Solicit volunteers for activity; call on students to take a turn; tally students’ votes/ choices; check on students’ progress",
               @"Require students to recall facts, terms, or observations; or require students to provide short, specific answers (knowing that…)",
               @"Require students to recall steps, actions, or procedures in observing phenomena or conducting investigations (knowing how…)",
               @"Require students to recall theories, models, or evidence to explain natural phenomena (knowing why….)",
               @"Encourage students to apply learning to new conditions, scenarios or problems (what if…)",
               @"Prompt students to evaluate the reasoning, explanations, or use of evidence in argument by themselves or others",
               @"Making connections between previously covered material and what is currently being discussed",
               @"Giving the itinerary or list of activities for the lesson; reiterating the itinerary as the lesson progresses",
               @"Providing directions to students for how to complete a specific task",
               @"Foreshadowing what will come later in the instructional experience (logistical information)",@"Providing a conceptual rationale for a given class activity—“content storyline”",
               @"Repeating close to verbatim what a student said for the whole class to hear",
               @"Articulating a student response more clearly/logically/succinctly, often using more precise, scientific language",
               @"Indicating that some part of a student response is not accurate or on target and push for more information from the students",
               @"Correcting a student’s answer by providing correct answer OR stating the answer was incorrect ",
               @"Reinforcing or encouraging creative answers, participation, persistence ",
               @"Providing conceptual information including vocabulary",
               @"Using specific hints, cues, or suggestions to guide students’ thinking about an idea or task",
               @"Demonstrating how he/she (the teacher) would approach a problem or think about a topic",
               @"Not providing an answer to a direct student question but, rather, encouraging the student to find the answer for him/herself",
               @"Reinforcing the main points of a lesson by reiterating or tying together multiple pieces of information",nil];
    
//
    
    
//    UILabel *usernameTextField=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300.0, 150.0)];
//    usernameTextField.textColor = [UIColor blackColor];
//    usernameTextField.font = [UIFont systemFontOfSize:17.0];
//    
//    usernameTextField.text = @"rgtdfrgdrgder";
//    //usernameTextField.delegate=self;
//    [self.view addSubview:usernameTextField];
  
    //UILabel *headingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    
 UITextView *headingLabel = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    [headingLabel setEditable:NO];    
    
    NSInteger count = [objects count];
    for (int i = 0; i < count; i++)
    {//[theLabel.text isEqualToString:@"0"]
        if([[keys objectAtIndex:i] isEqualToString:key])
        {
            headingLabel.text = [objects objectAtIndex:i];
        }
        
    }
    
       //headingLabel.text = @"dsfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdfasdf";
   
    
    [self.view addSubview:headingLabel];
    
    }


@end
