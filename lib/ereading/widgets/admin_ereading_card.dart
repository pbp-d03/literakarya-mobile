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
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "${data[index].fields.title}",
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Author: ${data[index].fields.author}',
              textAlign: TextAlign.center,
            ),
            Text(
              'Description: ${data[index].fields.description}',
              textAlign: TextAlign.center,
            ),
            Text(
              "Added by: ${data[index].fields.createdBy}",
              style: const TextStyle(fontSize: 14.0),
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
                        onPressed: () => onAccept(index, data),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Accept',
                          style: TextStyle(color: Colors.green),
                        ),
                      ),
                      const SizedBox(width: 5),
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
                  return Column(
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
                      const SizedBox(height: 5),
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
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
