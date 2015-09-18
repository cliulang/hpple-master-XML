//
//  ViewController.m
//  HppleDemo
//
//  Created by Vytautas Galaunia on 11/25/14.
//
//

#import "ViewController.h"
#import "TFHpple.h"
@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString* string = @"http://www.1100lu.us/html/xiaoshuo/jiqingxiaoshuo/164025.html";
//    NSString* string = @"http://www.1100lu.us/html/xiaoshuo/jiqingxiaoshuo/164022.html";
    NSString* string = @"http://www.firsthospital.cn/Content/News/9909.html";
    
    NSLog(@"start");
    NSData *data = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:string]];
    NSLog(@"finished");
    TFHpple* tf = [[TFHpple alloc]initWithHTMLData:data];
    NSLog(@"%@",tf);
    NSArray* arr = [tf searchWithXPathQuery:@"//div"];
    NSLog(@"%@",arr);
//    NSArray* arr = [tf searchWithXPathQuery:@"//div[@class='pagea']"];
    NSLog(@"%lu",(unsigned long)arr.count);
    for (int i = 0; i<arr.count; i++) {
        
        TFHppleElement *aElement = [arr objectAtIndex:i];
        NSLog(@"%@",aElement.content);
        NSArray *aArr = [aElement children];
        
        for(TFHppleElement* a in aArr){
            NSLog(@"--%@",a.content);
            NSLog(@"TTag:%@",a.tagName);
        }
        
    }
    
    return;
    NSArray* array = [tf searchWithXPathQuery:@"//body"];
    for (int i = 0; i<array.count; i++) {
        
        TFHppleElement *aElement = [array objectAtIndex:i];
        NSArray* arr = [aElement searchWithXPathQuery:@"//div[id='contain']"];
        NSLog(@"%@",arr);
//        [self NSLogChildren:aElement.children];
        NSArray *aArr = [aElement children];
        
//        NSLog(@"%@",aArr);
        
        int i=0;
        for(TFHppleElement* a in aArr){
            
//            NSLog(@"--%@",a.content);
//            NSLog(@"TTag:%@",a.tagName);
            NSLog(@"%i",i);
            i++;
            if([a.tagName isEqualToString:@"div"]){
                [self NSLogChildren:a.children];
            }
        }
    }
    
}

- (void)NSLogChildren:(NSArray*)children{
    
    for(TFHppleElement* element in children){
       NSLog(@"tag:%@-content:%@-raw:%@ -\n-----------------------------------\n",element.tagName,element.content,element.raw);
        [element searchWithXPathQuery:@""];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
