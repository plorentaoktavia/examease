import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PengumumanController extends GetxController {
  late TextEditingController cJudul;
  late TextEditingController cDeskripsi;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> data = [];

  Future<void> getData() async {
    try {
      var result = await firestore.collection('pengumuman').get();
      data = result.docs;
      update();
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot<Object?>> streamData() {
    CollectionReference pengumuman = firestore.collection('pengumuman');
    return pengumuman.snapshots();
  }

  Future<void> addAnnouncement(String judul, String deskripsi) async {
    try {
      await firestore.collection('pengumuman').add({
        'judul': judul,
        'deskripsi': deskripsi,
        'created_at': FieldValue.serverTimestamp(),
        'isNew': true,
      });
    } catch (e) {
      print(e);
    }
  }

  // Add other methods for specific use cases

  @override
  void onInit() {
    cJudul = TextEditingController();
    cDeskripsi = TextEditingController();

    getData();

    super.onInit();
  }

  @override
  void onClose() {
    cJudul.dispose();
    cDeskripsi.dispose();
    super.onClose();
  }
}
