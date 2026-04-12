import '../models/place.dart';

class PlaceService {
  Future<List<Place>> getPlaces() async {
    await Future.delayed(const Duration(seconds: 2));

    return [
      Place(
        id: '1',
        name: 'Đà Lạt',
        location: 'Lâm Đồng',
        rating: 4.5,
        image: 'assets/images/DaLat.jpg',
          price: 1800000
      ),
      Place(
        id: '2',
        name: 'Hà Nội',
        location: 'Hà Nội',
        rating: 4.7,
        image: 'assets/images/HaNoi.jpg',
          price: 1800000
      ),
      Place(
        id: '3',
        name: 'TP.HCM',
        location: 'TP.HCM',
        rating: 4.6,
        image: 'assets/images/HCM.jpg',
          price: 1800000
      ),
      Place(
        id: '4',
        name: 'Nha Trang',
        location: 'Khánh Hòa',
        rating: 4.6,
        image: 'assets/images/NhaTrang.jpg',
          price: 1800000
      ),
      Place(
        id: '5',
        name: 'Phú Quốc',
        location: 'Kiên Giang',
        rating: 4.7,
        image: 'assets/images/PhuQuoc.jpg',
          price: 1800000
      ),
      Place(
        id: '6',
        name: 'Vũng Tàu',
        location: 'Bà Rịa - Vũng Tàu',
        rating: 4.5,
        image: 'assets/images/VungTau.jpg',
          price: 1800000
      ),
    ];
  }
}