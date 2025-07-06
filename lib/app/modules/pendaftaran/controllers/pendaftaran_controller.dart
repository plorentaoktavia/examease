import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PendaftaranController extends GetxController {
  late TextEditingController cMataUji;
  late TextEditingController cBiaya;
  late TextEditingController cKelompok;
  late TextEditingController cKuota;
  late TextEditingController cTanggalUjian;
  late TextEditingController cRuangan;
  late TextEditingController cKeterangan;
  late TextEditingController cAksi;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> data = [];

  Future<void> getData() async {
    try {
      var result = await firestore.collection('registration').get();
      data = result.docs;
      update();
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot<Object?>> streamData() {
    CollectionReference registration = firestore.collection('registration');
    return registration.snapshots();
  }

  void add(
    String mataUji,
    String biaya,
    String kelompok,
    String kuota,
    String tanggalUjian,
    String ruangan,
    String keterangan,
    String aksi,
  ) async {
    CollectionReference registration = firestore.collection("registration");

    try {
      await registration.add({
        "mata_uji": mataUji,
        "biaya": biaya,
        "kelompok": kelompok,
        "kuota": kuota,
        "tanggal_ujian": tanggalUjian,
        "ruangan": ruangan,
        "keterangan": keterangan,
        "aksi":aksi
      });

      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Berhasil menyimpan data registrasi",
        onConfirm: () {
          // Clear text controllers and close dialogs as needed
          // Add your logic here
        },
      );
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Gagal Menambahkan Registrasi.",
      );
    }
  }

  // Add/update/delete methods for specific use cases

 @override
  void onInit() {
    cMataUji = TextEditingController();
    cBiaya = TextEditingController();
    cKelompok = TextEditingController();
    cKuota = TextEditingController();
    cTanggalUjian = TextEditingController();
    cRuangan = TextEditingController();
    cKeterangan = TextEditingController();
    cAksi = TextEditingController();

    getData();

    super.onInit();
  }

  @override
  void onClose() {
    cMataUji.dispose();
    cBiaya.dispose();
    cKelompok.dispose();
    cKuota.dispose();
    cTanggalUjian.dispose();
    cRuangan.dispose();
    cKeterangan.dispose();
    cAksi.dispose();
    super.onClose();
  }
}
