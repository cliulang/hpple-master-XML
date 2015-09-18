//
//  ReadTypeVC.m
//  HppleDemo
//
//  Created by zero on 15/7/21.
//
//

#import "ReadTypeVC.h"
#import "ReadListModel.h"
#import "ReadListVC.h"
@interface ReadTypeVC ()

@end

@implementation ReadTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"校园春色";
            break;
        case 1:
            cell.textLabel.text = @"激情小说";
            break;
        case 2:
            cell.textLabel.text = @"黄色笑话";
            break;
        case 3:
            cell.textLabel.text = @"性爱技巧";
            break;
            
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ReadListVC* vc = [[ReadListVC alloc]init];
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    vc.title = cell.textLabel.text;
    switch (indexPath.row) {
        case 0:
            vc.readUrl = @"http://www.1100lu.us/html/xiaoshuo/xiaoyuanchunse/index.html";
            break;
        case 1:
            vc.readUrl = @"http://www.1100lu.us/html/xiaoshuo/jiqingxiaoshuo/index.html";
            break;
        case 2:
            vc.readUrl = @"http://www.1100lu.us/html/xiaoshuo/huangsexiaohua/index.html";
            break;
        case 3:
            vc.readUrl = @"http://www.1100lu.us/html/xiaoshuo/xingaijiqiao/index.html";
            break;
            
        default:
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
    /*
    http://www.1100lu.us/html/xiaoshuo/huangsexiaohua/index.html
     http://www.1100lu.us/html/xiaoshuo/xingaijiqiao/index.html
     http://www.1100lu.us/html/xiaoshuo/index.html
     http://www.1100lu.us/html/xiaoshuo/jiqingxiaoshuo/index.html
     
     */
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
