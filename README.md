[![Deploy](https://github.com/pbp-d03/literakarya-mobile/actions/workflows/dpl.yml/badge.svg)](https://github.com/pbp-d03/literakarya-mobile/actions/workflows/dpl.yml)
[![Build status](https://build.appcenter.ms/v0.1/apps/b227e6ad-6015-441a-aff0-28583e6127d5/branches/main/badge)](https://appcenter.ms)

-Link to App: [LiteraKarya](https://install.appcenter.ms/orgs/literakarya_mobile/apps/literakarya/distribution_groups/public)

# Proyek Akhir Semester

## Membuat Aplikasi Mobile menggunakan Framework Flutter (Berkelompok)


> [!NOTE] 
> Tujuan kami adalah merancang dan mengimplementasikan aplikasi mobile dengan menggunakan Flutter. Kami akan memastikan aplikasi yang dibuat memiliki fungsionalitas yang serupa dengan website yang kami buat sebelumnya pada Proyek Tengah Semester. Selain itu, kami juga akan memanfaatkan Material untuk memastikan tampilan aplikasi yang dibuat terlihat menarik.

### :technologist: Anggota Kelompok:

1. Ghania Larasati Nurjayadi Putri - 2206083003

2. I Putu Gede Kimi Agastya - 2206823695

3. Kristoforus Adi Himawan - 2206812174

4. Muh. Kemal Lathif Galih Putra - 2206081225

5. Shanti Yoga Rahayu - 2206082360

6. Syauqi Armanaya Syaki - 2206829010


### :fairy: Cerita aplikasi yang diajukan serta manfaat.

LiteraKarya adalah platform baca buku online yang memadukan kemudahan akses ke berbagai buku digital dengan elemen-elemen gamifikasi untuk meningkatkan semangat membaca. Dalam upaya memperluas wawasan literasi, LiteraKarya menawarkan berbagai informasi tentang buku, termasuk karya-karya dari penulis Indonesia dan luar negeri. Tak hanya koleksi buku, kami juga menghadirkan fitur-fitur menarik yang membuat pengalaman membaca lebih mengasyikkan. Sejalan dengan tema Kongres Bahasa Indonesia XII, kami berkomitmen untuk meningkatkan kesadaran akan pentingnya literasi dalam kemajuan bangsa dan merayakan kekayaan bahasa serta sastra Indonesia. LiteraKarya, solusi cerdas untuk memberdayakan pengguna dalam menjelajahi dunia literasi dengan semangat tinggi.

### :notebook_with_decorative_cover: Daftar modul yang akan diimplementasikan.

| **Modul** | **Pengembang** | **Deskripsi** |
| ------------ | ------------ | ------------ |
| Authentication | All members | Modul ini menyediakan mekanisme otentikasi dan otorisasi yang diperlukan untuk mengatur akses pengguna ke platform. |
| Persona | Syauqi Armanaya Syaki | Modul ini berfungsi untuk mengelola dan mengidentifikasi pengguna dengan mengisi profilnya, serta memberikan referensi buku untuk user tersebut berdasarkan genre favoritnya. |
| Homepage | All members | Modul ini menampilkan halaman utama setelah user berhasil login ke dalam website. Di halaman utama ini, terdapat katalog buku dan informasi dari beberapa pilihan buku yang genre nya sesuai dengan pilihan pengguna. Di halaman utama ini terdapat search bar untuk mencari nama buku yang diinginkan serta tombol untuk mengakses modul-modul lain. |
| Ereading | Kristoforus Adi Himawan | Modul ini memungkinkan pengguna untuk menggunakan LiteraKarya sebagai tempat menyimpan koleksi bacaan digital milik mereka. Untuk menambahkan, pengguna harus mengisi form berisi judul bacaan, nama penulis, deskripsi, serta link ke bacaan. Jika sudah disetujui oleh admin, bacaan digital milik pengguna akan ditampilkan di page Ereading. |
| Book Page | Muh. Kemal Lathif Galih Putra | Modul ini dapat menampilkan list dari buku-buku yang sesuai dari dataset dan juga menyediakan informasi rinci setiap buku, termasuk sinopsis, penulis, rating, dan ulasan untuk setiap buku yang dapat diakses oleh pengguna yang sudah login. Selain itu, pengguna yang sudah login dapat memberikan ulasan untuk buku-buku yang dipilih.  |
| Entertainment Space | Ghania Larasati Nurjayadi Putri | Modul ini memberikan pengalaman hiburan yang unik, termasuk konten-konten menarik yang tidak hanya menghibur tetapi juga mendidik.  |
| Notes | Shanti Yoga Rahayu | Modul ini menampilkan keterangan bagi pembaca.  Modul ini memungkinkan pembaca untuk membuat catatan pribadi sehubungan dengan isi buku.  Catatan berfungsi sebagai alat untuk membantu pembaca untuk mengingat informasi penting. Catatan-catatan ini bisa berupa pemikiran, pemahaman, atau pertanyaan yang muncul selama membaca.  |
| Forum Page | I Putu Gede Kimi Agastya | Modul ini memungkinkan user untuk saling berdiskusi dengan user lainnya. User dapat membuat forum yang membahas tentang suatu judul buku atau mengenai topik lainnya yang berkaitan dengan literasi. |


### :man_judge: Role atau peran pengguna beserta deskripsi.
1. Admin LiteraKarya = Admin memiliki wewenang dan hak lebih untuk memastikan semua user LiteraKarya mematuhi syarat dan ketentuan yang berlaku. Admin LiteraKarya harus login terlebih dahulu dengan username unik yang sudah dipersiapkan untuk bisa mengakses wewenang dan fitur lebihnya. Salah satu peran admin adalah dapat menghapus komentar negatif.

2. User = Sebelum bisa menggunakan fitur-fitur yang sudah disiapkan, user harus register dan login terlebih dahulu ke aplikasi LiteraKarya.


### Alur Pengintegrasian dengan Web Service untuk Terhubung dengan Aplikasi Web yang Sudah dibuat saat Proyek Tengah Semester
1. Website PTS yang sudah di-deploy akan kami siapkan agar memiliki backend yang dapat menampilkan data-data terkait dalam format JSON. 

2. Membuat file bernama fetch.dart dalam utils folder di module apps masing-masing anggota untuk mengakses data JSON dari backend secara async. File fetch.dart dilengkapi dengan function yang dapat dipanggil untuk me-return data yang diperlukan dalam suatu list. 

3. Function di dalam fetch.dart memiliki url yang dapat digunakan sebagai endpoint JSON untuk integrasi aplikasi.

4. Pemanggilan function dilakukan di widget terkait untuk diolah sesuai dengan kebutuhan fitur dari masing-masing module.



### :newspaper: Tautan berita acara.
Berita acara pengembangan aplikasi ini dapat diakses melalui tautan berikut:
https://docs.google.com/spreadsheets/d/102DaG-u7NE7jeJ_qGmq7lV5fmbtNTQvZ/edit?usp=sharing&ouid=105183920495456976872&rtpof=true&sd=true
