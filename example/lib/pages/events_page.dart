import 'package:eventbus/eventbus.dart';
import 'package:eventbus/helpers.dart' as helpers;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../log.dart';

enum FiltersEnum {
  all,
  states,
  actions,
  logs;

  const FiltersEnum();
  String get label => '${name[0].toUpperCase()}${name.substring(1)}';
}

// ignore: must_be_immutable
class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  Stream<List>? _stream;

  Stream<List> get historyStream {
    _stream ??= EventBus.instance.onHistoryUpdate();
    return _stream!;
  }

  var selectedFilter = FiltersEnum.all;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List>(
      stream: historyStream,
      initialData: const [],
      builder: (context, snapshot) {
        final eventsList = snapshot.data!.reversed.toList();
        final filteredEvents = filterEvents(eventsList);
        return Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: const Text('Events'),
            actions: [Text('Count: \n${eventsList.length}')],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: Container(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  runSpacing: 5,
                  spacing: 5,
                  children: [
                    ...List.generate(FiltersEnum.values.length, (index) {
                      final filter = FiltersEnum.values[index];
                      final isSelected = selectedFilter == filter;
                      return RawChip(
                        label: Text(filter.label),
                        selected: isSelected,
                        onSelected: (isSelected) {
                          if (isSelected) {
                            setState(() => selectedFilter = filter);
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          body: ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: filteredEvents.length,
            itemBuilder: (context, index) {
              final event = filteredEvents[index];
              final data = event.data.toString();
              final textColor = (event is Log) ? Colors.orange : null;

              return ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(event.data.runtimeType.toString()),
                        content: Text(event.data.toString()),
                      );
                    },
                  );
                },
                textColor: textColor,
                title: Text(event.data.runtimeType.toString()),
                subtitle: Text.rich(TextSpan(children: [
                  TextSpan(
                    text: 'Date: ${formatDate(event.createdAt)}\n',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: 'Time: ${formatTime(event.createdAt)}\n',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  if (data.isNotEmpty) TextSpan(text: data),
                ])),
              );
            },
          ),
        );
      },
    );
  }

  List<Event> filterEvents(List events) {
    return switch (selectedFilter) {
      FiltersEnum.all => events,
      FiltersEnum.actions => events.whereType<Event<helpers.Action>>().toList(),
      FiltersEnum.states => events.whereType<Event<helpers.State>>().toList(),
      FiltersEnum.logs => events.whereType<Event<Log>>().toList(),
    }
        .cast();
  }

  String formatDate(DateTime date) {
    final formatter = DateFormat('dd.MM.yyyy');
    return formatter.format(date);
  }

  String formatTime(DateTime date) {
    final formatter = DateFormat('HH:mm:ss');
    return formatter.format(date);
  }
}
