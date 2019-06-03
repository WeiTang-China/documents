# Oppo短信项目总结

| 版本 | 修订人 | 日期 | 描述 |
| :-: | :-: | :-: | :------- |
| v1.0 | 唐炜 | 2019-5-29 | 梳理ComposeMessageActivity的分页刷新逻辑 |



## 1、基础知识

### 1.1、Android Studio快捷键

#### 1.1.1、代码阅读及查看

Ctrl + Alt + H，查看某个方法的全部调用栈

Ctrl + H，查看某个类的继承关系

Ctrl + Shift + H，查看某个方法有哪些继承实现

Ctrl + Shift + I，快速查看某个方法、类、接口的内容

Ctrl + Alt + F7，弹窗查看某个符号的所有引用

Alt + 7，查看某个类的详情，可以展示某个方法是从哪个接口继承的

Ctrl + U，查看某个方法是从哪个接口或者父类继承的

Ctrl + Alt + B，跳转到抽象方法的实现

Alt + F7，快速查找某个类、方法、变量、资源id被调用的地方

#### 1.1.2、查找、替换

Ctrl + Shift + F7，在文件中高亮显示某个字符串，F3或Shift+F3可以上下移动

#### 1.1.3、编辑视窗快捷功能

Ctrl + W，选中代码块，多次按会扩大范围

Ctrl + D，快速复制行

Ctrl + Shift + ↑ ↓，上下移动代码，如果是方法中的代码，不能挪出方法

Shift + Alt + ↑ ↓，上下移动代码，可以跨方法移动

Alt + Insert，快速插入代码，生成构造方法、Getter/Setter方法等

Alt + Enter，快速修复错误

#### 1.1.4、窗口&面板

Ctrl + Shift + F12，快速调整代码编辑窗口的大小

Shift + Esc，关闭当前打开的面板



### 1.2、AbsListView.OnScrollListener

#### 1.2.1、onScrollStateChanged

```java
@Override
public void onScrollStateChanged(AbsListView view, int scrollState) {
}
```

scrollState有三种状态：

- SCROLL_STATE_TOUCH_SCROLL：开始滚动的时候调用，调用一次
- SCROLL_STATE_IDLE：滚动事件结束的时候调用，调用一次
- SCROLL_STATE_FLING：当手指离开屏幕，并且产生惯性滑动的时候调用，可能会调用<=1次

在没有做出抛的动作时，只会回调两次；有抛的动作时，会有三次回调。

#### 1.2.2、onScroll

```java
@Override
public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
}
```

在滑动屏幕的过程中，onScroll方法会一直调用：

- firstVisibleItem： 当前屏幕显示的第一个item的位置（下标从0开始）
- visibleItemCount：当前屏幕可以见到的item总数，包括没有完整显示的item
- totalItemCount：Item的总数，** 包括通过addFooterView添加的那个item **

!!!注意：

在listview的item发生变化的时候（初始化/notifyDataSetChanged()），onScroll会被调用：

![](files\OnScrollListener_onScroll()_notifyDataSetChanged().webp.jpg)



### 1.3、Uri详解

参考网址：[Uri详解之——Uri结构与代码提取](https://blog.csdn.net/harvic880925/article/details/44679239)

#### 1.3.1、URI与Uri

名称如此相像的两个类是有什么区别和联系？

1. 所属的包不同。URI位置在java.net.URI,显然是Java提供的一个类。而Uri位置在android.net.Uri,是由Android提供的一个类。所以初步可以判断，Uri是URI的“扩展”以适应Android系统的需要。
2. 作用的不同。URI类代表了一个URI（这个URI不是类，而是其本来的意义：通用资源标志符——Uniform Resource Identifier)实例。Uri类是一个不可改变的URI引用，包括一个URI和一些碎片，URI跟在“#”后面。建立并且转换URI引用。而且Uri类对无效的行为不敏感，对于无效的输入没有定义相应的行为，如果没有另外制定，它将返回垃圾而不是抛出一个异常。

看不懂？没关系，知道这个就可以了：Uri是Android开发的，扩展了JAVA中URI的一些功能来特定的适用于Android开发，所以大家在开发时，只使用Android 提供的Uri即可；

#### 1.3.2、Uri结构

基本形式：

> `[scheme:]scheme-specific-part[#fragment]`

进一步划分：

> `[scheme:][//authority][path][?query][#fragment]`

其中有下面几个规则：
  - path可以有多个，每个用/连接，比如
    scheme://authority/path1/path2/path3?query#fragment
  - query参数可以带有对应的值，也可以不带，如果带对应的值用=表示，如:
    scheme://authority/path1/path2/path3?id = 1#fragment，这里有一个参数id，它的值是1
  - query参数可以有多个，每个用&连接
    scheme://authority/path1/path2/path3?id = 1&name = mingming&old#fragment
    这里有三个参数：
    参数1：id，其值是:1
    参数2：name，其值是:mingming
    参数3：old，没有对它赋值，所以它的值是null
  - 在android中，除了scheme、authority是必须要有的，其它的几个path、query、fragment，它们每一个可以选择性的要或不要，但顺序不能变，比如：
    其中"path"可不要：scheme://authority?query#fragment
    其中"path"和"query"可都不要：scheme://authority#fragment
    其中"query"和"fragment"可都不要：scheme://authority/path
    "path","query","fragment"都不要：scheme://authority
    等等……

终极划分:

> `[scheme:][//host:port][path][?query][#fragment]`

#### 1.3.4、代码提取

Uri中提取各部分的接口，以下面的Uri字符串为例：

> `http://www.java2s.com:8080/yourpath/fileName.htm?stove=10&path=32&id=4#harvic`

- `getScheme()`: 获取Uri中的scheme字符串部分，在这里即，`http`

- `getSchemeSpecificPart()`: 获取Uri中的scheme-specific-part:部分，这里是`//www.java2s.com:8080/yourpath/fileName.htm?`

- `getFragment()`: 获取Uri中的Fragment部分，即`harvic`

- `getAuthority()`: 获取Uri中Authority部分，即`www.java2s.com:8080`

- `getPath()`: 获取Uri中path部分，即`/yourpath/fileName.htm`

- `getQuery()`: 获取Uri中的query部分，即`stove=10&path=32&id=4`

- `getHost()`: 获取Authority中的Host字符串，即`www.java2s.com`

- `getPost()`: 获取Authority中的Port字符串，即`8080`

- `List< String> getPathSegments()`: 上面我们的getPath()是把path部分整个获取下来：`/yourpath/fileName.htm`，`getPathSegments()`的作用就是依次提取出Path的各个部分的字符串，以字符串数组的形式输出。以上面的Uri为例：

  ```java
  String mUriStr = "http://www.java2s.com:8080/yourpath/fileName.htm?stove=10&path=32&id=4#harvic";
  Uri mUri = Uri.parse(mUriStr);
  List<String> pathSegList = mUri.getPathSegments();
  for (String pathItem:pathSegList){
      Log.d("qijian","pathSegItem:"+pathItem);
  }
  ```

  输出结果为：
  
  ![](files\Uri_getPathSegments_result.png)


- `getQueryParameter(String key)`: 在上面我们通过`getQuery()`获取整个query字段：`stove=10&path=32&id=4`，`getQueryParameter(String key)`作用就是通过传进去path中某个Key的字符串，返回他对应的值。

  ```java
  String mUriStr = "http://www.java2s.com:8080/yourpath/fileName.htm?stove=10&path=32&id#harvic";
  mUri = Uri.parse(mUriStr);
  Log.d(tag,"getQueryParameter(\"stove\"):"+mUri.getQueryParameter("stove"));
  Log.d(tag,"getQueryParameter(\"id\"):"+mUri.getQueryParameter("id"));
  ```

  结果如下：

  ![](files\Uri_getQueryParameter_result.png)

- `buildUpon()`: 返回`Uri.Builder`可以对原有Uri做修改

  ```java
  Uri newUri = oldUri.buildUpon().appendQueryParameter("display_message_count", "100").build();
  ```



## 2、短信列表界面（ComposeMessageActivity）

conversation对应的uri=content://mms-sms-local//conversations/%ThreadId%?display_message_count=50&block_threads_flag=false

Provider实现侧：

- `query()`，`URI_MATCHER`分流`URI`在*`URL_CONVERSATIONS_MESSAGES`*处理
- 缓存display_message_count到成员变量mDisplayMessageCount
- `getConversationMessages()`，拼接执行rawSql
- `buildConversationQuery()`，`unionQueryBuilder.buildUnionQuery(..., mDisplayMessageCount)`控制返回数据的`LIMIT`

![](files\Mms_MessageListActivity.png)



### 2.1、下拉刷新和条数控制是如何实现的？

PullToRefreshListView的状态图如下所示：

![](files\PullToRefreshListView_mState.png)

具体代码逻辑如下所示：

```java
// ComposeMessageActivity.mHasMoreMessage
// OnQueryComplete()回调中改写，请求的数量等于Cusor返回的数量，则认为有更多消息
mHasMoreMessage=(mMsgListAdapter.getCount()==mDisplayMessageCount);
// ComposeMessageActivity.onScrollItemAfterItemListener.onScroll()中使用，设置firstItemIndex
if (mHasMoreMessage && !mIsSearchMessage) {
	mMsgListView.setFirstItemIndex(firstVisibleItem);
}
else {
    mMsgListView.setFirstItemIndex(-1);
}
// PullToRefreshListView.onTouchEvent()中处理ACTION_DOWN事件时，当mFirstItemIndex指向第一条时，标志开始拖动刷新事件，记录下拉起始坐标
case MotionEvent.ACTION_DOWN:
	if ((mFirstItemIndex == 0) && !mIsRecored) {
        mIsRecored = true;
        mStartY = (int) event.getY();
    }
break;
// PullToRefreshListView.onTouchEvent()中处理ACTION_MOVE事件时，根据各种状态判断处理，并切换状态和重绘界面
private final static int RATIO = 2;
case MotionEvent.ACTION_MOVE:
	int tempY = (int) event.getY();
	if (!mIsRecored) break;
	if (tempY <= mStartY) break;
	if (mState == REFRESHING || mState == LOADING) break;
	
	int diffY = tempY - mStartY;
	int diff_halfDiffY_headHeight = (tempY-mStartY)/RATIO-mHeadContentHeight;
	if (mState == DONE) {// 初始状态
        if (diffY > 0) {
            mState = PULL_TO_REFRESH;
            changeHeaderViewByState();
        }
    }
	else if (mState == PULL_TO_REFRESH) {// 拖动等待状态
        if (diffY <= 0) {
            mState = DONE;
            changeHeaderViewByState();
        }
        else if (diff_halfDiffY_headHeight >= 0) {
            mState = RELEASE_TO_REFRESH;
            mIsBack = true;
            changeHeaderViewByState();
        }
    }
	else if (mState == RELEASE_TO_REFRESH) {// 等待释放刷新状态
        if (diffY <= 0) {
            mState = DONE;
            changeHeaderViewByState();
        }
        else if (diff_halfDiffY_headHeight < 0) {
            mState = PULL_TO_REFRESH;
            changeHeaderViewByState();
        }
    }

	// 调整mHeadView的paddings
	if (mState == PULL_TO_REFRESH) {
        mHeadView.setPadding(0, diff_halfDiffY_headHeight, 0, 0);
    }
	else if (mState == RELEASE_TO_REFRESH) {
        int paddingTop = Math.min(diff_halfDiffY_headHeight, mFixedHeadViewPaddingTop);
        mHeadView.setPadding(0, paddingTop, 0, 0);
    }
break;

// PullToRefreshListView.onTouchEvent()中处理ACTION_UP事件时，切换状态；REFRESHING状态等待注册给AbsListView的OnScrollListener.onScrollStateChanged()回调触发PullToRefreshListView.onRefreshRelease()，OnScrollListener回调接口在ComposeMessageActivity.initResourceRefs()注册的
case MotionEvent.ACTION_UP:
	mDynamicHeadViewPaddingTop = Math.min(mFixedHeadViewPaddingTop, mHeadView.getPaddingTop());
	if (mState != REFRESHING && mState != LOADING) {
        // 按键操作只会在DONE、PULL_TO_REFRESH、RELEASE_TO_REFRESH之间做状态跳转
        if (mState == RELEASE_TO_REFRESH) {
            mState = REFRESHING;
            changeHeaderViewByState();
        }
        else if (mState == PULL_TO_REFRESH) {
            mState = DONE;
            changeHeaderViewByState();
        }
        else {
            /* do nothing */
        }
    }
	// 清除一次按键事件处理的缓存(DOWN->MOVE->...->MOVE->UP)
	mIsRecored = false;
	mIsBack = false;
break;

// ComposeMessageActivity.initResourceRefs()...
// 给AbsListView注册OnScrollListener回调接口
mMsgListView.setOnScrollListener(new PushMessageListOnScrollListener(onScrollItemAfterListener/*成员变量，内部匿名类*/));

// ComposeMessageActivity.onScrollItemAfterListener.onScrollStateChanged()回调中，当滚动停止时，执行刷新
@Override
public void onScrollStateChanged(AbsListView view, int scrollState) {
    if (scrollState == SCROLL_STATE_IDLE) {
        mMsgListView.onRefreshRelease();
    }
}

// PullToRefreshListView.onRefreshRelease()，执行刷新操作
public void onRefreshRelease() {
    // 这些判断条件还需要研究下，有些判断条件有点无厘头
    if (mHeadContentHeight == -1 * mDynamicHeadViewPaddingTop) return;
    if (mProgressBar.getVisibility() != View.VISIBLE) return;
    // 猜测是为了第一次初始化响应，还需要再研究
    if (mState != REFRESHING || mState != DONE) return;
    mTopDiff = -1;
    mUpdateHandler.post(mUpdateThRunnable);
}

// PullToRefreshListView.mUpdateThRunnable /* 成员变量，匿名类初始化 */
Runnable mUpdateThRunnable = new Runnable() {
    private static final int DISTANCE_REFRESHING = 11;
    private static final int DISTANCE_REFRESH_DONE = 6;
    @Override
    public void run() {
        mTopDiff += (mState==REFRESHING) ? DISTANCE_REFRESHING : DISTANCE_REFRESH_DONE;
        Message msg = mUpdateHandler.obtainMessage();
        msg.arg1 = mTopDiff;
        msg.sendToTarget();
    }
}
// PullToRefreshListView.init(Context)...
// PullToRefreshListView.mUpdateHandler，UI线程Handler
// mHeadCountHeight，只在init(Context)被写入，值为HeadView的measureHeight
// mDynamicHeadViewPaddingTop，只在TouchEvent的ACTION_UP事件中被写入，值为Math.min(mFixedHeadViewPaddingTop, mHeadView.getPaddingTop())
// mFixedHeadViewPaddingTop，通过res加载，值为7dip的像素值，我觉得命名为maxPaddingTop更为贴切
// 这一段流程是为了做进度条上移动画
mUpdateHandler = new Handler() {
    @Override
    public void handleMessage(Message msg) {
        int top = msg.arg1;
        if (top - mDynamicHeadViewPaddingTop < mHeadCountHeight) {
            mHeadView.setPadding(0, mDynamicHeadViewPaddingTop - top, 0, 0);
            mUpdateHandler.post(mUpdateThRunnable);
        }
        else {
            mHeadView.setPadding(0, -1 * mHeadContentHeight, 0, 0);
            mColorLoadingView.setVisibility(View.GONE);
            if (mState == REFRESHING) {
                onRefresh();
            }
        }
    }
}
// PullToRefreshListView.onRefresh()，回调注册的OnRefreshListener接口函数OnRefresh(); OnRefreshListener回调接口在ComposeMessageActivity.initMessageList()注册。
private void onRefresh() {
    mRefreshListener.onRefresh();
}

// ComposeMessageActivity.initMessageList()...
// 给PullToRefreshListView注册OnRefreshListener()回调接口
// mIsPullListViewLoadMoreMessage标记当前是因为重新加载数据导致的界面滚动，需要滚动到之前阅读的条目上；具体实现参考ComposeMessageActivity.smoothScrollToEnd(boolean, int)
mMsgListView.setonRefreshListener(new OnRefreshListener() {
    @Override
    public void onRefresh() {
        mDisplayMessageCount += MAX_DISPLAY_MESSAGE;
        mIsPullListViewLoadMoreMessage = true;
        ComposeMessageActivity.this.startMsgListQuery();
        mMsgListView.onRefreshComplete();
    }
});

// PullToRefreshListView.onRefreshComplete()，切换PullToRefreshListView状态
public void onRefreshComplete() {
    mState = DONE;
    changeHeaderViewByState();
}

// startMsgListQuery()会异步触发回调函数ComposeMessageActivity.BackgroundQueryHandler.onQueryComplete(int, Object, Cursor)
protected void onQueryComplete(int token, Object cookie, Cursor cursor) {
    ......;
    // 计算上次加载的数量: mLastLoadMessageCount
    // 计算是否还有更多消息: mHasMoreMessage
    int count = mMsgListAdapter.getCount();
    if (count == mDisplayMessageCount) {
        // 加载了一整个页面的数量
        mLastLoadMessageCount = MAX_DISPLAY_MESSAGE;
        mHasMoreMessage = true;
    }
    else {
        if (count < MAX_DISPLAY_MESSAGE) {
            // 第一页
            mLastLoadMessageCount = count;
        }
        else {
            // 每次mDisplayMessageCount增加MAX_DISPLAY_MESSAGE，所以请求前的数量为mDisplayMessageCount - MAX_DISPLAY_MESSAGE
            mLastLoadMessageCount = count - (mDisplayMessageCount - MAX_DISPLAY_MESSAGE);
        }
        mHasMoreMessage = false;
    }
    
    cursor.moveToLast();
    long lastMsgId = cursor.getLong(COLUMN_ID);
    
    // 当发送消息时，mScrollOnSend被设置为true；在发送一条消息后，自动滚动到最下面，但因为需要等待，直到数据库操作完成，所以该机制在这里实现；参考ComposeMessageActivity.sendMessage(boolean)
    // lastMsgId != mLastMessageId代表消息列表底部有更新
    boolean forceScrollToEnd = mNewMsgFlg || mScrollOnSend || lastMsgId != mLastMessageId;
    int result = smoothScrollToEnd(forceScrollToEnd, 0);
    if (mNewMsgFlag && result > 0) {
        mNewMsgFlag = false;
        mMsgListView.setSelection(mMsgListView.getCount());
    }
    mLastMessageId = lastMsgId;
    mScrollOnSend = false;
}

/**
* 
**/
private int smoothScrollToEnd(boolean force, int listSizeChange) {
    ......;
    if (willScroll || (lastItemTooTall && lastItemInList == lastItemVisible)) {
        mMsgListView.setSelectionFromTop(lastItemInList, -20000);
    }
    else if (mIsPullListViewLoadMoreMessage) {
        mMsgListView.setSelectionFromTop(mLastLoadMessageCount + 1, (int) getResources().getDimension(R.dimen.oppo_refresh_message_top_item_position));
    }
    mIsPullListViewLoadMoreMessage = false;
    return 1;
}


// ----------------------------------------------------------
// 部分核心功能函数的分析

// 集中来分析下出现很多次的changeHeaderViewByState()函数
// 它的作用是根据不同的状态，刷新界面显示
private void changeHeaderViewByState() {
    // UI操作
    switch(mState) {
        case PULL_TO_REFRESH:
        case RELEASE_TO_REFRESH:
        case REFRESHING:
            mProgressBar.setVisibility(View.VISIBLE);
            mColorLoadingView.setVisibility(View.VISIBLE);
        break;
    }
    switch(mState) {
        case PULL_TO_REFRESH:
            if (mIsBack) mIsBack = false;
        break;
        case REFRESHING:
            mHeadView.setPadding(0, mDynamicHeadViewPaddingTop, 0, 0);
        break;
    }
}

// PushMessageListOnScrollListener.java
// 仅转发onScroll和onScrollChanged两个回调消息
public class PushMessageListOnScrollListener implements AbsListView.OnScrollListener {
    private AbsListView.OnScrollListener mDelegate;
    private boolean mFirst = true;
    
    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        mDelegate.onScrollStateChanged(view, scrollState);
    }
    
    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
        if (mFirst) {
            if (isEmptyView(view, totalItemCount)) return;
            if (firstVisibleItem + visibleItemCount == totalItemCount) {
                // reach the end of ListView
                mFirst = false;
            }
        }
        if (!mFirst) {
            mDelegate.onScroll(view, firstVisibleItem, visibleItemCount, totalItemCount);
        }
    }
}

// OnScrollItemAfterItemListener.java
public abstract class OnScrollItemAfterItemListener implements OnScrollListener {
    private int mOldFirstVisibleItem = -1;
    private int mOldLastVisibleItem = -1;
    private boolean mInited;
    
    @Override
    public void onScrollStageChanged(AbsListView view, int scrollState) { /* nothing */ }
    
    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
        if (!mInited) {
            mInited = true;
            mOldFirstVisibleItem = firstVisibleItem;
            mOldLastVisibleItem = firstVisibleItem + visibleItemCount;
            onFirstScroll(view, firstVisibleItem, visibleItemCount, totalItemCount);
        }
        else {
            int lastVisibleItem = firstVisibleItem + visibleItemCount;
            if (mOldFirstVisibleItem > firstVisibleItem) {
                // scroll down, firstVisibleItem is the item which entering screen
                onItemScroll(view, firstVisibleItem, totalItemCount);
            }
            if (mOldLastVisibleItem < lastVisibleItem) {
                // scroll up, lastVisibleItem is the item which entering screen
                onItemScroll(view, lastVisibleItem-1, totalItemCount);
            }
            mOldFirstVisibleItem = firstVisibleItem;
            mOldLastVisibleItem = lastVisibleItem;
        }
    }
    
    public abstract void onItemScroll(AbsListView view, int enterScreenItem, int totalItemCount);
    
    public abstract void onFirstScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount);
}

// ComposeMessageActivity.java
// onScrollItemAfterItemListener成员变量，内部类
private OnScrollItemAfterItemListener onScrollItemAfterItemListener = new OnScrollItemAfterItemListener() {
    @Override
    public void onScrollStateChanged(AbsListView view, int scrollState) {
        if (scrollState == SCROLL_STATE_IDLE) {
            mMsgListView.onRefreshRelease();
        }
        super.onScrollStateChanged(view, scrollState);
    }
    
    @Override
    public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalCount) {
        if (mHasMoreMessage && !mIsSearchMessage) {
            mMsgListView.setFirstItemIndex(firstVisibleItem);
        }
        else {
            mMsgListView.setFirstItemIndex(-1);
        }
        
        if (mUnreadCount > 0 && mFirstUnreadOffset > 0) {
            if ((mMsgListAdapter.getCount() - firstVisibleItem) >= mFirstUnreadOffset) {
                mFirstUnreadOffset = 0;
                mFirstUnreadMsgId = -1L;
                mFirstUnreadMsgType = null;
                mUnreadCount = 0;
                hideUnreadScrollView();
            }
        }
        
        super.onScroll(view, firstVisibleItem, visibleItemCount, totalItemCount);
    }
    
    @Override
    public void onFirstScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalCount) {
        // only have dotting logics. ommit them.
    }
    
    @Override
    public void onItemScroll(AbsListView view, int enterScreenItem, int totalItemCount) {
        // only have dotting logics. ommit them.
    }
}
```



### 2.2、存疑代码

#### 2.2.1、PullToRefreshListView处理ACTION_MOVE时，也切换了mIsRecored状态，意味着按下事件的起点不是第一个元素时，也可能会触发下拉刷新

```java
case MotionEvent.ACTION_MOVE:
	int tempY = (int) event.getY();
    if (!mIsRecored && mFirstItemIndex == 0) {
        mIsRecored = true;
        mStartY = tempY;
    }
    ......
break;
```

Answers:



#### 2.2.2、PullToRefreshListView处理ACTION_MOVE时，只要拖动距离大于0就进入PULL_TO_REFRESH状态，是不是太容易触发了？

```java
case MotionEvent.ACTION_MOVE:
    ......
    if (mState == DONE) {
        if (tempY - mStartY > 0) {
            mState = PULL_TO_REFRESH;
            changeHeaderViewByState();
        }
    }
	......
break;
```

Answers:



#### 2.2.3、PullToRefreshListView的状态机中LOADING状态并未使用

如图所示：

![](files\PullToRefreshListView_mState.png)

Answers:



## 3、Push消息列表界面（PushMessageListActivity）

初始化数据有4个调用：

> PushMessageListActivity.onCreate(Bundle)
>
> PushMessageListActivity.PushContentObserver.onChange(boolean, Uri)
>
> PushMessageListActivity.onNewIntent(Intent)
>
> PushMessageListActivity$mBlockUpdateReceiver.onReceive(Context, Intent)

$表示内部匿名类

![](files\PushMessageListActivity_loadData.png)

getMessageByServiceId()：

```java
// 参数包装，serviceId
GetPmmsByServiceId gpbsi = new GetPmmsByServiceId(serviceId, where, listener, isBlock);
// 线程转发，切换到WorkderThread执行GetPmmsByServiceId.run()
```

GetPmmsByServiceId.run():

```java
// 环境准备...

// 查询pmms消息列表
List<PmmsEntry> pmmsEntries = PushMessageSQLiteHelper.getInstance(ctx).getPmmsEntryListByServiceId(mServiceId, mWhere, mIsBlock);
// 查询shop信息
ShopEntry shopEntry = PushMessageSQLiteHelper.getInstance(ctx).queryShopEntry(mServiceId);
// 给每个pmms消息装填messageSource...

// 通过uiHandler回调listener...
```

### 3.1、PushMessageListAdapter在PushMessageListActivity中的依赖

1. `refreshListView(boolean needReSelect)`

   `mPushMessageManager.getMessageByServiceId()`的回调接口：

   ```java
   new PushMessageManager.OnPmmsReceivedListener() {
       @Override
       public void onReceived(List<PmmsEntry> list) {
           ......;
           Message msg = mHandler.obtain(MsgConstants.MSG_QUERY_LOCAL_PMMSENTRIES_FINISHED);
           msg.obj = list.get(list.size() - 1);
           mHandler.sendMessage(msg);
   // 根据最后一条消息刷新Menu
   // 可以修改为部分加载，因为部分加载总是从底部倒数取N条
   
           int selectPosition = -1;
           for(PmmsEntry entry : list) {
               if (entry.getMmsId() == selectedId) {
                   selectPosition = list.IndexOf(entry);
                   break;
               }
           }
           if (selectionPosition != -1) {
               mMsgListAdapter.setPushSearchPosition(selectPosition);
               if (selectPosition == 0) {
                   mMsgListView.smoothScrollBy(0, 0);
               }
               else {
                   mMsgListView.setSelection(position);
               }
           }
   // 对数据完整性有依赖，如果只返回部分数据，会影响逻辑！
   // 搜索通过遍历整个list完成，效率比较低，需要重构
   
           if (SettingsHolder.isOppoPushEnable(context)) {
               // ......
               // 从list中过滤掉MSG_TYPE_SMS_OUT消息，添加到arrayList
               mMsgListAdapter.setReceivePmmsEntryList(arrayList);
           }
   // 对数据完整性有依赖，如果只返回部分数据，会影响逻辑！
   // 维护mReceivePmmsEntryList的意义在于：
   // PushMessageListActivity.sendMessage()方法中
   // isTeddyPush = "teddy".equals(mShopEntry.getShopSource())
   // if (SettingsHolder.isOppoPushEnable(this) && !isTeddyPush) {
   //     doSomething......
   // }
           mMsgListAdapter.clear();
           mMsgListAdapter.addAll(mPmmsEntryList);
   // 可以修改接口为CursorAdapter.changeCursor()
   
           mMsgListAdapter.setIsFraudCautionThread(isFraudCautionThread());
   // 对数据完整性有依赖，如果只返回部分数据，会影响逻辑！
   // isFraudCautionThread()通过遍历所有entry，找到mReceiveType==1 && mMediaType==MSG_TYPE_FRAUD_CAUTION，则返回true
           
           if (needReSelect) {
               mMsgListView.setSelectionFromTop(mMsgListAdapter.getCount()-1, -20000);
           }
   // 可以修改为部分加载，因为部分加载总是从底部倒数取N条，滚动到最底部与上面的数据无关
           
           if (mUnreadCount <= 0) {
               mUnreadCount = mConversation.getUnreadMessageCount();
               if (mUnreadCount > 0) {
                   getUnreadOffset(list);
                   if (mFirstUnreadOffset > 0) {
                       showUnreadScrollView();
                   }
               }
           }
   // 对数据完整性有依赖，如果只返回部分数据，会影响逻辑！
   // getUnreadOffset()是根据list数据遍历的，这块儿还需要参考一下ComposeMessageActivity的实现方法
       }
   }
   ```

   

2. `initMessageList()` - **1** reference in `onCreate(Bundle)`, before `refreshListView(true)`

   ```java
   mMsgListAdapter = new PushMessageListAdapter(this, mHandler, 0, mPmmsEntryList, mMsgListView, mPushMessageManager);
   // 初始化代码；mHandler是主Looper的Handler；mPmmsEntryList为空的ArrayList；mPushMessageManager是单例对象，组合了很多业务逻辑及异步加载；
   
   mMsgListAdapter.setCurrentNum(mNumber);
   // 与数据无关，记录当前number给action用
   
   if (FeatureOption.TED_FUNC_SMART_MESSAGE) {
       mMsgListAdapter.setBubbleController(mBubbleController);
   }
   // 与数据无关，构造View时透传给PushTextMessageItem
   
   mMsgListView.setRefreshable(false);
   // 需要修改为true
   
   mMsgListAdapter.setIsInMultiWindowMode(isInMulitiWindowMode());
   // 与数据无关，透传给MessageItem，适配分屏模式
   
   mMsgListAdapert.setBlockMessage(mIsBlocked);
   // 与数据无关，标识是否为黑名单页面
   ```

   

3. `smoothScrollToEnd(boolean force, int listSizeChange)` - **2 Anonymous** references in `onSizeChanged(int, int, int, int)`

   ```java
   mMsgListView.setSelectionFromTop(mMsgListAdapter.getCount()-1, -20000);
   // 可以修改为部分加载，因为部分加载总是从底部倒数取N条，滚动到最底部与上面的数据无关
   ```

   

4. `ModeCallback.getCheckedMessageItems()` - **3** references in inner-class `ModeCallback`

   - `onCreateActionMode(ActionMode, Menu)`
   - `onNavigationItemSelected(MenuItem)`
   - `prepareSingleSelectionMenu()`

   ```java
   HashSet<Integer> positionSet = null;
   if (mCheckable != null) {
       positionSet = mCheckable.getCheckedItemInPositions();
   }
   return mMsgListAdapter.getCheckedItems(positionSet);
   // 可以修改为部分加载，因为取的相对位置
   // 但是，此时与加载更多冲突了，需要研究一下解决冲突的办法，待定
   //   1. 禁止加载更多
   //   2. 加载更多后，更新OppoEditableListView.EditableListData.mIdPositionMap，或者粗暴一点，清除所有的checked状态
   ```

5. `ModeCallback.updateMenu(int checkedCount)` - **4** references in inner-class `ModeCallback`

   - `onCheckStateChanged(EditableListViewCheckable)`
   - `onRefreshSelectedButton()` **2** usages
   - onCreateActionMode(ActionMode, Menu)

   ```java
   int totalCount = mMsgListAdapter.getCount();
   ......;
   if (checkedCount == totalCount) {
       mSelectMenu.setTitle("Undo");
       mIsAllSelected = true;
   }
   else {
       mSelectMenu.setTitle("Select All");
       mIsAllSelected = false;
   }
   // 可以修改为部分加载，界面也应该用本地数据来判断是否全部选中
   ```

   

6. `ModeCallback.onActionItemClicked(final ActionMode mode, MenuItem item)` - **1** reference in `OppoEditableListView.EditModeWrapper.onActionItemClicked(ActionMode, MenuItem)`

   ```java
   switch(item.getItemId()) {
       case R.id.action_cancel: {
           if (mMsgListAdapter.getCheckCount() > 0) {
               mMsgListAdapter.clearAllItemChecked();
               mMsgListAdapter.notifyDataSetChanged();
           }
       } break;
   }
   // 可以修改为部分修改，仅用来取消所有的选中状态，本地数据足够了
   ```

   

7. `ModeCallback.onCreateActionMode(ActionMode mode, Menu menu)` - **1** reference in `OppoEditableListView.EditModeWrapper.onCreateActionMode(ActionMode, Menu)`

   ```java
   ......;
   mMsgListAdapter.enterCheckMode();
   // 与数据无关，进入item选择模式
   ```

   

8. `ModeCallback.onDestroyActionMode(ActionMode arg0)` - **1** reference in `OppoEditableListView.EditModeWrapper.onDestroyActionMode(ActionMode)`

   ```java
   mMsgListAdapter.exitCheckMode();
   // 与数据无关，退出item选择模式
   ```

   

9. `ModeCallback.onCheckStateChanged(OppoEditableListView.EditableListViewCheckable editableListViewCheckable)` - **1** reference in `OppoEditableListView.EditModeWrapper.onCheckStateChanged(OppoEditableListView.EditableListViewCheckable)`

   ```java
   mMsgListAdapter.setCheckedItem(mCheckable.getCheckedItemInIds());
   // 与数据无关，根据传入的checkable设置选中的item
   ```

   

10. `ModeCallback.onVisibleViewCheckStateChanged(View view, boolean isChecked)` - **1** reference in `OppoEditableListView.EditModeWrapper.onVisibleViewCheckStateChanged(View, boolean)`

    ```java
    if (view != null) {
        mMsgListAdapter.bindItemViewBg(view, isChecked);
    }
    // 与数据无关，根据传入的isChecked更新界面
    ```

    

11. `onStatusBarClicked()` - **callback** - **1** register in `PushMessageListActivity.onCreate(Bundle)`

    register code:

    ```java
    mStatusUtil = new ColorStatusBarResponseUtil(this);
    mStatusUtil.setStatusBarClickListener(this);
    ```

    ```java
    ......;
    if (null != mMsgListAdapter) {
        mMsgListAdapter.dismissFloatPanelView();
    }
    // 与数据无关，消除悬浮panel
    ```

    

12. `onClick(View v)` - **callback** - **4** register in `PushMessageListActivity`

    - `initResourceRefs()` **2** usages

    - `initSimChangeButton()` **2** usages

    register code:

    ```java
    private void initResourceRefs() {
        ......;
        mSendButton.setOnClickListener(this);
        ......;
        mRemindview.setOnClickListener(this);
        ......;
    }
    private void initSimChangeButton() {
        ......;
        mSim1Button.setOnClickListener(this);
        mSim2Button.setOnClickListener(this);
        ......;
    }
    ```

    ```java
    case R.id.unread_scroll_textview:
        reCalFirstUnreadOffset();
        int count = mMsgListAdapter.getCount();
        int position = (count - mFirstUnreadOffset >= 0) ? count - mFirstUnreadOffset : 0;
        mMsgListView.smoothScrollToPosition(position);
        mFirstUnreadOffset = 0;
        mFirstUnreadMsgId = null;
        mUnreadCount = 0;
        hideUnreadScrollView();
    // 可以改为部分加载
    // mFirstUnreadOffset记录从底部到未读第一条的偏移量，本地数据足够计算
    // 问题是部分加载不能完全展示所有未读的消息
    ```

13. `onKeyDown(int keyCode, KeyEvent keyEvent)` 

    ```java
    if (keyCode == KeyEvent.KEYCODE_BACK) {
        if (keyEvent.getRepeatCount() == 0 && mMsgListAdapter != null) {
            if (mMsgListAdapter.needEnterTwiceBackKey()) {
                mMsgListAdapter.onKeyDown();
                return true;
            }
        }
    }
    // 与数据无关，为了关闭悬浮弹窗
    ```

    

14. `sendMessage(String serviceId, final String content, final String phone, String name, long threadId, String imsi)` - **2** references

    ```java
    PmmsEntry pmmsEntry = mPushMessageManager.getRightImsiPmmsEntry(PushMessageListActivity.this, mMsgListAdapter.getReceivePmmsEntryList(), imsi);
    // 对数据完整性有依赖，如果本地只有部分数据，会影响逻辑！
    // 查询匹配imsi且NetPayload非空的最后一条，如果查询失败，需要用补偿逻辑从数据库再查
    ```

    

15. `onMultiWindowModeChanged(boolean isInMultiWindowMode, Configuration configuration)` - **callback**

    ```java
    if (null != mMsgListAdapter) {
        mMsgListAdapter.setIsInMultiWindowMode(isInMultiWindowMode);
        mMsgListAdapter.notifyDataSetChanged();
        mMsgListAdapter.dismissFloatPanelView();
    }
    // 与数据无关，分屏模式的处理
    ```

    

16. `reCalFirstUnreadOffset()`

    ```java
    for (int i = 0; i < mMsgListAdapter.getCount(); i++) {
        PmmsEntry entry = mMsgListAdapter.getItem(i);
        if (entry != null && TextUtils.equals(entry.getMessageId(), mFirstUnreadMsgId)) {
            mFirstUnreadOffset = mMsgListAdapter.getCount() - i - 1;
            break;
        }
    }
    // 对数据完整性有依赖，如果只返回部分数据，会影响逻辑！
    // getUnreadOffset()是根据list数据遍历的，这块儿还需要参考一下ComposeMessageActivity的实现方法
    ```

    

### 3.2、修改思路

#### 3.2.1、数据获取

```java
public void getMessagesByServiceId(String serviceId, String where, boolean isBlocked, OnPmmsReceivedListener listener);
// 给此函数增加带有数量限制的参数的重载
-----------------------------------------------------------------
透传给GetPmmsByServiceId对象
[OK!仅此一次路径调用]

-----------------------------------------------------------------
透传给PushMessageSQLiteHelper#getPmmsEntryListByServiceId()
[OK!仅此一次路径调用]

-----------------------------------------------------------------
透传给PushMessageSQLiteHelper#getPmmsEntryList()
[OK!仅此一次路径调用]

-----------------------------------------------------------------
使用QueryParameter透传给PushMessageProvider#query()
[OK!没有添加QueryParameter的路径不受影响]

```











































