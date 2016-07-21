//
//  ViewController.m
//  GCD基本使用
//
//  Created by 李鑫 on 16/7/21.
//  Copyright © 2016年 lixin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self syncConcurrent];
}

/**
 * 同步函数 + 主队列：(情况比较特殊，一般不这么写，死路一条)
 */
- (void)syncMain
{
    NSLog(@"syncMain ----- begin");
    
    // 1.获得主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 2.将任务加入队列
    dispatch_sync(queue, ^{
        NSLog(@"1-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3-----%@", [NSThread currentThread]);
    });
    
    NSLog(@"syncMain ----- end");
}

/**
 * 异步函数 + 主队列：只在主线程中执行任务
 */
- (void)asyncMain
{
    // 1.获得主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    // 2.将任务加入队列
    dispatch_async(queue, ^{
        NSLog(@"1-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3-----%@", [NSThread currentThread]);
    });
}

/**
 * 同步函数 + 串行队列：不会开启新的线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务
 */
- (void)syncSerial
{
    // 1.创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("my.queue", DISPATCH_QUEUE_SERIAL);
    
    // 2.将任务加入队列
    dispatch_sync(queue, ^{
        NSLog(@"1-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3-----%@", [NSThread currentThread]);
    });
}

/**
 * 同步函数 + 并发队列：不会开启新的线程
 */
- (void)syncConcurrent
{
    // 1.获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2.将任务加入队列
    dispatch_sync(queue, ^{
        NSLog(@"1-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"2-----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"3-----%@", [NSThread currentThread]);
    });
    
    NSLog(@"syncConcurrent--------end");
}

/**
 * 异步函数 + 串行队列：会开启新的线程，但是任务是串行的，执行完一个任务，再执行下一个任务
 */
- (void)asyncSerial
{
    // 1.创建串行队列
    dispatch_queue_t queue = dispatch_queue_create("my.queue", DISPATCH_QUEUE_SERIAL);
    //    dispatch_queue_t queue = dispatch_queue_create("com.520it.queue", NULL);
    
    // 2.将任务加入队列
    dispatch_async(queue, ^{
        NSLog(@"1-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"2-----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"3-----%@", [NSThread currentThread]);
    });
}


/**
 * 异步函数 + 并发队列：可以同时开启多条线程
 */
- (void)asyncConcurrent
{
    // 1.创建一个并发队列
    // label : 相当于队列的名字
    //    dispatch_queue_t queue = dispatch_queue_create("com.520it.queue", DISPATCH_QUEUE_CONCURRENT);
    
    // 1.获得全局的并发队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    // 2.将任务加入队列
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<10; i++) {
            NSLog(@"1-----%@", [NSThread currentThread]);
        }
    });
   // 将任务加入队列
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<10; i++) {
            NSLog(@"2-----%@", [NSThread currentThread]);
        }
    });
    // 将任务加入队列
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i<10; i++) {
            NSLog(@"3-----%@", [NSThread currentThread]);
        }
    });
    
    NSLog(@"asyncConcurrent--------end");
    //    dispatch_release(queue);
}

@end
