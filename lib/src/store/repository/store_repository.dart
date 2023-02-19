import 'package:dio/dio.dart';
import 'package:testing_bloc_api_rest/src/store/model/product.dart';

class StoreRepository {
  final Dio _client = Dio(BaseOptions(
    baseUrl: 'https://fakestoreapi.com/products',
  ));

  Future<List<Product>> getProducts() async {
    final response = await _client.get('');
    return (response.data as List)
        .map(
          (json) => Product(
            id: json['id'],
            title: json['title'],
            image: json['image'],
          ),
        )
        .toList();
  }
}
