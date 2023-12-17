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
      // use canLaunchUrl instead of canLaunch
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
          ? Colors.lightGreen[100]
          : data[index].fields.state == 2
              ? Colors.orange[100]
              : Colors.white,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (data[index].fields.state == 0) ...[
              const SizedBox(height: 3),
              Text(
                "${data[index].fields.title}",
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Status: Bacaanmu akan diperiksa oleh admin.",
                style: TextStyle(fontSize: 14.0),
              ),
              const Divider(color: Colors.black),
              Text(
                "Last updated: ${DateFormat('dd/MM/yyyy | HH:mm:ss').format(data[index].fields.lastUpdated)}",
                style: const TextStyle(fontSize: 14.0),
              ),
              const Divider(color: Colors.black),
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
            if (data[index].fields.state == 2) ...[
              const SizedBox(height: 3),
              Text(
                "${data[index].fields.title}",
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              const Text(
                "Status: Bacaanmu ditolak oleh admin.",
                style: TextStyle(fontSize: 14.0),
              ),
              const SizedBox(height: 3),
              const Divider(color: Colors.black),
              Text(
                "Last updated: ${DateFormat('dd/MM/yyyy | HH:mm:ss').format(data[index].fields.lastUpdated)}",
                style: const TextStyle(fontSize: 14.0),
              ),
              const Divider(color: Colors.black),
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
            if (data[index].fields.state == 1) ...[
              const SizedBox(height: 3),
              Text(
                "${data[index].fields.title}",
                style: const TextStyle(
                    fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              Text(
                'Author: ${data[index].fields.author}',
                textAlign: TextAlign.center,
              ),
              Text(
                'Description: ${data[index].fields.description}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              const Divider(color: Colors.black),
              Text(
                "Last updated: ${DateFormat('dd/MM/yyyy | HH:mm:ss').format(data[index].fields.lastUpdated)}",
                style: const TextStyle(fontSize: 14.0),
              ),
              const Divider(color: Colors.black),
              LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
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
                          child: const Text('Visit Link'),
                        ),
                        const SizedBox(width: 5),
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
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            _launchURL(data[index].fields.link);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          child: const Text('Visit Link'),
                        ),
                        const SizedBox(height: 5),
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
                  }
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
