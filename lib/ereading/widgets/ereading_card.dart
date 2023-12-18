import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:literakarya_mobile/ereading/models/ereading.dart';
import 'package:url_launcher/url_launcher.dart';

class EreadingCard extends StatelessWidget {
  final dynamic data;
  final int index;
  final Function(int, List<Ereading>) onDelete;

  const EreadingCard(
      {super.key,
      required this.data,
      required this.index,
      required this.onDelete});

  Future<void> _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8.0),
      color: data[index].fields.state == 1
          ? Colors.teal[50]
          : data[index].fields.state == 2
              ? Colors.orange[50]
              : Colors.grey[200],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (data[index].fields.state == 0) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "${data[index].fields.title}",
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.black),
                    const Text(
                      "Status: Bacaanmu sedang diperiksa oleh admin.",
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Last Updated: ${DateFormat('dd/MM/yyyy | HH:mm:ss').format(data[index].fields.lastUpdated)}",
                    ),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => onDelete(index, data),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (data[index].fields.state == 2) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "${data[index].fields.title}",
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.black),
                    const Text("Status: Bacaanmu ditolak oleh admin."),
                    const SizedBox(height: 5),
                    Text(
                      "Last Updated: ${DateFormat('dd/MM/yyyy | HH:mm:ss').format(data[index].fields.lastUpdated)}",
                    ),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => onDelete(index, data),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (data[index].fields.state == 1) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "${data[index].fields.title}",
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.black),
                    Text('Author: ${data[index].fields.author}'),
                    const SizedBox(height: 5),
                    Text('Description: ${data[index].fields.description}'),
                    const SizedBox(height: 5),
                    Text(
                      "Last Updated: ${DateFormat('dd/MM/yyyy | HH:mm:ss').format(data[index].fields.lastUpdated)}",
                    ),
                    const Divider(color: Colors.black),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder:
                          (BuildContext context, BoxConstraints constraints) {
                        if (constraints.maxWidth > 400) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  _launchURL(data[index].fields.link);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child: const Text('Visit Link',
                                    style: TextStyle(color: Colors.blue)),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => onDelete(index, data),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    _launchURL(data[index].fields.link);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Text('Visit Link',
                                      style: TextStyle(color: Colors.blue)),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () => onDelete(index, data),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
