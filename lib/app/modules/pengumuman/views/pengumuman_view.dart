import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:testgo/app/modules/pengumuman/controllers/pengumuman_controller.dart';

class PengumumanView extends StatelessWidget {
  const PengumumanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PengumumanController());

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<void>(
          future: Get.find<PengumumanController>().getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final controller = Get.find<PengumumanController>();
            if (controller.data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            int nomor = 1; // Initialize counter

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: DataTable(
                        columnSpacing: 20,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                        ),
                        headingRowColor: MaterialStateColor.resolveWith(
                          (Set<MaterialState> states) {
                            return Colors.blue;
                          },
                        ),
                        headingTextStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        columns: [
                          DataColumn(
                            label: Center(child: Text('#')),
                            tooltip: '#',
                          ),
                          DataColumn(
                            label: Center(child: Text('Judul')),
                            tooltip: 'judul',
                          ),
                          DataColumn(
                            label: Center(child: Text('Deskripsi')),
                            tooltip: 'deskripsi',
                          ),
                          DataColumn(
                            label: Center(child: Text('Created')),
                            tooltip: 'tanggal',
                          ),
                        ],
                        rows: controller.data!
                            .asMap()
                            .entries
                            .toList()
                            .reversed
                            .map((entry) {
                          var data = entry.value.data() as Map<String, dynamic>;
                          DateTime timestamp =
                              (data['created_at'] as Timestamp).toDate();
                          String formattedTimestamp =
                              DateFormat('MMMM dd, yyyy').format(timestamp);

                          return DataRow(
                            color: MaterialStateColor.resolveWith(
                              (Set<MaterialState> states) {
                                return Colors.grey.shade200;
                              },
                            ),
                            cells: [
                              DataCell(Container(
                                alignment: Alignment.center,
                                child: Text((entry.key + 1).toString()),
                              )),
                              DataCell(Container(
                                alignment: Alignment.center,
                                child: Text(data['judul'].toString()),
                              )),
                              DataCell(Container(
                                alignment: Alignment.center,
                                child: Text(data['deskripsi'].toString()),
                              )),
                              DataCell(Container(
                                alignment: Alignment.center,
                                child: Text(formattedTimestamp),
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
