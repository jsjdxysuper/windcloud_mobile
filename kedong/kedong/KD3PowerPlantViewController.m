//
//  KD3PowerPlant1ViewController.m
//  kedong
//
//  Created by apple on 14-7-24.
//  Copyright (c) 2014年 apple. All rights reserved.
//

#import "KD3PowerPlantViewController.h"
#import "LDProgressView.h"
#import "KD3CommonTools.h"
#import "EFloatBox.h"
#import "EColor.h"
#import "EColumnDataModel.h"
#import "EColumnChartLabel.h"


@interface KD3PowerPlantViewController ()

//NSString:serialNumber, NSArray:substract.
@property (strong, nonatomic) NSMutableDictionary *plantsSubstractDic;
//NSString:serialNumber, NSInteger:progress.
@property (strong, nonatomic) NSMutableDictionary *progressDic;
//NSString:serialNumber, NSInteger:diff.
@property (strong, nonatomic) NSMutableDictionary *progressDiffDic;

@property (strong, nonatomic) NSArray *colorsArray;


//properties for progressDiffEColumnChart
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) EFloatBox *eFloatBox;

@property (nonatomic, strong) EColumn *eColumnSelected;
@property (nonatomic, strong) UIColor *tempColor;

@property (strong, nonatomic) NSMutableArray *valuesProgressDif;
@property  (strong, nonatomic) UILabel *displayValue;
@end

@implementation KD3PowerPlantViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _plantsSubstractDic = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    
    NSArray *substractArray = [[NSArray alloc] initWithObjects:@"45",@"35",@"52",@"47", nil];
    [_plantsSubstractDic setObject:substractArray forKey:@"大连"];
    substractArray = [[NSArray alloc] initWithObjects:@"45", @"65",@"62",@"47", nil];
    [_plantsSubstractDic setObject:substractArray forKey:@"鞍山"];
    substractArray = [[NSArray alloc] initWithObjects:@"45", @"35",@"72",@"57", nil];
    [_plantsSubstractDic setObject:substractArray forKey:@"盘锦"];
    substractArray = [[NSArray alloc] initWithObjects:@"45", @"53",@"32",@"41", nil];
    [_plantsSubstractDic setObject:substractArray forKey:@"辽阳"];
    substractArray = [[NSArray alloc] initWithObjects:@"44", @"32",@"52",@"49", nil];
    [_plantsSubstractDic setObject:substractArray forKey:@"锦州"];
    
    
    
    
    _progressDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                    [NSNumber numberWithFloat:40],@"大连",
                    [NSNumber numberWithFloat:43],@"鞍山",
                    [NSNumber numberWithFloat:65],@"盘锦",
                    [NSNumber numberWithFloat:54],@"辽阳",
                    [NSNumber numberWithFloat:29],@"锦州",nil];
    
    
    
    
    _progressDiffDic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                        [NSNumber numberWithInt:12],@"大连",
                        [NSNumber numberWithInt:9],@"鞍山",
                        [NSNumber numberWithInt:-5],@"盘锦",
                        [NSNumber numberWithInt:3],@"辽阳",
                        [NSNumber numberWithInt:7],@"锦州",nil];
    
    
    
    //Datasource init for progressDiffEColumnChart
    NSArray *plantNames = [[NSArray alloc] initWithObjects:@"丹东", @"大连",@"营口",@"鞍山",@"锦州",@"锦州", @"沈阳", nil];
    _valuesProgressDif = [[NSMutableArray alloc] initWithCapacity:30];
    NSMutableArray *temp = [NSMutableArray array];
    for (int i = 0; i < 5; i++)
    {
        int value = 10+arc4random() % 100;
        EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:[plantNames objectAtIndex:i] value:value index:i unit:@"MWh"];
        [temp addObject:eColumnDataModel];
        [_valuesProgressDif addObject:[NSNumber numberWithInteger:value]];
    }
    
    EColumnDataModel *eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:[plantNames objectAtIndex:5] value:20 index:5 unit:@"MWh"];
    [_valuesProgressDif addObject:[NSNumber numberWithInteger:-20]];
    [temp addObject:eColumnDataModel];
    
    eColumnDataModel = [[EColumnDataModel alloc] initWithLabel:[plantNames objectAtIndex: 6] value:10 index:6 unit:@"MWh"];
    [temp addObject:eColumnDataModel];
    [_valuesProgressDif addObject:[NSNumber numberWithInteger:-10]];
    
    
    _data = [NSArray arrayWithArray:temp];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * ret;
    if(0 == section)
        ret = [[NSString alloc] initWithFormat:@"基本数据"];
    else if(1 == section)
        ret = [[NSString alloc] initWithFormat:@"计划完成率"];
    else
        ret = [[NSString alloc] initWithFormat:@"日历进度差"];
    return ret;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger ret = 0;
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            ret = [_plantsSubstractDic count]+1;
            break;
        case 1:
            ret = [_progressDic count];
            break;
        default:
            //ret = [_progressDiffDic count];
            ret = 1;
            break;
    }
    return ret;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(2 ==[indexPath section])
        return 220;
    else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = [indexPath section];
    NSInteger row = [indexPath row];
    NSString *identifier = nil;
    NSArray * keysArray;
    

    if( 0 == section){
        identifier = @"substractTableCell";
        keysArray = [_plantsSubstractDic allKeys];
    }
    else if(1 == section){
        identifier = @"progressTableCell";
        keysArray = [_progressDic allKeys];
    }else{
        identifier = @"diffProgressTableCell";
        keysArray = [_progressDiffDic allKeys];

    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    if( 0 == section){
        UILabel *cellLabel1 = (UILabel *)[cell viewWithTag:1];
        UILabel *cellLabel2 = (UILabel *)[cell viewWithTag:2];
        UILabel *cellLabel3 = (UILabel *)[cell viewWithTag:3];
        UILabel *cellLabel4 = (UILabel *)[cell viewWithTag:4];
        UILabel *cellLabel5 = (UILabel *)[cell viewWithTag:5];
        
        if(0 == row)
        {//这里是表头
            cellLabel1.text = @"电厂";
            cellLabel2.text = @"日电量";
            cellLabel3.text = @"月电量";
            cellLabel4.text = @"年累计";
            cellLabel5.text = @"年计划";
        }
        else
        {//这里是表的内容
            NSArray * subArray = [_plantsSubstractDic objectForKey:[keysArray objectAtIndex:row - 1]];
            cellLabel1.text = [keysArray objectAtIndex:row - 1];
            cellLabel2.text = [subArray objectAtIndex:0];
            cellLabel3.text = [subArray objectAtIndex:1];
            cellLabel4.text = [subArray objectAtIndex:2];
            cellLabel5.text = [subArray objectAtIndex:3];
        }
    }
    else if(1 == section){
        
        UILabel *cellLabel6 = (UILabel *)[cell viewWithTag:6];
        UIView *progressUIView = (UIView *)[cell viewWithTag:7];
        
        NSNumber *progressNum = [_progressDic objectForKey:[keysArray objectAtIndex:row]];
        LDProgressView *progressView = [[LDProgressView alloc] initWithFrame:CGRectMake(2, 2, progressUIView.frame.size.width-4, 22)];
        progressView.progress = [progressNum floatValue]/100;
        progressView.borderRadius = @5;
        progressView.color = [KD3CommonTools getColor:row];
        progressView.type = LDProgressSolid;
        progressView.flat = @YES;
        
        
        [progressUIView addSubview:progressView];
        cellLabel6.text = [keysArray objectAtIndex:row];
    }else if(2 == section){


        _eColumnChart =
        [[EColumnChart alloc] initWithFrame:CGRectMake(40, 50,                                                                              cell.frame.size.width-80,
                                                       140)];
        //[_eColumnChart setNormalColumnColor:[UIColor purpleColor]];
        [_eColumnChart setColumnsIndexStartFromLeft:YES];
        [_eColumnChart setDelegate:self];
        [_eColumnChart setDataSource:self];
        [_eColumnChart setShowHighAndLowColumnWithColor:NO];
        

        
//        _displayValue = [[UILabel alloc]initWithFrame:CGRectMake(230, 20, 50, 30)];
//        _displayValue.tag =1;
//        
//        [_eColumnChart addSubview:_displayValue];
        UILabel *tempLabel1 = (UILabel *)[_eColumnChart viewWithTag:11];
        tempLabel1.hidden = YES;
        [tempLabel1 removeFromSuperview];
        UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, 20, 50, 30)];
//        NSInteger tempInt = [[_valuesProgressDif objectAtIndex:eColumn.eColumnDataModel.index] intValue];
//        tempLabel.text = [[NSString alloc] initWithFormat:@"%ld", tempInt];
//        
        [_eColumnChart  addSubview:tempLabel];
        [cell addSubview:_eColumnChart];
        
        
        
    }
    // Configure the cell...
    
    return cell;
}

#pragma mark - EColumnChart Datasource


- (NSInteger)numberOfColumnsInEColumnChart:(EColumnChart *)eColumnChart
{
    return [_data count];
}

- (NSInteger)numberOfColumnsPresentedEveryTime:(EColumnChart *)eColumnChart
{
    return 7;
}

- (EColumnDataModel *)highestValueEColumnChart:(EColumnChart *)eColumnChart
{
    EColumnDataModel *maxDataModel = nil;
    float maxValue = -FLT_MIN;
    for (EColumnDataModel *dataModel in _data)
    {
        if (dataModel.value > maxValue)
        {
            maxValue = dataModel.value;
            maxDataModel = dataModel;
        }
    }
    return maxDataModel;
}

- (EColumnDataModel *)eColumnChart:(EColumnChart *)eColumnChart valueForIndex:(NSInteger)index
{
    if (index >= [_data count] || index < 0) return nil;
    return [_data objectAtIndex:index];
}

- (UIColor *)colorForEColumn:(EColumn *)eColumn
{
    if(0 > [[_valuesProgressDif objectAtIndex: eColumn.eColumnDataModel.index] intValue])
        return [UIColor redColor];
    else
        return [UIColor greenColor];
    
}

#pragma mark - EColumnChart Delegate

- (void)eColumnChart:(EColumnChart *)eColumnChart
     didSelectColumn:(EColumn *)eColumn
{
    NSLog(@"Index: %ld  Value: %f", eColumn.eColumnDataModel.index, eColumn.eColumnDataModel.value);
    
    if (_eColumnSelected)
    {
        _eColumnSelected.barColor = _tempColor;
    }
    _eColumnSelected = eColumn;
    _tempColor = eColumn.barColor;
    eColumn.barColor = [UIColor blackColor];
    
    //    _valueLabel.text = [NSString stringWithFormat:@"%.1f",eColumn.eColumnDataModel.value];


//    [_displayValue removeFromSuperview];
//    _displayValue = nil;

    UILabel *tempLabel1 = (UILabel *)[_eColumnChart viewWithTag:11];
    tempLabel1.hidden = YES;
    [tempLabel1 removeFromSuperview];
    UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(230, 20, 50, 30)];
    tempLabel.tag = 11;
    NSInteger tempInt = [[_valuesProgressDif objectAtIndex:eColumn.eColumnDataModel.index] intValue];
    tempLabel.text = [[NSString alloc] initWithFormat:@"%ld", tempInt];

    [_eColumnChart  addSubview:tempLabel];
    

}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidEnterColumn:(EColumn *)eColumn
{
    /**The EFloatBox here, is just to show an example of
     taking adventage of the event handling system of the Echart.
     You can do even better effects here, according to your needs.*/
    NSLog(@"Finger did enter %ld", (long)eColumn.eColumnDataModel.index);
    CGFloat eFloatBoxX = eColumn.frame.origin.x + eColumn.frame.size.width * 1.25;
    CGFloat eFloatBoxY = eColumn.frame.origin.y + eColumn.frame.size.height * (1-eColumn.grade);
    if (_eFloatBox)
    {
        [_eFloatBox removeFromSuperview];
        _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        [_eFloatBox setValue:eColumn.eColumnDataModel.value];
        [eColumnChart addSubview:_eFloatBox];
    }
    else
    {
        _eFloatBox = [[EFloatBox alloc] initWithPosition:CGPointMake(eFloatBoxX, eFloatBoxY) value:eColumn.eColumnDataModel.value unit:@"kWh" title:@"Title"];
        _eFloatBox.alpha = 0.0;
        [eColumnChart addSubview:_eFloatBox];
        
    }
    eFloatBoxY -= (_eFloatBox.frame.size.height + eColumn.frame.size.width * 0.25);
    _eFloatBox.frame = CGRectMake(eFloatBoxX, eFloatBoxY, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        _eFloatBox.alpha = 1.0;
        
    } completion:^(BOOL finished) {
    }];
    
}

- (void)eColumnChart:(EColumnChart *)eColumnChart
fingerDidLeaveColumn:(EColumn *)eColumn
{
    NSLog(@"Finger did leave %ld", (long)eColumn.eColumnDataModel.index);
    
}

- (void)fingerDidLeaveEColumnChart:(EColumnChart *)eColumnChart
{
    if (_eFloatBox)
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
            _eFloatBox.alpha = 0.0;
            _eFloatBox.frame = CGRectMake(_eFloatBox.frame.origin.x, _eFloatBox.frame.origin.y + _eFloatBox.frame.size.height, _eFloatBox.frame.size.width, _eFloatBox.frame.size.height);
        } completion:^(BOOL finished) {
            [_eFloatBox removeFromSuperview];
            _eFloatBox = nil;
        }];
        
    }
    
}
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
