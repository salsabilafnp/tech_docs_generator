import 'package:tech_docs_generator/app/modules/models/project_brief.dart';

final List<ProjectBrief> dummyBriefs = [
  ProjectBrief(
    id: 1,
    projectTitle: 'Aplikasi E-Commerce "TokoKita"',
    docVersion: '1.0',
    author: 'Andi Pratama',
    problem:
        'Pengguna kesulitan mencari produk fashion lokal yang terkurasi dalam satu platform.',
    vision:
        'Menjadi platform e-commerce terdepan untuk brand fashion lokal di Indonesia.',
    targetUser:
        'Anak muda usia 18-30 tahun yang tertarik dengan produk fashion lokal.',
    uiDesignLink: 'https://figma.com/tokokita',
    architectureLink: 'https://miro.com/tokokita-arch',
    techTools: ['Flutter', 'Firebase', 'Git', 'VS Code'],
    coreFeatures: [
      CoreFeature(
        name: 'Pencarian Produk Cerdas',
        description:
            'Fitur pencarian dengan filter canggih berdasarkan kategori, harga, dan rating.',
      ),
      CoreFeature(
        name: 'Rekomendasi Personalisasi',
        description:
            'Sistem AI yang merekomendasikan produk berdasarkan riwayat penelusuran pengguna.',
      ),
    ],
    userScenario: [
      UserScenario(
        useCaseName: 'Pembelian Produk',
        useCaseScenario:
            'Pengguna mencari jaket, memfilter berdasarkan ukuran, memasukkan ke keranjang, dan membayar.',
        diagramPath: null,
      ),
      UserScenario(
        useCaseName: 'Memberikan Ulasan',
        useCaseScenario:
            'Setelah menerima barang, pengguna membuka riwayat pesanan dan memberikan rating serta ulasan foto.',
        diagramPath: null,
      ),
    ],
  ),
  ProjectBrief(
    id: 2,
    projectTitle: 'Sistem Manajemen Tugas "ProTask"',
    docVersion: '1.2',
    author: 'Budi Santoso',
    problem:
        'Tim kecil sering kehilangan jejak tugas dan deadline karena menggunakan spreadsheet yang tidak efisien.',
    vision:
        'Menyediakan alat manajemen tugas yang simpel namun powerful untuk meningkatkan produktivitas tim.',
    targetUser: 'Startup dan tim proyek kecil (2-10 orang).',
    uiDesignLink: 'https://figma.com/protask',
    architectureLink: 'https://miro.com/protask-arch',
    techTools: ['Flutter', 'Node.js', 'PostgreSQL', 'Docker'],
    coreFeatures: [
      CoreFeature(
        name: 'Kanban Board',
        description:
            'Visualisasi tugas dalam kolom "To Do", "In Progress", dan "Done".',
      ),
      CoreFeature(
        name: 'Fitur Komentar',
        description: 'Kolaborasi tim melalui komentar di setiap kartu tugas.',
      ),
    ],
    userScenario: [
      UserScenario(
        useCaseName: 'Pembuatan Tugas Baru',
        useCaseScenario:
            'Manajer proyek membuat tugas baru, mengisi detail, menetapkan deadline, dan menugaskan ke anggota tim.',
        diagramPath: null,
      ),
    ],
  ),
];
