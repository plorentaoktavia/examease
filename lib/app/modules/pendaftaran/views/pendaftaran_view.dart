import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../controllers/pendaftaran_controller.dart';

class PendaftaranView extends StatelessWidget {
  const PendaftaranView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(PendaftaranController());

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<void>(
          future: Get.find<PendaftaranController>().getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final controller = Get.find<PendaftaranController>();
            if (controller.data == null) {
              return const Center(child: CircularProgressIndicator());
            }

            int nomor = 1; // Initialize counter

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Data Mata Uji Dibuka',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                            label: Center(child: Text('Mata Uji')),
                            tooltip: 'Mata Uji',
                          ),
                          DataColumn(
                            label: Center(child: Text('Biaya')),
                            tooltip: 'Biaya',
                          ),
                          DataColumn(
                            label: Center(child: Text('Kelompok')),
                            tooltip: 'Kelompok',
                          ),
                          DataColumn(
                            label: Center(child: Text('Kuota')),
                            tooltip: 'Kuota',
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
                            tooltip: 'Ambil Sekarang',
                          ),
                        ],
                        rows: controller.data!.asMap().entries.map((entry) {
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
                                child: Text('Rp. ' + data['biaya'].toString()),
                              )),
                              DataCell(Container(
                                alignment: Alignment.center,
                                child: Text(data['kelompok'].toString()),
                              )),
                              DataCell(Container(
                                alignment: Alignment.center,
                                child: Text(data['kuota'].toString()),
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
                                  onPressed: () async {
                                    // Check if mata uji is already in the schedule
                                    QuerySnapshot querySnapshot =
                                        await FirebaseFirestore.instance
                                            .collection('jadwal')
                                            .where('mata_uji',
                                                isEqualTo: data['mata_uji'])
                                            .get();

                                    if (querySnapshot.docs.isNotEmpty) {
                                      // Show notification if mata uji is already in the schedule
                                      Get.snackbar(
                                        'Perhatian',
                                        'Mata uji sudah diambil',
                                        duration: Duration(seconds: 2),
                                        snackPosition: SnackPosition.TOP,
                                        backgroundColor: Colors.red,
                                        colorText: Colors.white,
                                      );
                                    } else {
                                      // Show confirmation dialog
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Konfirmasi'),
                                            content: Text(
                                              'Apakah Anda yakin ingin mengambil mata uji ini?',
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Batal'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  // Add data to the "jadwal" collection
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('jadwal')
                                                      .add({
                                                    'mata_uji':
                                                        data['mata_uji'],
                                                    'kelompok':
                                                        data['kelompok'],
                                                    'tanggal_ujian':
                                                        data['tanggal_ujian'],
                                                    'ruangan': data['ruangan'],
                                                    'keterangan':
                                                        data['keterangan'],
                                                  });

                                                  // Show a snackbar notification
                                                  Get.snackbar(
                                                    'Sukses',
                                                    'Data berhasil ditambahkan, silahkan cek jadwal Ujian',
                                                    duration:
                                                        Duration(seconds: 2),
                                                    snackPosition:
                                                        SnackPosition.TOP,
                                                    backgroundColor:
                                                        Colors.green,
                                                    colorText: Colors.white
                                                  );
                                                  Navigator.of(context).pop();
                                                },
                                                child:
                                                    Text('Ya, Ambil Sekarang'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors
                                        .green, // Set background color to green
                                  ),
                                  child: Text('Ambil Sekarang'),
                                ),
                              ),
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
