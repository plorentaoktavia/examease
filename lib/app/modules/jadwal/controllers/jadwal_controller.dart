import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class JadwalController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<QueryDocumentSnapshot<Map<String, dynamic>>> jadwalData = [];

  Future<void> getJadwalData() async {
    try {
      var result = await firestore.collection('jadwal').get();
      jadwalData = result.docs;
      update();
    } catch (e) {
      print(e);
    }
  }

  Stream<QuerySnapshot<Object?>> streamJadwalData() {
    CollectionReference jadwalCollection = firestore.collection('jadwal');
    return jadwalCollection.snapshots();
  }

  void addJadwal(
    String mataUji,
    String kelompok,
    String tanggalUjian,
    String ruangan,
    String keterangan,
    String aksi,
  ) async {
    CollectionReference jadwalCollection = firestore.collection("jadwal");

    try {
      await jadwalCollection.add({
        "mata_uji": mataUji,
        "kelompok": kelompok,
        "tanggal_ujian": tanggalUjian,
        "ruangan": ruangan,
        "keterangan": keterangan,
        "aksi": aksi,
      });

      Get.defaultDialog(
        title: "Berhasil",
        middleText: "Berhasil menyimpan data jadwal",
        onConfirm: () {
          // Clear text controllers and close dialogs as needed
          // Add your logic here
        },
      );
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Gagal Menambahkan Jadwal.",
      );
    }
  }

 Future<void> deleteJadwal(String documentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('jadwal')
          .doc(documentId)
          .delete();
      // Optionally, update your data or perform other actions after deletion
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    getJadwalData();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
