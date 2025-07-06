import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/jadwal_controller.dart';

class JadwalView extends GetView<JadwalController> {
  @override
  Widget build(BuildContext context) {
    Get.put(JadwalController());

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder(
          stream: controller.streamJadwalData(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            }

            if (snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No data available'));
            }

            return SingleChildScrollView(
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
                        label: Center(child: Text('Mata Uji')),
                        tooltip: 'Mata Uji',
                      ),
                      DataColumn(
                        label: Center(child: Text('Kelompok')),
                        tooltip: 'Kelompok',
                      ),
                      DataColumn(
                        label: Center(child: Text('Tanggal Ujian')),
                        tooltip: 'Tanggal Ujian',
                      ),
                      DataColumn(
                        label: Center(child: Text('Ruangan')),
                        tooltip: 'Ruangan',
                      ),
                      DataColumn(
                        label: Center(child: Text('Keterangan')),
                        tooltip: 'Keterangan',
                      ),
                      DataColumn(
                        label: Center(child: Text('Aksi')),
                        tooltip: 'Hapus',
                      ),
                    ],
                    rows: snapshot.data!.docs.asMap().entries.map((entry) {
                      var data = entry.value.data() as Map<String, dynamic>;
                      DateTime tanggalUjian =
                          (data['tanggal_ujian'] as Timestamp).toDate();
                      String formattedTanggalUjian =
                          DateFormat('MMMM dd, yyyy hh:mm a')
                              .format(tanggalUjian);

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
                            child: Text(data['mata_uji'].toString()),
                          )),
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(data['kelompok'].toString()),
                          )),
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(formattedTanggalUjian),
                          )),
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(data['ruangan'].toString()),
                          )),
                          DataCell(Container(
                            alignment: Alignment.center,
                            child: Text(data['keterangan'].toString()),
                          )),
                          DataCell(
                            ElevatedButton(
                              onPressed: () {
                                // Show confirmation dialog
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Konfirmasi'),
                                      content: Text(
                                          'Apakah Anda yakin ingin menghapus mata uji ini?'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            // Delete the data
                                            await controller.deleteJadwal(entry.value.id);
                                            // Show a snackbar notification
                                            Get.snackbar(
                                              'Sukses',
                                              'Data berhasil dihapus',
                                              duration: Duration(seconds: 2),
                                              snackPosition: SnackPosition.TOP,
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white
                                            );

                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: Text('Ya, Hapus Sekarang'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red, // Set background color to red
                              ),
                              child: Text('Hapus'),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
