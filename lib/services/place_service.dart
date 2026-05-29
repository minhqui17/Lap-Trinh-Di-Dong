import 'package:travel_booking/models/place.dart';

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
        price: 1800000,
        latitude: 11.9404,
        longitude: 108.4583,
      ),
      Place(
        id: '2',
        name: 'Hà Nội',
        location: 'Hà Nội',
        rating: 4.7,
        image: 'assets/images/HaNoi.jpg',
        price: 1800000,
        latitude: 21.0285,
        longitude: 105.8542,
      ),
      Place(
        id: '3',
        name: 'TP.HCM',
        location: 'TP.HCM',
        rating: 4.6,
        image: 'assets/images/HCM.jpg',
        price: 1800000,
        latitude: 10.7769,
        longitude: 106.7009,
      ),
      Place(
        id: '4',
        name: 'Nha Trang',
        location: 'Khánh Hòa',
        rating: 4.6,
        image: 'assets/images/NhaTrang.jpg',
        price: 1800000,
        latitude: 12.2388,
        longitude: 109.1967,
      ),
      Place(
        id: '5',
        name: 'Phú Quốc',
        location: 'Kiên Giang',
        rating: 4.7,
        image: 'assets/images/PhuQuoc.jpg',
        price: 1800000,
        latitude: 10.2289,
        longitude: 103.9572,
      ),
      Place(
        id: '6',
        name: 'Vũng Tàu',
        location: 'Bà Rịa - Vũng Tàu',
        rating: 4.5,
        image: 'assets/images/VungTau.jpg',
        price: 1800000,
        latitude: 10.3460,
        longitude: 107.0843,
      ),
    ];
  }
}
