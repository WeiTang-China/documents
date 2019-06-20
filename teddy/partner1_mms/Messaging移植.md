













# 如何重载Action

线程执行体：

- Object executeAction() - action service thread
- Bundle doBackgroundWork() - background worker thread
- Object processBackgroundResponse(final Bundle response) - action service thread
- Object processBackgroundFailure() - action service thread



线程设计的策略可以简述为：

- 简单本地操作，可以在action service thread中排队进行
- action service thread还要承担调度及派发任务给background worker thread的工作

- 耗时操作，应该在background worker thread中排队进行

实际上，同时仍然有两个线程在操作db！



ActionMonitor可以配合Action子类来完成多种需求：

- Fire and forget - no monitor
- Immediate local processing only - will trigger ActionCompletedListener when done
- Background worker processing only - will trigger ActionCompletedListener when done
- Immediate local processing followed by background work followed by more local processing - will trigger ActionExecutedListener once local processing complete and ActionCompletedListener when second set of local process (dealing with background worker response) is complete


```java
/**
 * Interface used to notify action completion
 */
public interface ActionCompletedListener {
    /**
     * @param result object returned from processing the action. This is the value returned by
     * {@link Action#executeAction} if there is no background work, or
     * else the value returned by
     * {@link Action#processBackgroundResponse}
     */
    @RunsOnMainThread
    abstract void onActionSucceeded(ActionMonitor monitor, final Action action, final Object data, final Object result);
    /**
     * @param result value returned by {@link Action#processBackgroundFailure}
     */
    @RunsOnMainThread
    abstract void onActionFailed(ActionMonitor monitor, final Action action, final Object data, final Object result);
}
```

ActionMonitor的状态变化，所有操作的状态变化都是从STATE_CREATED开始，到STATE_COMPLETE结束，因此只列出中间状态如下：

- Immediate local processing only

  -> STATE_QUEUED

  -> STATE_EXECUTING

- Background worker processing only

  -> STATE_BACKGROUND_ACTIONS_QUEUED

  -> STATE_EXECUTING_BACKGROUND_ACTION

  -> STATE_BACKGROUND_COMPLETION_QUEUED

  -> STATE_PROCESSING_BACKGROUND_RESPONSE

- Immediate local processing followed by background work followed by more local processing

  -> STATE_QUEUED

  -> STATE_EXECUTING

  -> STATE_BACKGROUND_ACTIONS_QUEUED

  -> STATE_EXECUTING_BACKGROUND_ACTION

  -> STATE_BACKGROUND_COMPLETION_QUEUED

  -> STATE_PROCESSING_BACKGROUND_RESPONSE



# Conversation

## 如何找到一个Conversation？

之前的实现：GetOrCreateConversationAction

拿到participantsList之后，做sanitize处理（过滤掉重复的，过滤掉发给自己的）

然后拼接recipients参数送回mmssms执行getOrCreateTheadId操作

























# Memo临时备忘

- SyncMessagesAction会从mmssms.db中同步，本地获取条件过滤messages.sms_message_uri NOT NULL，可以考虑借助强行指定messages.sms_message_uri为空，把Push消息放到messages表中。【待评估】
- BugleGservicesImpl的实现都是空的，它是如何工作的？
- 