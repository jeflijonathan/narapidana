import 'package:flutter/material.dart';
import 'package:narapidana/services/narapidana_service.dart';
import '../models/narapidana_model.dart';

class EditNarapidanaScreen extends StatefulWidget {
  final Narapidana data;

  const EditNarapidanaScreen({super.key, required this.data});

  @override
  State<EditNarapidanaScreen> createState() => _EditNarapidanaScreenState();
}

class _EditNarapidanaScreenState extends State<EditNarapidanaScreen> {
  final NarapidanaService service = NarapidanaService();

  late TextEditingController namaController;
  late TextEditingController umurController;
  late TextEditingController kasusController;

  late String jk;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.data.nama);
    umurController = TextEditingController(text: widget.data.umur);
    kasusController = TextEditingController(text: widget.data.kasus);
    
    // Pastikan jk valid, jika tidak atur ke Laki-laki sebagai default yang aman
    jk = ["Laki-laki", "Perempuan"].contains(widget.data.jk) 
        ? widget.data.jk 
        : "Laki-laki";
  }

  @override
  void dispose() {
    namaController.dispose();
    umurController.dispose();
    kasusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("Edit Narapidana"),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 🔵 HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade900, Colors.blue.shade700],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  Icon(Icons.edit, color: Colors.white, size: 40),
                  SizedBox(width: 12),
                  Text(
                    "Update Data",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 📄 FORM
            _inputField(
              controller: namaController,
              label: "Nama",
              icon: Icons.person,
            ),

            _dropdownField(),

            _inputField(
              controller: umurController,
              label: "Umur",
              icon: Icons.calendar_today,
              isNumber: true,
            ),

            _inputField(
              controller: kasusController,
              label: "Kasus",
              icon: Icons.gavel,
            ),

            const SizedBox(height: 20),

            // 💾 BUTTON
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Update Data"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[900],
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _updateData,
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 INPUT FIELD
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue[900]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // 🔹 DROPDOWN
  Widget _dropdownField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: DropdownButtonFormField<String>(
        value: jk,
        items: [
          "Laki-laki",
          "Perempuan",
        ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
        onChanged: (value) {
          setState(() {
            jk = value!;
          });
        },
        decoration: InputDecoration(
          labelText: "Jenis Kelamin",
          prefixIcon: Icon(Icons.people, color: Colors.blue[900]),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // 🔥 FUNCTION UPDATE
  void _updateData() async {
    if (namaController.text.isEmpty ||
        umurController.text.isEmpty ||
        kasusController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Semua field wajib diisi!"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await service.updateData(
      Narapidana(
        id: widget.data.id,
        nama: namaController.text,
        jk: jk,
        umur: umurController.text,
        kasus: kasusController.text,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Data berhasil diperbarui!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }
}
