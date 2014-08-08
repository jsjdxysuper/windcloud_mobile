//
//  KD3SettingViewController.m
//  kedong
//
//  Created by apple on 14-8-7.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "KD3SettingViewController.h"

@interface KD3SettingViewController ()

@property (strong, nonatomic)NSArray *listData;
@end

@implementation KD3SettingViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

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

    self.listData = [[NSMutableArray alloc] initWithObjects:@"用户信息",@"修改密码",@"应用信息", nil];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier ;
    
    if(2 == indexPath.row)
        CellIdentifier = @"applicationInfo";
    else if(1 == indexPath.row)
        CellIdentifier = @"modifySecret";
    else
        CellIdentifier = @"userInfo";
    

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    
    

    NSInteger row = [indexPath row];
    cell.textLabel.text = [self.listData objectAtIndex:row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger row = indexPath.row;
    NSLog(@"%d",row);
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *nextScene;
    
    if(2 == row)
        nextScene = [mainStoryboard instantiateViewControllerWithIdentifier:@"applicationScene"];
    
    else if(1 == row)
        nextScene = [mainStoryboard instantiateViewControllerWithIdentifier:@"userSecret"];
    else if(0 == row)
        nextScene = [mainStoryboard instantiateViewControllerWithIdentifier:@"userInfoScene"];
    
    [self.navigationController pushViewController:nextScene animated:YES];

    
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if([segue.identifier isEqualToString:@"applicationInfo"])
//    {
//        
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
