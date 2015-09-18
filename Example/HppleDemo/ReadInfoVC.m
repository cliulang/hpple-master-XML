//
//  ReadInfoVC.m
//  HppleDemo
//
//  Created by zero on 15/7/20.
//
//

#import "ReadInfoVC.h"
#import "TFHpple.h"

@interface ReadInfoVC ()
@property (nonatomic,strong) TFHpple* tfHpple;
@property (nonatomic,strong) UITextView* textView;
@property (nonatomic,strong) NSString* info;
@property (nonatomic,strong) NSMutableArray* otherPageArray;;
@end

@implementation ReadInfoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_url);
    _otherPageArray = [NSMutableArray array];
    _info = @"";
    NSError* error = nil;
    NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_url] options:NSDataReadingMappedAlways error:&error];
    NSLog(@"%@",error.description);
    if(data == nil){
        return;
    }
    _tfHpple = [[TFHpple alloc]initWithHTMLData:data];
    [self getInfoFromTF:_tfHpple];
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    _textView.text = _info;
    _textView.editable = NO;
    [self.view addSubview:_textView];
//    [self getAllPage];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self getAllPage];
    });
}

- (void)getInfoFromTF:(TFHpple*)tf{
    NSArray* array = [tf searchWithXPathQuery:@"//div[@class='n_bd']"];
    for(TFHppleElement* element in array){
        NSLog(@"%@",element.content);
        _info = [NSString stringWithFormat:@"%@%@",_info,element.content];
    }
}

- (void)getAllPage{
    NSArray* array = [[_tfHpple searchWithXPathQuery:@"//div[@class='pagea']"][0]children];
    for(TFHppleElement* element in array){
        NSLog(@"%@",element.content);
        if([element.tagName isEqualToString:@"a"]){
            NSString* string = [element.attributes objectForKeyedSubscript:@"href"];
            if(string.length > 0){
                [_otherPageArray addObject:[NSString stringWithFormat:@"http://www.1100lu.us%@",string]];
            }
        }
    }
    for(NSString* string in _otherPageArray){
        NSError* error = nil;
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:string] options:NSDataReadingMappedAlways error:&error];
        NSLog(@"%@",error.description);
        TFHpple* tf = [[TFHpple alloc]initWithHTMLData:data];
        [self getInfoFromTF:tf];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _textView.text = _info;
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
