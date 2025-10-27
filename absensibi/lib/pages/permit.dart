import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'home.dart';
import 'calendar.dart';
import 'qr.dart';
import 'settings.dart';
import 'permithistory.dart';
import 'package:absensibi/low_spec_animation.dart';

class PermitPage extends StatefulWidget {
  const PermitPage({super.key});

  @override
  State<PermitPage> createState() => _PermitPageState();
}

class _PermitPageState extends State<PermitPage> {
  static const Color kPrimary = Colors.purple;
  static const int kMaxBytes = 2 * 1024 * 1024; // 2 MB

  final _descCtrl = TextEditingController();
  final _picker = ImagePicker();
  final _scrollCtrl = ScrollController();

  File? _photo;

  @override
  void dispose() {
    _descCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFrom(ImageSource source) async {
    final XFile? x = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (x == null) return;

    final f = File(x.path);
    final size = await f.length();
    if (size > kMaxBytes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto tidak lebih dari 2 MB')),
      );
      return;
    }
    setState(() => _photo = f);
  }

  void _chooseImage() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickFrom(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickFrom(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    final desc = _descCtrl.text.trim();
    if (desc.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Deskripsi wajib diisi')));
      return;
    }
    if (_photo == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Unggah foto surat izin')));
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    await Future.delayed(const Duration(milliseconds: 900));
    if (mounted) Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Izin terkirim!')),
    );

    setState(() {
      _descCtrl.clear();
      _photo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6), // light gray bg
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimary,
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'FORM IZIN',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.1,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollCtrl,
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
          child: Column(
            children: [
              const _WhiteCard(
                child: _DescField(),
              ),
              const SizedBox(height: 12),
              _WhiteCard(
                child: _photo == null
                    ? _UploadPlaceholder(onTap: _chooseImage)
                    : _PhotoPreview(
                        file: _photo!,
                        onChange: _chooseImage,
                        onRemove: () => setState(() => _photo = null),
                      ),
              ),
              const SizedBox(height: 12),
              // Submit
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: kPrimary,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Submit',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // History
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      LowSpecPageRoute(builder: (_) => const PermitHistoryPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: kPrimary,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'History',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom nav (Permit active)
      bottomNavigationBar: _navBar(context),
    );
  }

  static Container _navBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(context, LowSpecPageRoute(builder: (_) => const HomePage())),
            child: SvgPicture.asset(
              'assets/svg/home.svg', width: 26, height: 26,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, LowSpecPageRoute(builder: (_) => const CalendarPage())),
            child: SvgPicture.asset(
              'assets/svg/calendar.svg', width: 26, height: 26,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, LowSpecPageRoute(builder: (_) => const QRPage())),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: kPrimary),
              child: SvgPicture.asset(
                'assets/svg/qr.svg', width: 26, height: 26,
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              'assets/svg/permit.svg', width: 26, height: 26,
              colorFilter: const ColorFilter.mode(kPrimary, BlendMode.srcIn), // active
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.push(context, LowSpecPageRoute(builder: (_) => const SettingsPage())),
            child: SvgPicture.asset(
              'assets/svg/settings.svg', width: 26, height: 26,
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------- UI bits ----------

class _WhiteCard extends StatelessWidget {
  final Widget child;
  const _WhiteCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }
}

class _DescField extends StatelessWidget {
  const _DescField();

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_PermitPageState>()!;
    return TextField(
      controller: state._descCtrl,
      maxLines: 3,
      decoration: const InputDecoration(
        hintText: 'Deskripsi',
        border: InputBorder.none,
      ),
    );
  }
}

class _UploadPlaceholder extends StatelessWidget {
  final VoidCallback onTap;
  const _UploadPlaceholder({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: const SizedBox(
        height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Fotokan Surat Izin', style: TextStyle(fontWeight: FontWeight.w600)),
            SizedBox(height: 16),
            Icon(Icons.upload_rounded, size: 48, color: Colors.black87),
            SizedBox(height: 10),
            Text('Foto tidak lebih dari', style: TextStyle(color: Colors.black54, fontSize: 12)),
            Text('2 MB', style: TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  final File file;
  final VoidCallback onChange;
  final VoidCallback onRemove;
  const _PhotoPreview({
    required this.file,
    required this.onChange,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(file, height: 200, width: double.infinity, fit: BoxFit.cover),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onChange,
                icon: const Icon(Icons.swap_horiz_rounded),
                label: const Text('Ubah Foto'),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: onRemove,
              tooltip: 'Hapus',
              icon: const Icon(Icons.delete_outline_rounded),
            ),
          ],
        ),
      ],
    );
  }
}
