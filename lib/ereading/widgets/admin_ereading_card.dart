import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminEreadingCard extends StatelessWidget {
  final dynamic data;
  final int index;
  final Function onAccept;
  final Function onReject;

  const AdminEreadingCard(
      {super.key,
      required this.data,
      required this.index,
      required this.onAccept,
      required this.onReject});

  Future<void> _launchURL(String url) async {
    launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication).onError(
      (error, stackTrace) {
        debugPrint("Url is not valid!");
        return false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
                  Text("Added by: ${data[index].fields.createdBy}"),
                  const SizedBox(height: 5),
                  Text(
                      "Last Updated: ${DateFormat('dd/MM/yyyy | HH:mm:ss').format(data[index].fields.lastUpdated)}"),
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
                              onPressed: () => onAccept(index, data),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Accept',
                                style: TextStyle(color: Colors.green),
                              ),
                            ),
                            const SizedBox(width: 8),
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
                              onPressed: () => onReject(index, data),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: const Text(
                                'Reject',
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
                                onPressed: () => onAccept(index, data),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child: const Text(
                                  'Accept',
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                              const SizedBox(height: 8),
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
                                onPressed: () => onReject(index, data),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child: const Text(
                                  'Reject',
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
        ),
      ),
    );
  }
}
