#import "GCDWebServerDataResponse.h"
#import "GCDWebServerErrorResponse.h"
#import "GCDWebServerDataRequest.h"
#import "GCDWebServer.h"
#import "LookinHierarchyInfo.h"
#import "LookinDisplayItem.h"
%ctor{
    GCDWebServer *webServer = [[GCDWebServer alloc] init];
    [webServer addHandlerForMethod:@"GET"
                              path:@"/test"  requestClass:[GCDWebServerDataRequest class]  processBlock:^GCDWebServerResponse *(GCDWebServerDataRequest *request) {
        // 1. 创建信号量用于同步等待
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        __block GCDWebServerDataResponse *finalResponse;

        // 2. 异步处理数据
        dispatch_async(dispatch_get_main_queue(), ^{
            // 2.1 获取数据
            LookinHierarchyInfo *info = [LookinHierarchyInfo staticInfoWithLookinVersion:@"1.0.9"];
            NSMutableArray *itemsArray = [NSMutableArray array];
        
            // 2.2 遍历转换数据
            for (LookinDisplayItem *item in info.displayItems) {
                NSDictionary *itemDict = [item toJson];
                if (itemDict) {
                    [itemsArray addObject:itemDict];
                }
            }
            
            // 2.3 构建JSON
            NSDictionary *jsonData = @{
                @"success": @YES,
                @"items": itemsArray,
                @"count": @(itemsArray.count)
            };
            
            // 2.4 创建响应
            finalResponse = [GCDWebServerDataResponse responseWithJSONObject:jsonData];
            [finalResponse setValue:@"*" forAdditionalHeader:@"Access-Control-Allow-Origin"];
            [finalResponse setValue:@"Content-Type" forAdditionalHeader:@"Access-Control-Allow-Headers"];
            
            // 2.5 通知完成
            dispatch_semaphore_signal(semaphore);
        });

        // 3. 等待异步操作完成
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        // 4. 返回最终结果
        return finalResponse;
	}];

    NSError *error = nil;
    // 使用同步启动方式确保启动完成
    BOOL success = [webServer startWithOptions:@{
        GCDWebServerOption_Port: @(8082),
        GCDWebServerOption_BindToLocalhost: @NO,
        GCDWebServerOption_AutomaticallySuspendInBackground: @NO
    } error:&error];
}