// ═══════════════════════════════════════════════════════════
// BUSLIN KEY GENERATOR — khusus HP OWNER. JANGAN disebarluaskan.
// PIN: 197900 (ganti di const PIN di bawah bila perlu)
// ═══════════════════════════════════════════════════════════
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const String PIN = '197900';
const String SECRET = 'BUSLINBROS-RAHASIA-2026';

void main() => runApp(const KeygenApp());

class KeygenApp extends StatelessWidget {
  const KeygenApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'BUSLIN KeyGen',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
        home: const PinGate(),
      );
}

// ───────────── PINTU PIN ─────────────
class PinGate extends StatefulWidget {
  const PinGate({super.key});
  @override
  State<PinGate> createState() => _PinGateState();
}

class _PinGateState extends State<PinGate> {
  final pin = TextEditingController();
  bool lolos = false;

  void _cekPin() {
    if (pin.text.trim() == PIN) {
      setState(() => lolos = true);
    } else {
      pin.clear();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PIN salah.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (lolos) return const GeneratorPage();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.lock, size: 64, color: Colors.green),
            const SizedBox(height: 12),
            const Text('BUSLIN KEY GENERATOR',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: pin,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 6,
              onSubmitted: (_) => _cekPin(),
              decoration: const InputDecoration(
                labelText: 'PIN',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                  onPressed: _cekPin, child: const Text('Buka')),
            ),
          ]),
        ),
      ),
    );
  }
}

// ───────────── GENERATOR ─────────────
class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});
  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  final kodeHp = TextEditingController();
  final tgl = TextEditingController();
  String? hasil;

  @override
  void initState() {
    super.initState();
    final n = DateTime.now();
    tgl.text = '${n.year + 1}-${n.month.toString().padLeft(2, '0')}-'
        '${n.day.toString().padLeft(2, '0')}';
  }

  String _kodeUntuk(String device, DateTime t) {
    final days = DateTime(t.year, t.month, t.day).millisecondsSinceEpoch ~/
        86400000;
    final h =
        sha256.convert(utf8.encode('$SECRET|$device|$days')).toString();
    var digits = '';
    for (final ch in h.codeUnits) {
      if (ch >= 48 && ch <= 57) digits += String.fromCharCode(ch);
      if (digits.length == 10) break;
    }
    return digits;
  }

  void _generate() {
    final dev = kodeHp.text.trim().toUpperCase().replaceAll('-', '');
    if (dev.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Masukkan Kode HP mandor (8 karakter).')));
      return;
    }
    DateTime? t;
    try {
      final p = tgl.text.trim().split('-');
      t = DateTime(int.parse(p[0]), int.parse(p[1]), int.parse(p[2]));
    } catch (_) {}
    if (t == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Format tanggal harus YYYY-MM-DD.')));
      return;
    }
    setState(() => hasil = _kodeUntuk(dev, t!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BUSLIN KeyGen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.lock_reset),
            tooltip: 'Kunci kembali',
            onPressed: () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const PinGate())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          TextField(
            controller: kodeHp,
            textCapitalization: TextCapitalization.characters,
            decoration: const InputDecoration(
              labelText: 'Kode HP mandor (contoh: A3F977B2)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: tgl,
            decoration: const InputDecoration(
              labelText: 'Berlaku sampai (YYYY-MM-DD)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _generate,
              icon: const Icon(Icons.bolt),
              label: const Text('GENERATE'),
            ),
          ),
          const SizedBox(height: 24),
          if (hasil != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: Column(children: [
                Text('KODE AKTIVASI — HP ${kodeHp.text.trim().toUpperCase()}',
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 8),
                SelectableText(hasil!,
                    style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4)),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: hasil!));
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Kode tersalin.')));
                  },
                  icon: const Icon(Icons.copy),
                  label: const Text('Salin'),
                ),
              ]),
            ),
          const SizedBox(height: 16),
          const Text(
              'Kode hanya berfungsi di HP dengan Kode HP tersebut.\n'
              'Aplikasi ini JANGAN dibagikan ke siapa pun.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}
