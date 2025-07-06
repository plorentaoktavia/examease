import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.announcement,
                          size: 30,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Ketentuan Ujian ExamEase',
                          style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Divider(height: 20, thickness: 2),
                    SizedBox(height: 20),
                    buildPointText('1. Silakan perbarui foto profil di sistem Exam Ease sesuai standar pas foto resmi.'),
                    buildPointText('2. Cetak kartu ujian melalui sistem Exam Ease sebelum hari pelaksanaan.'),
                    buildPointText('3. Kartu ujian wajib dibawa saat mengikuti ujian di platform Exam Ease.'),
                    buildPointText('4. Peserta wajib mengenakan pakaian resmi dan jas almamater saat mengikuti ujian.'),
                    buildPointText('5. Peserta yang terlambat atau tidak membawa kartu ujian tidak diperkenankan mengikuti ujian.'),
                    buildPointText('6. Peserta yang tidak hadir tanpa konfirmasi sebelumnya, biaya pendaftaran dianggap hangus.'),
                    buildPointText('7. Ujian harus diikuti hingga dinyatakan lulus dengan nilai minimal A.'),
                    buildPointText('8. Nilai ujian Exam Ease hanya berlaku selama 1 tahun.'),
                    buildPointText('9. Peserta wajib mengikuti seluruh prosedur yang telah ditentukan oleh sistem.'),
                    buildPointText('10. Untuk pertanyaan seputar ujian atau pelatihan, hubungi WhatsApp: 0812 3456 7890.'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPointText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
