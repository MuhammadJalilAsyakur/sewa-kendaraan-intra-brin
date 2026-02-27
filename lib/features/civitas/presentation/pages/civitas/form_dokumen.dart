import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:vehicle_rental/features/civitas/presentation/pages/civitas/tracking_civitas_page.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/sewa_kendaraan_provider.dart';
import 'package:vehicle_rental/features/civitas/presentation/providers/tracking_provider.dart';

class FormDokumen extends StatelessWidget {
  const FormDokumen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SewaKendaraanProvider>();
    final dokumen = provider.dokumenPersyaratan;
    final kegiatan = provider.kegiatanDanTujuan;
    final waktuPeminjaman = provider.waktuPeminjaman;
    final penumpang = provider.dataPenumpangDanPengemudi;
    final dataPemohon = provider.dataPemohon;
    final adminInfo = provider.administrasiInfo;
    final penananggungJawab = provider.dataPenanggungJawab;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildCard(
            title: 'Dokumen Persyaratan',
            subtitle: 'Silahkan upload file Syarat Peminjaman dalam bentuk PDF',
            children: [
              const Text(
                'Surat Tugas *',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        dokumen.suratTugas ?? 'choose file',
                        style: TextStyle(
                          color: dokumen.suratTugas != null
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      provider.pickSuratTugas(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD32F2F),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Browse',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            title: 'Ringkasan Permohonan',
            items: [
              _SummaryItem('Nama Kegiatan', kegiatan.namaKegiatan),
              _SummaryItem('Kawasan', adminInfo.kawasan),
              _SummaryItem('Tujuan perjalanan', kegiatan.tujuanPerjalanan),
              _SummaryItem('Keperluan', kegiatan.keperluan),
              _SummaryItem(
                'Tanggal mulai pinjam',
                waktuPeminjaman.tanggalMulaiPinjam != null
                    ? DateFormat(
                        'd - M - yyyy HH:mm',
                      ).format(waktuPeminjaman.tanggalMulaiPinjam!)
                    : '-',
              ),
              _SummaryItem(
                'Tanggal selesai pinjam',
                waktuPeminjaman.tanggalSelesaiPinjam != null
                    ? DateFormat(
                        'd - M - yyyy HH:mm',
                      ).format(waktuPeminjaman.tanggalSelesaiPinjam!)
                    : '-',
              ),
              _SummaryItem(
                'Jumlah penumpang',
                penumpang.jumlahPenumpang?.toString(),
              ),
              _SummaryItem('Status Pengemudi', penumpang.statusPengemudi),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            title: 'Ringkasan Indentitas Pemohon',
            items: [
              _SummaryItem('Nama Pemohon', dataPemohon?.nama),
              _SummaryItem('NIP Pemohon', dataPemohon?.nip),
              _SummaryItem('Nomor Ponsel Pemohon', dataPemohon?.nomorHp),
              _SummaryItem('Satuan kerja pemohon', dataPemohon?.satuanKerja),
              _SummaryItem(
                'Tanggal Permohonan',
                adminInfo.tanggalPermohonan != null
                    ? DateFormat(
                        'd - M - yyyy HH:mm',
                      ).format(adminInfo.tanggalPermohonan!)
                    : '-',
              ),
              _SummaryItem(
                'No. Surat Pengantar',
                adminInfo.nomorSuratPengantar,
              ),
              _SummaryItem(
                'Tanggal Surat Pengantar',
                adminInfo.tanggalSuratPengantar != null
                    ? DateFormat(
                        'd - M - yyyy',
                      ).format(adminInfo.tanggalSuratPengantar!)
                    : '-',
              ),
              _SummaryItem(
                'Keterangan Permohonan',
                adminInfo.keteranganPemohon,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            title: 'Ringkasan Indentitas Penanggung jawab',
            items: [
              _SummaryItem(
                'Nama Penanggung jawab',
                penananggungJawab.namaPenanggungJawab,
              ),
              _SummaryItem(
                'Nomor Ponsel Penanggung jawab',
                penananggungJawab.nomorHpPenanggungJawab,
              ),
              _SummaryItem('Email penanggung jawab', penananggungJawab.email),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD32F2F),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: provider.isLoading
                  ? null
                  : () async {
                      final trackingData = await provider.submit();

                      if (trackingData != null && context.mounted) {
                        final trackingProvider = context
                            .read<TrackingProvider>();

                        if (trackingData['isEdit'] == true) {
                          trackingProvider.updateTrackingItem(
                            trackingData['id'],
                            trackingData['detailData'],
                          );
                        } else {
                          await trackingProvider.createTrackingFromData(
                            id: trackingData['id'],
                            status: trackingData['status'],
                            tanggalPengajuan: trackingData['tanggalPengajuan'],
                            judul: trackingData['judul'],
                            keperluan: trackingData['keperluan'],
                            periode: trackingData['periode'],
                            detailData: trackingData['detailData'],
                          );
                        }

                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('berhasil'),
                            content: const Text(
                              'Permohonan sewa berhasil dikirim.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  context
                                      .read<SewaKendaraanProvider>()
                                      .resetForm();

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const TrackingPage(),
                                    ),
                                  );
                                },
                                child: const Text('Lihat tracking'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
              child: provider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Kirim'),
                        SizedBox(width: 8),
                        Icon(Icons.check, size: 20),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Icon(Icons.expand_less),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required List<_SummaryItem> items,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 140,
                    child: Text(
                      item.label,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  const Text(' : ', style: TextStyle(fontSize: 12)),
                  Expanded(
                    child: Text(
                      item.value ?? '-',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem {
  final String label;
  final String? value;
  _SummaryItem(this.label, this.value);
}
