import 'dart:async';

import 'package:flutter/material.dart';

typedef FutureCallBack = Future<bool> Function();

enum EasyLoadMoreStatusState {
  idle,
  loading,
  failed,
  finished,
}

class _BuildNotification extends Notification {}

class _RetryNotification extends Notification {}

class EasyLoadMoreStatusText {
  static const String idle = 'Scroll to load more';
  static const String loading = 'Loading...';
  static const String failed = 'Failed to load items';
  static const String finished = 'No more items';

  static String getText(EasyLoadMoreStatusState state) {
    switch (state) {
      case EasyLoadMoreStatusState.idle:
        return idle;
      case EasyLoadMoreStatusState.loading:
        return loading;
      case EasyLoadMoreStatusState.failed:
        return failed;
      case EasyLoadMoreStatusState.finished:
        return finished;
      default:
        return idle;
    }
  }
}

class EasyLoadMoreLoadingWidgetDefaultOpts {
  static const double containerHeight = 60.0;
  static const double size = 24.0;
  static const double strokeWidth = 3.0;
  static const Color color = Colors.blue;
  static const int delay = 16;
}

class EasyLoadMore extends StatefulWidget {
  /// The height of the loading widget's container/wrapper.
  final double loadingWidgetContainerHeight;

  /// The loading widget size.
  final double loadingWidgetSize;

  /// The loading widget stroke width.
  final double loadingWidgetStrokeWidth;

  /// The loading widget color.
  final Color loadingWidgetColor;

  /// The loading widget animation delay.
  final int loadingWidgetAnimationDelay;

  /// Status text to show when the load more is not triggered.
  final String idleStatusText;

  /// Status text to show when the process is loading.
  final String loadingStatusText;

  /// Status text to show when the processing is failed.
  final String failedStatusText;

  /// Status text to show when there's no more items to load.
  final String finishedStatusText;

  /// Manually turn-off the next load more.
  ///
  /// Set this to `true` to set the load more as `finished` (no more items). Default is `false`.
  ///
  /// The use-case is when there's no more items to load, you might want `EasyLoadMore` to not running again.
  final bool isFinished;

  /// Whether or not to run the load more even though the result is empty/finished.
  final bool runOnEmptyResult;

  /// Callback function to run during the load more process.
  ///
  /// To mark the status as success or delay, set the return to `true`.
  ///
  /// To mark the status as failed, set the return to `false`.
  final FutureCallBack onLoadMore;

  /// The child widget.
  ///
  /// Supported widgets: `ListView`, `ListView.builder`, & `ListView.separated`.
  final Widget child;

  const EasyLoadMore({
    Key? key,
    this.loadingWidgetContainerHeight =
        EasyLoadMoreLoadingWidgetDefaultOpts.containerHeight,
    this.loadingWidgetSize = EasyLoadMoreLoadingWidgetDefaultOpts.size,
    this.loadingWidgetStrokeWidth =
        EasyLoadMoreLoadingWidgetDefaultOpts.strokeWidth,
    this.loadingWidgetColor = EasyLoadMoreLoadingWidgetDefaultOpts.color,
    this.loadingWidgetAnimationDelay =
        EasyLoadMoreLoadingWidgetDefaultOpts.delay,
    this.idleStatusText = EasyLoadMoreStatusText.idle,
    this.loadingStatusText = EasyLoadMoreStatusText.loading,
    this.failedStatusText = EasyLoadMoreStatusText.failed,
    this.finishedStatusText = EasyLoadMoreStatusText.finished,
    this.isFinished = false,
    this.runOnEmptyResult = false,
    required this.onLoadMore,
    required this.child,
  }) : super(key: key);

  @override
  State<EasyLoadMore> createState() => _EasyLoadMoreState();
}

class _EasyLoadMoreState extends State<EasyLoadMore> {
  Widget get child => widget.child;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (child is ListView) {
      return _buildListView(child as ListView) ?? Container();
    }

    if (child is SliverList) {
      return _buildSliverList(child as SliverList);
    }

    return child;
  }

  Widget? _buildListView(ListView listView) {
    var delegate = listView.childrenDelegate;

    outer:
    if (delegate is SliverChildBuilderDelegate) {
      SliverChildBuilderDelegate delegate =
          listView.childrenDelegate as SliverChildBuilderDelegate;

      if (!widget.runOnEmptyResult && delegate.estimatedChildCount == 0) {
        break outer;
      }

      int viewCount = (delegate.estimatedChildCount ?? 0) + 1;

      builder(context, index) {
        if (index == viewCount - 1) {
          return _buildLoadMoreView();
        }

        return delegate.builder(context, index) ?? Container();
      }

      return ListView.builder(
        itemBuilder: builder,
        addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
        addRepaintBoundaries: delegate.addRepaintBoundaries,
        addSemanticIndexes: delegate.addSemanticIndexes,
        dragStartBehavior: listView.dragStartBehavior,
        semanticChildCount: listView.semanticChildCount,
        itemCount: viewCount,
        cacheExtent: listView.cacheExtent,
        controller: listView.controller,
        itemExtent: listView.itemExtent,
        key: listView.key,
        padding: listView.padding,
        physics: listView.physics,
        primary: listView.primary,
        reverse: listView.reverse,
        scrollDirection: listView.scrollDirection,
        shrinkWrap: listView.shrinkWrap,
      );
    } else if (delegate is SliverChildListDelegate) {
      SliverChildListDelegate delegate =
          listView.childrenDelegate as SliverChildListDelegate;

      if (!widget.runOnEmptyResult && delegate.estimatedChildCount == 0) {
        break outer;
      }

      delegate.children.add(_buildLoadMoreView());

      return ListView(
        addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
        addRepaintBoundaries: delegate.addRepaintBoundaries,
        cacheExtent: listView.cacheExtent,
        controller: listView.controller,
        itemExtent: listView.itemExtent,
        key: listView.key,
        padding: listView.padding,
        physics: listView.physics,
        primary: listView.primary,
        reverse: listView.reverse,
        scrollDirection: listView.scrollDirection,
        shrinkWrap: listView.shrinkWrap,
        addSemanticIndexes: delegate.addSemanticIndexes,
        dragStartBehavior: listView.dragStartBehavior,
        semanticChildCount: listView.semanticChildCount,
        children: delegate.children,
      );
    }

    return listView;
  }

  Widget _buildSliverList(SliverList list) {
    final delegate = list.delegate;

    if (delegate is SliverChildListDelegate) {
      return SliverList(
        delegate: delegate,
      );
    }

    outer:
    if (delegate is SliverChildBuilderDelegate) {
      if (!widget.runOnEmptyResult && delegate.estimatedChildCount == 0) {
        break outer;
      }

      final viewCount = (delegate.estimatedChildCount ?? 0) + 1;

      builder(context, index) {
        if (index == viewCount - 1) {
          return _buildLoadMoreView();
        }

        return delegate.builder(context, index) ?? Container();
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate(
          builder,
          addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
          addRepaintBoundaries: delegate.addRepaintBoundaries,
          addSemanticIndexes: delegate.addSemanticIndexes,
          childCount: viewCount,
          semanticIndexCallback: delegate.semanticIndexCallback,
          semanticIndexOffset: delegate.semanticIndexOffset,
        ),
      );
    }

    outer:
    if (delegate is SliverChildListDelegate) {
      if (!widget.runOnEmptyResult && delegate.estimatedChildCount == 0) {
        break outer;
      }

      delegate.children.add(_buildLoadMoreView());

      return SliverList(
        delegate: SliverChildListDelegate(
          delegate.children,
          addAutomaticKeepAlives: delegate.addAutomaticKeepAlives,
          addRepaintBoundaries: delegate.addRepaintBoundaries,
          addSemanticIndexes: delegate.addSemanticIndexes,
          semanticIndexCallback: delegate.semanticIndexCallback,
          semanticIndexOffset: delegate.semanticIndexOffset,
        ),
      );
    }

    return list;
  }

  EasyLoadMoreStatusState status = EasyLoadMoreStatusState.idle;

  Widget _buildLoadMoreView() {
    if (widget.isFinished == true) {
      status = EasyLoadMoreStatusState.finished;
    } else {
      if (status == EasyLoadMoreStatusState.finished) {
        status = EasyLoadMoreStatusState.idle;
      }
    }
    return NotificationListener<_RetryNotification>(
      onNotification: _onRetry,
      child: NotificationListener<_BuildNotification>(
        onNotification: _onLoadMoreBuild,
        child: EasyLoadMoreView(
          status: status,
          containerHeight: widget.loadingWidgetContainerHeight,
          size: widget.loadingWidgetSize,
          strokeWidth: widget.loadingWidgetStrokeWidth,
          color: widget.loadingWidgetColor,
          animationDelay: widget.loadingWidgetAnimationDelay,
          idleStatusText: widget.idleStatusText,
          loadingStatusText: widget.loadingStatusText,
          failedStatusText: widget.failedStatusText,
          finishedStatusText: widget.finishedStatusText,
        ),
      ),
    );
  }

  bool _onLoadMoreBuild(_BuildNotification notification) {
    if (status == EasyLoadMoreStatusState.idle) {
      loadMore();
    }

    if (status == EasyLoadMoreStatusState.loading) {
      return false;
    }

    if (status == EasyLoadMoreStatusState.failed) {
      return false;
    }

    if (status == EasyLoadMoreStatusState.finished) {
      return false;
    }

    return false;
  }

  void _updateStatus(EasyLoadMoreStatusState status) {
    if (mounted) setState(() => this.status = status);
  }

  bool _onRetry(_RetryNotification notification) {
    loadMore();
    return false;
  }

  void loadMore() {
    _updateStatus(EasyLoadMoreStatusState.loading);

    widget.onLoadMore().then((v) {
      if (v == true) {
        // 成功，切换状态为空闲
        _updateStatus(EasyLoadMoreStatusState.idle);
      } else {
        // 失败，切换状态为失败
        _updateStatus(EasyLoadMoreStatusState.failed);
      }
    });
  }
}

class EasyLoadMoreView extends StatefulWidget {
  final EasyLoadMoreStatusState status;

  final double containerHeight;
  final double size;
  final double strokeWidth;
  final Color color;
  final int animationDelay;

  final String idleStatusText;
  final String loadingStatusText;
  final String failedStatusText;
  final String finishedStatusText;

  const EasyLoadMoreView({
    Key? key,
    required this.status,
    required this.containerHeight,
    required this.size,
    required this.strokeWidth,
    required this.color,
    required this.animationDelay,
    required this.idleStatusText,
    required this.loadingStatusText,
    required this.failedStatusText,
    required this.finishedStatusText,
  }) : super(key: key);

  @override
  State<EasyLoadMoreView> createState() => _EasyLoadMoreViewState();
}

class _EasyLoadMoreViewState extends State<EasyLoadMoreView> {
  final buildNotification = _BuildNotification();
  final retryNotification = _RetryNotification();

  @override
  Widget build(BuildContext context) {
    notify();

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (widget.status == EasyLoadMoreStatusState.failed ||
            widget.status == EasyLoadMoreStatusState.idle) {
          _notifyRetryProcess();
        }
      },
      child: Container(
        height: widget.containerHeight,
        alignment: Alignment.center,
        child: buildTextWidget(),
      ),
    );
  }

  Widget buildTextWidget() {
    String text = '';

    switch (widget.status) {
      case EasyLoadMoreStatusState.idle:
        text = widget.idleStatusText;
        break;
      case EasyLoadMoreStatusState.loading:
        text = widget.loadingStatusText;
        break;
      case EasyLoadMoreStatusState.failed:
        text = widget.failedStatusText;
        break;
      case EasyLoadMoreStatusState.finished:
        text = widget.finishedStatusText;
        break;
    }

    if (widget.status == EasyLoadMoreStatusState.failed) {
      return Container(
        padding: const EdgeInsets.all(0.0),
        child: Text(text),
      );
    }

    if (widget.status == EasyLoadMoreStatusState.idle) {
      return Text(text);
    }

    if (widget.status == EasyLoadMoreStatusState.loading) {
      return Container(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: widget.size,
              height: widget.size,
              child: CircularProgressIndicator(
                strokeWidth: widget.strokeWidth,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.color,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(text),
            ),
          ],
        ),
      );
    }

    if (widget.status == EasyLoadMoreStatusState.finished) {
      return Text(text);
    }

    return Text(text);
  }

  void notify() async {
    Duration delay = max(
      Duration(
        microseconds: widget.animationDelay,
      ),
      const Duration(
        milliseconds: EasyLoadMoreLoadingWidgetDefaultOpts.delay,
      ),
    );

    await Future.delayed(delay);

    if (widget.status == EasyLoadMoreStatusState.idle) {
      _notifyBuildProcess();
    }
  }

  Duration max(
    Duration duration,
    Duration duration2,
  ) {
    if (duration > duration2) {
      return duration;
    }
    return duration2;
  }

  void _notifyBuildProcess() {
    if (!mounted) return;
    buildNotification.dispatch(context);
  }

  void _notifyRetryProcess() {
    if (!mounted) return;
    retryNotification.dispatch(context);
  }
}
