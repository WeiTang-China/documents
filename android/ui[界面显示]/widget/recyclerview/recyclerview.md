| 版本 | 修订人 |   日期    | 描述                      |
| :--: | :----: | :-------: | :------------------------ |
|      |  唐炜  | 2019-9-12 | 添加官方developer文档内容 |



[TOC]



# [官方developer文档](https://developer.android.com/reference/androidx/recyclerview/widget/RecyclerView?hl=en)

public class RecyclerView
extends ViewGroup implements ScrollingView, NestedScrollingChild2, NestedScrollingChild3

java.lang.Object
   ↳	android.view.View
 	   ↳	android.view.ViewGroup
 	 	   ↳	androidx.recyclerview.widget.RecyclerView
Known direct subclasses
BaseGridView, WearableRecyclerView
Known indirect subclasses
HorizontalGridView, VerticalGridView

A flexible view for providing a limited window into a large data set.

Glossary of terms:

- *Adapter:* A subclass of `RecyclerView.Adapter` responsible for providing views that represent items in a data set.
- *Position:* The position of a data item within an *Adapter*.
- *Index:* The index of an attached child view as used in a call to `ViewGroup.getChildAt(int)`. Contrast with *Position.*
- *Binding:* The process of preparing a child view to display data corresponding to a *position* within the adapter.
- *Recycle (view):* A view previously used to display data for a specific adapter position may be placed in a cache for later reuse to display the same type of data again later. This can drastically improve performance by skipping initial layout inflation or construction.
- *Scrap (view):* A child view that has entered into a temporarily detached state during layout. Scrap views may be reused without becoming fully detached from the parent RecyclerView, either unmodified if no rebinding is required or modified by the adapter if the view was considered *dirty*.
- *Dirty (view):* A child view that must be rebound by the adapter before being displayed.

Positions in RecyclerView:

RecyclerView introduces an additional level of abstraction between the `RecyclerView.Adapter` and `RecyclerView.LayoutManager` to be able to detect data set changes in batches during a layout calculation. This saves LayoutManager from tracking adapter changes to calculate animations. It also helps with performance because all view bindings happen at the same time and unnecessary bindings are avoided.

For this reason, there are two types of `position` related methods in RecyclerView:

- layout position: Position of an item in the latest layout calculation. This is the position from the LayoutManager's perspective.
- adapter position: Position of an item in the adapter. This is the position from the Adapter's perspective.

These two positions are the same except the time between dispatching `adapter.notify* `events and calculating the updated layout.

Methods that return or receive `*LayoutPosition*` use position as of the latest layout calculation (e.g. `RecyclerView.ViewHolder.getLayoutPosition()`, `findViewHolderForLayoutPosition(int)`). These positions include all changes until the last layout calculation. You can rely on these positions to be consistent with what user is currently seeing on the screen. For example, if you have a list of items on the screen and user asks for the 5th element, you should use these methods as they'll match what user is seeing.

The other set of position related methods are in the form of `*AdapterPosition*`. (e.g. `RecyclerView.ViewHolder.getAdapterPosition()`, `findViewHolderForAdapterPosition(int)`) You should use these methods when you need to work with up-to-date adapter positions even if they may not have been reflected to layout yet. For example, if you want to access the item in the adapter on a ViewHolder click, you should use `RecyclerView.ViewHolder.getAdapterPosition()`. Beware that these methods may not be able to calculate adapter positions if `RecyclerView.Adapter.notifyDataSetChanged()` has been called and new layout has not yet been calculated. For this reasons, you should carefully handle `NO_POSITION` or `null` results from these methods.

When writing a `RecyclerView.LayoutManager` you almost always want to use layout positions whereas when writing an `RecyclerView.Adapter`, you probably want to use adapter positions.



Presenting Dynamic Data

To display updatable data in a RecyclerView, your adapter needs to signal inserts, moves, and deletions to RecyclerView. You can build this yourself by manually calling `adapter.notify*`



List diffing with DiffUtil

If your RecyclerView is displaying a list that is re-fetched from scratch for each update (e.g. from the network, or from a database), `DiffUtil``DiffUtil`

The best part of this approach is that it extends to any arbitrary changes - item updates, moves, addition and removal can all be computed and handled the same way. Though you do have to keep two copies of the list in memory while diffing, and must avoid mutating them, it's possible to share unmodified elements between list versions.

There are three primary ways to do this for RecyclerView. We recommend you start with `ListAdapter`, the higher-level API that builds in `List` diffing on a background thread, with minimal code. `AsyncListDiffer` also provides this behavior, but without defining an Adapter to subclass. If you want more control, `DiffUtil` is the lower-level API you can use to compute the diffs yourself. Each approach allows you to specify how diffs should be computed based on item data.



List mutation with SortedList

If your RecyclerView receives updates incrementally, e.g. item X is inserted, or item Y is removed, you can use `SortedList``SortedList.replaceAll(Object[])`



Paging Library

The [Paging library](https://developer.android.com/topic/libraries/architecture/paging/)`PagedList``ListAdapter``AsyncListDiffer`[library documentation](https://developer.android.com/topic/libraries/architecture/paging/)`R.attr.layoutManager`



Summary

| Nested classes |                                                              |
| -------------- | ------------------------------------------------------------ |
| `class`        | `RecyclerView.Adapter<VH extends RecyclerView.ViewHolder>`Base class for an AdapterAdapters provide a binding from an app-specific data set to views that are displayed within a `RecyclerView`. |
| `class`        | `RecyclerView.AdapterDataObserver`Observer base class for watching changes to an `RecyclerView.Adapter`. |
| `interface`    | `RecyclerView.ChildDrawingOrderCallback`A callback interface that can be used to alter the drawing order of RecyclerView children. |
| `class`        | `RecyclerView.EdgeEffectFactory`EdgeEffectFactory lets you customize the over-scroll edge effect for RecyclerViews. |
| `class`        | `RecyclerView.ItemAnimator`This class defines the animations that take place on items as changes are made to the adapter. |
| `class`        | `RecyclerView.ItemDecoration`An ItemDecoration allows the application to add a special drawing and layout offset to specific item views from the adapter's data set. |
| `class`        | `RecyclerView.LayoutManager`A `LayoutManager` is responsible for measuring and positioning item views within a `RecyclerView` as well as determining the policy for when to recycle item views that are no longer visible to the user. |
| `class`        | `RecyclerView.LayoutParams``LayoutParams` subclass for children of `RecyclerView`. |
| `interface`    | `RecyclerView.OnChildAttachStateChangeListener`A Listener interface that can be attached to a RecylcerView to get notified whenever a ViewHolder is attached to or detached from RecyclerView. |
| `class`        | `RecyclerView.OnFlingListener`This class defines the behavior of fling if the developer wishes to handle it. |
| `interface`    | `RecyclerView.OnItemTouchListener`An OnItemTouchListener allows the application to intercept touch events in progress at the view hierarchy level of the RecyclerView before those touch events are considered for RecyclerView's own scrolling behavior. |
| `class`        | `RecyclerView.OnScrollListener`An OnScrollListener can be added to a RecyclerView to receive messages when a scrolling event has occurred on that RecyclerView. |
| `class`        | `RecyclerView.RecycledViewPool`RecycledViewPool lets you share Views between multiple RecyclerViews. |
| `class`        | `RecyclerView.Recycler`A Recycler is responsible for managing scrapped or detached item views for reuse. |
| `interface`    | `RecyclerView.RecyclerListener`A RecyclerListener can be set on a RecyclerView to receive messages whenever a view is recycled. |
| `class`        | `RecyclerView.SimpleOnItemTouchListener`An implementation of `RecyclerView.OnItemTouchListener` that has empty method bodies and default return values. |
| `class`        | `RecyclerView.SmoothScroller`Base class for smooth scrolling. |
| `class`        | `RecyclerView.State`Contains useful information about the current RecyclerView state like target scroll position or view focus. |
| `class`        | `RecyclerView.ViewCacheExtension`ViewCacheExtension is a helper class to provide an additional layer of view caching that can be controlled by the developer. |
| `class`        | `RecyclerView.ViewHolder`A ViewHolder describes an item view and metadata about its place within the RecyclerView. |

| Constants |                                                              |
| --------- | ------------------------------------------------------------ |
| `int`     | `HORIZONTAL`                                                 |
| `int`     | `INVALID_TYPE`                                               |
| `long`    | `NO_ID`                                                      |
| `int`     | `NO_POSITION`                                                |
| `int`     | `SCROLL_STATE_DRAGGING`The RecyclerView is currently being dragged by outside input such as user touch input. |
| `int`     | `SCROLL_STATE_IDLE`The RecyclerView is not currently scrolling. |
| `int`     | `SCROLL_STATE_SETTLING`The RecyclerView is currently animating to a final position while not under outside control. |
| `int`     | `TOUCH_SLOP_DEFAULT`Constant for use with `setScrollingTouchSlop(int)`. |
| `int`     | `TOUCH_SLOP_PAGING`Constant for use with `setScrollingTouchSlop(int)`. |
| `int`     | `UNDEFINED_DURATION`Constant that represents that a duration has not been defined. |
| `int`     | `VERTICAL`                                                   |

| Public methods                      |                                                              |
| ----------------------------------- | ------------------------------------------------------------ |
| `void`                              | `addFocusables(ArrayList<View> views, int direction, int focusableMode)` |
| `void`                              | `addItemDecoration(RecyclerView.ItemDecoration decor, int index)`Add an `RecyclerView.ItemDecoration` to this RecyclerView. |
| `void`                              | `addItemDecoration(RecyclerView.ItemDecoration decor)`Add an `RecyclerView.ItemDecoration` to this RecyclerView. |
| `void`                              | `addOnChildAttachStateChangeListener(RecyclerView.OnChildAttachStateChangeListener listener)`Register a listener that will be notified whenever a child view is attached to or detached from RecyclerView. |
| `void`                              | `addOnItemTouchListener(RecyclerView.OnItemTouchListener listener)`Add an `RecyclerView.OnItemTouchListener` to intercept touch events before they are dispatched to child views or this view's standard scrolling behavior. |
| `void`                              | `addOnScrollListener(RecyclerView.OnScrollListener listener)`Add a listener that will be notified of any changes in scroll state or position. |
| `void`                              | `clearOnChildAttachStateChangeListeners()`Removes all listeners that were added via `addOnChildAttachStateChangeListener(OnChildAttachStateChangeListener)`. |
| `void`                              | `clearOnScrollListeners()`Remove all secondary listener that were notified of any changes in scroll state or position. |
| `int`                               | `computeHorizontalScrollExtent()`Compute the horizontal extent of the horizontal scrollbar's thumb within the horizontal range. |
| `int`                               | `computeHorizontalScrollOffset()`Compute the horizontal offset of the horizontal scrollbar's thumb within the horizontal range. |
| `int`                               | `computeHorizontalScrollRange()`Compute the horizontal range that the horizontal scrollbar represents. |
| `int`                               | `computeVerticalScrollExtent()`Compute the vertical extent of the vertical scrollbar's thumb within the vertical range. |
| `int`                               | `computeVerticalScrollOffset()`Compute the vertical offset of the vertical scrollbar's thumb within the vertical range. |
| `int`                               | `computeVerticalScrollRange()`Compute the vertical range that the vertical scrollbar represents. |
| `boolean`                           | `dispatchNestedFling(float velocityX, float velocityY, boolean consumed)` |
| `boolean`                           | `dispatchNestedPreFling(float velocityX, float velocityY)`   |
| `boolean`                           | `dispatchNestedPreScroll(int dx, int dy, int[] consumed, int[] offsetInWindow)` |
| `boolean`                           | `dispatchNestedPreScroll(int dx, int dy, int[] consumed, int[] offsetInWindow, int type)`Dispatch one step of a nested scroll in progress before this view consumes any portion of it. |
| `boolean`                           | `dispatchNestedScroll(int dxConsumed, int dyConsumed, int dxUnconsumed, int dyUnconsumed, int[] offsetInWindow, int type)`Dispatch one step of a nested scroll in progress. |
| `boolean`                           | `dispatchNestedScroll(int dxConsumed, int dyConsumed, int dxUnconsumed, int dyUnconsumed, int[] offsetInWindow)` |
| `final void`                        | `dispatchNestedScroll(int dxConsumed, int dyConsumed, int dxUnconsumed, int dyUnconsumed, int[] offsetInWindow, int type, int[] consumed)`Dispatch one step of a nested scroll in progress. |
| `boolean`                           | `dispatchPopulateAccessibilityEvent(AccessibilityEvent event)` |
| `void`                              | `draw(Canvas c)`                                             |
| `boolean`                           | `drawChild(Canvas canvas, View child, long drawingTime)`     |
| `View`                              | `findChildViewUnder(float x, float y)`Find the topmost view under the given point. |
| `View`                              | `findContainingItemView(View view)`Traverses the ancestors of the given view and returns the item view that contains it and also a direct child of the RecyclerView. |
| `RecyclerView.ViewHolder`           | `findContainingViewHolder(View view)`Returns the ViewHolder that contains the given view. |
| `RecyclerView.ViewHolder`           | `findViewHolderForAdapterPosition(int position)`Return the ViewHolder for the item in the given position of the data set. |
| `RecyclerView.ViewHolder`           | `findViewHolderForItemId(long id)`Return the ViewHolder for the item with the given id. |
| `RecyclerView.ViewHolder`           | `findViewHolderForLayoutPosition(int position)`Return the ViewHolder for the item in the given position of the data set as of the latest layout pass. |
| `RecyclerView.ViewHolder`           | `findViewHolderForPosition(int position)`*This method is deprecated. use findViewHolderForLayoutPosition(int) or findViewHolderForAdapterPosition(int)* |
| `boolean`                           | `fling(int velocityX, int velocityY)`Begin a standard fling with an initial velocity along each axis in pixels per second. |
| `View`                              | `focusSearch(View focused, int direction)`Since RecyclerView is a collection ViewGroup that includes virtual children (items that are in the Adapter but not visible in the UI), it employs a more involved focus search strategy that differs from other ViewGroups. |
| `ViewGroup.LayoutParams`            | `generateLayoutParams(AttributeSet attrs)`                   |
| `CharSequence`                      | `getAccessibilityClassName()`                                |
| `Adapter`                           | `getAdapter()`Retrieves the previously set adapter or null if no adapter is set. |
| `int`                               | `getBaseline()`Return the offset of the RecyclerView's text baseline from the its top boundary. |
| `int`                               | `getChildAdapterPosition(View child)`Return the adapter position that the given child view corresponds to. |
| `long`                              | `getChildItemId(View child)`Return the stable item id that the given child view corresponds to. |
| `int`                               | `getChildLayoutPosition(View child)`Return the adapter position of the given child view as of the latest completed layout pass. |
| `int`                               | `getChildPosition(View child)`*This method is deprecated. use getChildAdapterPosition(View) or getChildLayoutPosition(View).* |
| `RecyclerView.ViewHolder`           | `getChildViewHolder(View child)`Retrieve the `RecyclerView.ViewHolder` for the given child view. |
| `boolean`                           | `getClipToPadding()`Returns whether this RecyclerView will clip its children to its padding, and resize (but not clip) any EdgeEffect to the padded region, if padding is present. |
| `RecyclerViewAccessibilityDelegate` | `getCompatAccessibilityDelegate()`Returns the accessibility delegate compatibility implementation used by the RecyclerView. |
| `void`                              | `getDecoratedBoundsWithMargins(View view, Rect outBounds)`Returns the bounds of the view including its decoration and margins. |
| `RecyclerView.EdgeEffectFactory`    | `getEdgeEffectFactory()`Retrieves the previously set `RecyclerView.EdgeEffectFactory` or the default factory if nothing was set. |
| `RecyclerView.ItemAnimator`         | `getItemAnimator()`Gets the current ItemAnimator for this RecyclerView. |
| `RecyclerView.ItemDecoration`       | `getItemDecorationAt(int index)`Returns an `RecyclerView.ItemDecoration` previously added to this RecyclerView. |
| `int`                               | `getItemDecorationCount()`Returns the number of `RecyclerView.ItemDecoration` currently added to this RecyclerView. |
| `RecyclerView.LayoutManager`        | `getLayoutManager()`Return the `RecyclerView.LayoutManager` currently responsible for layout policy for this RecyclerView. |
| `int`                               | `getMaxFlingVelocity()`Returns the maximum fling velocity used by this RecyclerView. |
| `int`                               | `getMinFlingVelocity()`Returns the minimum velocity to start a fling. |
| `RecyclerView.OnFlingListener`      | `getOnFlingListener()`Get the current `RecyclerView.OnFlingListener` from this `RecyclerView`. |
| `boolean`                           | `getPreserveFocusAfterLayout()`Returns true if the RecyclerView should attempt to preserve currently focused Adapter Item's focus even if the View representing the Item is replaced during a layout calculation. |
| `RecyclerView.RecycledViewPool`     | `getRecycledViewPool()`Retrieve this RecyclerView's `RecyclerView.RecycledViewPool`. |
| `int`                               | `getScrollState()`Return the current scrolling state of the RecyclerView. |
| `boolean`                           | `hasFixedSize()`                                             |
| `boolean`                           | `hasNestedScrollingParent()`                                 |
| `boolean`                           | `hasNestedScrollingParent(int type)`Returns true if this view has a nested scrolling parent for the given input type. |
| `boolean`                           | `hasPendingAdapterUpdates()`Returns whether there are pending adapter updates which are not yet applied to the layout. |
| `void`                              | `invalidateItemDecorations()`Invalidates all ItemDecorations. |
| `boolean`                           | `isAnimating()`Returns true if RecyclerView is currently running some animations. |
| `boolean`                           | `isAttachedToWindow()`Returns true if RecyclerView is attached to window. |
| `boolean`                           | `isComputingLayout()`Returns whether RecyclerView is currently computing a layout. |
| `boolean`                           | `isLayoutFrozen()`*This method is deprecated. Use isLayoutSuppressed().* |
| `final boolean`                     | `isLayoutSuppressed()`Returns whether layout and scroll calls on this container are currently being suppressed, due to an earlier call to `suppressLayout(boolean)`. |
| `boolean`                           | `isNestedScrollingEnabled()`                                 |
| `void`                              | `offsetChildrenHorizontal(int dx)`Offset the bounds of all child views by `dx` pixels. |
| `void`                              | `offsetChildrenVertical(int dy)`Offset the bounds of all child views by `dy` pixels. |
| `void`                              | `onChildAttachedToWindow(View child)`Called when an item view is attached to this RecyclerView. |
| `void`                              | `onChildDetachedFromWindow(View child)`Called when an item view is detached from this RecyclerView. |
| `void`                              | `onDraw(Canvas c)`                                           |
| `boolean`                           | `onGenericMotionEvent(MotionEvent event)`                    |
| `boolean`                           | `onInterceptTouchEvent(MotionEvent e)`                       |
| `void`                              | `onScrollStateChanged(int state)`Called when the scroll state of this RecyclerView changes. |
| `void`                              | `onScrolled(int dx, int dy)`Called when the scroll position of this RecyclerView changes. |
| `boolean`                           | `onTouchEvent(MotionEvent e)`                                |
| `void`                              | `removeItemDecoration(RecyclerView.ItemDecoration decor)`Remove an `RecyclerView.ItemDecoration` from this RecyclerView. |
| `void`                              | `removeItemDecorationAt(int index)`Removes the `RecyclerView.ItemDecoration` associated with the supplied index position. |
| `void`                              | `removeOnChildAttachStateChangeListener(RecyclerView.OnChildAttachStateChangeListener listener)`Removes the provided listener from child attached state listeners list. |
| `void`                              | `removeOnItemTouchListener(RecyclerView.OnItemTouchListener listener)`Remove an `RecyclerView.OnItemTouchListener`. |
| `void`                              | `removeOnScrollListener(RecyclerView.OnScrollListener listener)`Remove a listener that was notified of any changes in scroll state or position. |
| `void`                              | `requestChildFocus(View child, View focused)`                |
| `boolean`                           | `requestChildRectangleOnScreen(View child, Rect rect, boolean immediate)` |
| `void`                              | `requestDisallowInterceptTouchEvent(boolean disallowIntercept)` |
| `void`                              | `requestLayout()`                                            |
| `void`                              | `scrollBy(int x, int y)`                                     |
| `void`                              | `scrollTo(int x, int y)`                                     |
| `void`                              | `scrollToPosition(int position)`Convenience method to scroll to a certain position. |
| `void`                              | `sendAccessibilityEventUnchecked(AccessibilityEvent event)`  |
| `void`                              | `setAccessibilityDelegateCompat(RecyclerViewAccessibilityDelegate accessibilityDelegate)`Sets the accessibility delegate compatibility implementation used by RecyclerView. |
| `void`                              | `setAdapter(Adapter adapter)`Set a new adapter to provide child views on demand. |
| `void`                              | `setChildDrawingOrderCallback(RecyclerView.ChildDrawingOrderCallback childDrawingOrderCallback)`Sets the `RecyclerView.ChildDrawingOrderCallback` to be used for drawing children. |
| `void`                              | `setClipToPadding(boolean clipToPadding)`                    |
| `void`                              | `setEdgeEffectFactory(RecyclerView.EdgeEffectFactory edgeEffectFactory)`Set a `RecyclerView.EdgeEffectFactory` for this `RecyclerView`. |
| `void`                              | `setHasFixedSize(boolean hasFixedSize)`RecyclerView can perform several optimizations if it can know in advance that RecyclerView's size is not affected by the adapter contents. |
| `void`                              | `setItemAnimator(RecyclerView.ItemAnimator animator)`Sets the `RecyclerView.ItemAnimator` that will handle animations involving changes to the items in this RecyclerView. |
| `void`                              | `setItemViewCacheSize(int size)`Set the number of offscreen views to retain before adding them to the potentially shared `recycled view pool`. |
| `void`                              | `setLayoutFrozen(boolean frozen)`*This method is deprecated. Use suppressLayout(boolean).* |
| `void`                              | `setLayoutManager(RecyclerView.LayoutManager layout)`Set the `RecyclerView.LayoutManager` that this RecyclerView will use. |
| `void`                              | `setLayoutTransition(LayoutTransition transition)`*This method is deprecated. Use setItemAnimator(ItemAnimator) ()}.* |
| `void`                              | `setNestedScrollingEnabled(boolean enabled)`                 |
| `void`                              | `setOnFlingListener(RecyclerView.OnFlingListener onFlingListener)`Set a `RecyclerView.OnFlingListener` for this `RecyclerView`. |
| `void`                              | `setOnScrollListener(RecyclerView.OnScrollListener listener)`*This method is deprecated. Use addOnScrollListener(OnScrollListener) and removeOnScrollListener(OnScrollListener)* |
| `void`                              | `setPreserveFocusAfterLayout(boolean preserveFocusAfterLayout)`Set whether the RecyclerView should try to keep the same Item focused after a layout calculation or not. |
| `void`                              | `setRecycledViewPool(RecyclerView.RecycledViewPool pool)`Recycled view pools allow multiple RecyclerViews to share a common pool of scrap views. |
| `void`                              | `setRecyclerListener(RecyclerView.RecyclerListener listener)`Register a listener that will be notified whenever a child view is recycled. |
| `void`                              | `setScrollingTouchSlop(int slopConstant)`Configure the scrolling touch slop for a specific use case. |
| `void`                              | `setViewCacheExtension(RecyclerView.ViewCacheExtension extension)`Sets a new `RecyclerView.ViewCacheExtension` to be used by the Recycler. |
| `void`                              | `smoothScrollBy(int dx, int dy, Interpolator interpolator, int duration)`Smooth scrolls the RecyclerView by a given distance. |
| `void`                              | `smoothScrollBy(int dx, int dy)`Animate a scroll by the given amount of pixels along either axis. |
| `void`                              | `smoothScrollBy(int dx, int dy, Interpolator interpolator)`Animate a scroll by the given amount of pixels along either axis. |
| `void`                              | `smoothScrollToPosition(int position)`Starts a smooth scroll to an adapter position. |
| `boolean`                           | `startNestedScroll(int axes)`                                |
| `boolean`                           | `startNestedScroll(int axes, int type)`Begin a nestable scroll operation along the given axes, for the given input type. |
| `void`                              | `stopNestedScroll()`                                         |
| `void`                              | `stopNestedScroll(int type)`Stop a nested scroll in progress for the given input type. |
| `void`                              | `stopScroll()`Stop any current scroll in progress, such as one started by `smoothScrollBy(int, int)`, `fling(int, int)` or a touch-initiated fling. |
| `final void`                        | `suppressLayout(boolean suppress)`Tells this RecyclerView to suppress all layout and scroll calls until layout suppression is disabled with a later call to suppressLayout(false). |
| `void`                              | `swapAdapter(Adapter adapter, boolean removeAndRecycleExistingViews)`Swaps the current adapter with the provided one. |





