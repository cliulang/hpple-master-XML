//
//  ReadListVC.m
//  HppleDemo
//
//  Created by zero on 15/7/20.
//
//

#import "ReadListVC.h"
#import "TFHpple.h"
#import "ReadListModel.h"
#import "ReadInfoVC.h"

@interface ReadListVC ()
@property (nonatomic,strong) NSMutableArray* dataArray;
@property (nonatomic,strong) NSArray* urlArray;
@property (nonatomic,strong) NSString* hostUrl;
@property (nonatomic,strong) TFHpple* tfHpple;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) NSInteger pageIndex;
@end

@implementation ReadListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _hostUrl = @"http://www.1100lu.us";
    _pageIndex = 0;
   NSString* string = @"http://www.1100lu.us/html/xiaoshuo/jiqingxiaoshuo/index.html";
    string = @"http://www.1100lu.us/html/xiaoshuo/huangsexiaohua/index.html";
//    string = @"http://www.695p.com/htm/novellist1/";
    [self getListWithUrl:_readUrl];
   dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getNextUrlWithUrl:_readUrl];
   });
}

- (void)getNextUrlWithUrl:(NSString*)url{
//    TFHpple* tf = [[TFHpple alloc]initWithHTMLData:[[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:url]]];
    NSArray* array = [[_tfHpple searchWithXPathQuery:@"//div[@class='box_page']"][0] children];
    NSMutableArray* store = [NSMutableArray array];
    for(TFHppleElement* element in array  ){
//        NSLog(@"%@",element.content);
        if([element.tagName isEqualToString:@"div"]){
//            NSLog(@"%@",element.attributes);
            for(TFHppleElement* e in element.children){
                NSLog(@"%@",e.content);
                if([e.tagName isEqualToString:@"a"]){
                    NSLog(@"%@ - %@",e.content,[e.attributes objectForKeyedSubscript:@"href"]);
                }else if ([e.tagName isEqualToString:@"select"]){
                    NSLog(@"%@ - %@",e.content,[e.attributes objectForKeyedSubscript:@"href"]);
                    for(TFHppleElement* sub in e.children){
                        if([sub.tagName isEqualToString:@"option"]){
                            NSLog(@"%@ - %@",sub.content,[sub.attributes objectForKeyedSubscript:@"value"]);
                            ReadListModel* model = [[ReadListModel alloc]init];
                            model.name = sub.content;
                            model.url = [NSString stringWithFormat:@"%@%@",_hostUrl,[sub.attributes objectForKeyedSubscript:@"value"]];
                            [store addObject:model];
                        }
                    }
                }
                
            }
        }
    }
    _urlArray = store;
}

- (void)getListWithUrl:(NSString*)url{
    NSError* error = nil;
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url] options:NSDataReadingMappedAlways error:&error];
    NSLog(@"%@",error.description);
    if(data == nil){
        return;
    }
    TFHpple* tf = [[TFHpple alloc]initWithHTMLData:data];
    _tfHpple = tf;
    NSArray* array = [tf searchWithXPathQuery:@"//div[@class='zxlist']/ul"];
    if(array.count ==0){
        return;
    }
    NSMutableArray* store = [NSMutableArray array];
    for(TFHppleElement* element in array){
        NSLog(@" -- -  -- -  -- - - - -");
        NSArray* arr = [element searchWithXPathQuery:@"//li"];
        NSLog(@"%li",arr.count);
        TFHppleElement* e = arr[0];
        for(TFHppleElement* sub in e.children){
            if([sub.tagName isEqualToString:@"a"]){
                NSLog(@"%@ - %@",sub.content,[sub.attributes objectForKeyedSubscript:@"href"]);
                ReadListModel* model = [[ReadListModel alloc]init];
                model.name = sub.content;
                model.url = [NSString stringWithFormat:@"%@%@",_hostUrl,[sub.attributes objectForKeyedSubscript:@"href"]];
                [store addObject:model];
            }
        }
    }
    if(_dataArray == nil){
        _dataArray = [NSMutableArray array];
    }
    [_dataArray addObjectsFromArray:store];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    
}

- (void)NSLogChildren:(NSArray*)children{
    
    for(TFHppleElement* element in children){
        NSLog(@"-\n-------------start----------------------\n");
        if(element.children.count > 0){
            [self NSLogChildren:element.children];
        }else{
            NSLog(@"tag:%@-content:%@-raw:%@ ",element.tagName,element.content,element.raw);
        }
        NSLog(@"-\n-------------end---------------------\n");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    ReadListModel* model = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = model.name;
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadListModel* model = [_dataArray objectAtIndex:indexPath.row];
    ReadInfoVC* vc = [[ReadInfoVC alloc]init];
    vc.title = model.name;
    vc.url = model.url;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!_isLoading && indexPath.row >= _dataArray.count-3 && _urlArray.count > _pageIndex){
        _isLoading = YES;
        _pageIndex += 1;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            ReadListModel* model = _urlArray[_pageIndex];
            [self getListWithUrl:model.url];
            _isLoading = NO;
        });
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
