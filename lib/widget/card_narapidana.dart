import 'package:flutter/material.dart';
import 'package:narapidana/models/narapidana_model.dart';
import 'package:narapidana/services/narapidana_service.dart';
import '../screens/edit_narapidana_screen.dart';

class NarapidanaCard extends StatelessWidget {
  final Narapidana data;

  const NarapidanaCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          // 👤 ICON
          const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.blue),
          ),

          const SizedBox(width: 12),

          // 📄 DATA
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.nama,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${data.jk} • ${data.umur} tahun",
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  "Kasus: ${data.kasus}",
                  style: const TextStyle(
                    color: Colors.yellowAccent,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // ⚙️ AKSI (Edit & Delete)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                tooltip: 'Edit',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditNarapidanaScreen(data: data),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                tooltip: 'Hapus',
                onPressed: () {
                  _showDeleteDialog(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Menampilkan Dialog Konfirmasi Hapus
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Konfirmasi Hapus"),
          content: Text("Apakah kamu yakin ingin menghapus data ${data.nama}?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Batal
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(context); // Tutup dialog
                await NarapidanaService().hapusData(data.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Data ${data.nama} berhasil dihapus"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text("Hapus", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
