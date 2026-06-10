import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/carley_model.dart';

class MainShop extends StatefulWidget {
  const MainShop({super.key});

  @override
  State<MainShop> createState() => _MainShopState();
}

class _MainShopState extends State<MainShop> {
  final String apiUrl = "https://myfakeapi.com/api/cars/";
  List<Car> carList = [];
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchCarData();
  }

  Future<void> fetchCarData() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> carsJson = data['cars'] ?? [];

        setState(() {
          // Kita batasi .take(30) data saja agar aplikasi ringan dan lancar saat didemokan ujian
          carList = carsJson
              .take(30)
              .map((json) => Car.fromJson(json))
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = "Gagal memuat data: Status ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Terjadi kesalahan jaringan atau server.";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Definisi Warna Tema Sesuai Request Soal
    const Color navyBlue = Color(0xFF1E3A8A);
    const Color goldenOrange = Color(0xFFF59E0B);
    const Color darkBackground = Color(
      0xFF0F172A,
    ); // Background utama gelap premium
    const Color cardColor = Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: navyBlue,
        elevation: 4,
        title: Row(
          children: [
            const Icon(
              Icons.directions_car_filled,
              color: goldenOrange,
              size: 24,
            ),
            const SizedBox(width: 12),
            RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
                children: [
                  TextSpan(
                    text: 'carley',
                    style: TextStyle(color: Colors.white),
                  ),
                  TextSpan(
                    text: '_showroom',
                    style: TextStyle(color: goldenOrange),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: goldenOrange),
              )
            : errorMessage.isNotEmpty
            ? Center(
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.redAccent),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Temukan Mobil Impian",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Menampilkan ${carList.length} unit koleksi showroom terbaik",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: carList.length,
                      itemBuilder: (context, index) {
                        final car = carList[index];

                        // Menggunakan gambar mobil asli dari Unsplash berdasarkan ID agar bervariasi
                        final String carImageUrl =
                            "https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&w=500&q=80&random=${car.id}";

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: const Color(0xFF334155),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Wadah Gambar Mobil
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      carImageUrl,
                                      height: 180,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      // Loading placeholder jika internet lambat
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Container(
                                              height: 180,
                                              color: navyBlue.withOpacity(0.2),
                                              child: const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      color: goldenOrange,
                                                    ),
                                              ),
                                            );
                                          },
                                    ),
                                  ),
                                  // Badge Ketersediaan
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: car.isAvailable
                                            ? Colors.green.withOpacity(0.9)
                                            : Colors.redAccent.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        car.isAvailable
                                            ? "TERSEDIA"
                                            : "DIRESERVASI",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${car.brand} ${car.model}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          car.year.toString(),
                                          style: const TextStyle(
                                            color: goldenOrange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.palette,
                                          color: Colors.grey,
                                          size: 14,
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          "Warna: ${car.color}",
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Color(0xFF334155),
                                      height: 24,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          car.price,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: goldenOrange,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                          ),
                                          onPressed: car.isAvailable
                                              ? () {}
                                              : null,
                                          icon: const Icon(
                                            Icons.shopping_cart,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          label: const Text(
                                            "Beli",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
