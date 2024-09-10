import 'package:flutter/material.dart';
import 'package:tw_logger/src/db/table/tw_label.dart';
import 'package:tw_logger/src/db/table/tw_network.dart';
import 'package:tw_logger/src/helper/tw_label_helper.dart';
import 'package:tw_logger/src/helper/tw_loger_helper.dart';
import 'package:tw_logger/src/helper/tw_network_helper.dart';
import 'package:tw_logger/src/tw_logger_configure.dart';
import 'package:tw_logger/src/ui/tw_search_base.dart';
import 'package:grouped_list/grouped_list.dart' as grouped_list;

class TWNetworkSearch extends TWSearchBase<TWNetwork> {
  const TWNetworkSearch({super.key});

  @override
  State<TWSearchBase<TWNetwork>> createState() => _TWCrashSearchState();
}

class _TWCrashSearchState extends TWSearchBaseState<TWNetwork> {
  @override
  Widget buildGroupedListView(List<TWNetwork> filteredResults) {
    return grouped_list.GroupedListView<TWNetwork, String>(
      elements: filteredResults,
      groupBy: (element) => fetchDate(element.requestTime),
      itemComparator: (item1, item2) =>
          item1.requestTime.compareTo(item2.requestTime),
      order: grouped_list.GroupedListOrder.DESC,
      groupHeaderBuilder: (element) => buildGroupHeader(element),
      itemBuilder: (context, element) => buildCard(element),
      useStickyGroupSeparators: true,
    );
  }

  Widget buildGroupHeader(TWNetwork element) {
    return Container(
      color: bgColor,
      alignment: Alignment.center,
      height: 30,
      child: Text(
        fetchDate(element.requestTime),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildCard(TWNetwork element) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => TWNetworkDetail(
            element: element,
            bgColor: bgColor,
          ),
        ),
      ),
      onLongPress: () => TWLoggerHelper.clipboard(
        context,
        element.requestUri,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    element.requestMethod ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    fetchTime(element.requestTime),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isEmpty(element.error)
                        ? (isEmpty(element.responseData)
                            ? Icons.hourglass_empty
                            : Icons.done)
                        : Icons.error,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 5,
                        top: 2,
                      ),
                      child: Text(
                        element.requestUri ?? '',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 5,
                      top: 2,
                    ),
                    child: Text(
                      fetchResponseSeconds(element),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  /// fetch response seconds
  String fetchResponseSeconds(TWNetwork item) {
    if (isEmpty(item.responseData) && isEmpty(item.error)) {
      return '';
    }
    final requestTime = item.requestTime;
    final responseTime = item.responseTime;

    /// seconds
    final seconds = responseTime.difference(requestTime).inMilliseconds / 1000;
    return '$seconds s';
  }

  @override
  bool matchesQuery(TWNetwork item, String query) {
    final time = fetchDate(item.requestTime).toLowerCase();
    final requestUri = item.requestUri.toString().toLowerCase();
    final error = item.error.toString().toLowerCase();
    return error.contains(query) ||
        time.contains(query) ||
        requestUri.contains(query);
  }

  @override
  Future deleteAllItems() async {
    await TWNetworkHelper.deleteAllItems();
  }

  @override
  Future<List<TWNetwork>> fetchAllItems() async {
    return TWNetworkHelper.findAllItems();
  }

  @override
  String get fetchTitle => 'Network Search';

  @override
  Future<List<TWLabel>> fetchLabels() async {
    return TWLabelHelper.findAllItemsByType('network');
  }

  @override
  Future<bool> handleLabelCache(String label) async {
    return TWLabelHelper.handleLabelCache(label, 'network');
  }

  @override
  Future<bool> removeLabelCache(String label) async {
    return TWLabelHelper.handleRemoveLabelCache(label, 'network');
  }
}

class TWNetworkDetail extends StatefulWidget {
  final TWNetwork element;
  final Color bgColor;
  const TWNetworkDetail({
    super.key,
    required this.element,
    required this.bgColor,
  });

  @override
  State<TWNetworkDetail> createState() => _TWNetworkDetailState();
}

class _TWNetworkDetailState extends State<TWNetworkDetail> {
  TWNetwork get element => widget.element;

  Color get bgColor => TWLoggerConfigure().themeColor;
  @override
  Widget build(BuildContext context) {
    return buildBody();
  }

  Widget buildBody() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network Detail'),
        backgroundColor: widget.bgColor,
      ),
      backgroundColor: widget.bgColor,
      body: buildCard(),
    );
  }

  Widget buildCard() {
    return SafeArea(
      child: DefaultTabController(
        length: isShowError ? 3 : 2,
        child: Card(
          child: Column(
            children: [
              TabBar(
                labelColor: bgColor,
                unselectedLabelColor: Colors.grey,
                indicatorColor: bgColor,
                tabs: [
                  const Tab(text: 'Request'),
                  const Tab(text: 'Response'),
                  if (isShowError) const Tab(text: 'Error'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(10.0),
                      child: buildRequest(),
                    ),
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(10.0),
                      child: buildResponse(),
                    ),
                    if (isShowError)
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(10.0),
                        child: buildError(),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLine() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Divider(
        color: Colors.black.withOpacity(0.1),
        height: .5,
      ),
    );
  }

  Widget buildRequest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRowItem(
          'Time:',
          element.requestTime.toString(),
        ),
        buildLine(),
        buildRowItem(
          'Method:',
          element.requestMethod,
        ),
        buildLine(),
        buildRowItem(
          'URL:',
          element.requestUri,
        ),
        buildLine(),
        buildColumnItem(
          'Headers:',
          element.requestHeaders,
        ),
        buildLine(),
        buildColumnItem(
          'Body:',
          element.requestData,
        ),
      ],
    );
  }

  Widget buildResponse() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildRowItem(
          'Time:',
          element.responseTime.toString(),
        ),
        buildLine(),
        buildRowItem(
          'Status Code:',
          element.responseStatusCode.toString(),
        ),
        buildLine(),
        buildRowItem(
          'Status Message:',
          element.responseStatusMessage,
        ),
        buildLine(),
        buildColumnItem(
          'Headers:',
          element.responseHeaders,
        ),
        buildLine(),
        buildColumnItem(
          'Body:',
          element.responseData,
        ),
      ],
    );
  }

  Widget buildError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildColumnItem(
          'Error:',
          element.error,
        ),
      ],
    );
  }

  Widget buildRowItem(
    String title,
    String? value,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () => TWLoggerHelper.clipboard(context, value),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            const TextSpan(text: ' '),
            if (value != null && value.isNotEmpty)
              TextSpan(
                text: value,
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildColumnItem(
    String title,
    String? value,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onLongPress: () => TWLoggerHelper.clipboard(context, value),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (value != null && value.isNotEmpty)
            Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
        ],
      ),
    );
  }

  bool get isShowError {
    final error = widget.element.error;
    return error != null && error.isNotEmpty;
  }
}
