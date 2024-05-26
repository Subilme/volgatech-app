import 'package:volgatech_client/category/model/entities/category.dart';
import 'package:volgatech_client/core/model/api/api_response.dart';
import 'package:volgatech_client/core/model/api/api_response_parser.dart';
import 'package:volgatech_client/core/model/api/private_api.dart';

class CategoryApi extends PrivateApi {
  CategoryApi({required super.appModel});

  Future<ApiResponse<List<Category>>> loadCategoryList({
    String searchString = "",
  }) async {
    var params = {
      if (searchString.isNotEmpty) "searchString": searchString,
    };

    var response = await sendGetRequest("category/list", params);
    return ApiResponseParser.parseListFromResponse(
      response,
      fromJson: (json) => Category.fromJson(json),
    );
  }

  Future<ApiResponse<Category>> createCategory({
    required String name,
    List<int> bundleIds = const [],
  }) async {
    var params = {
      "name": name,
      if (bundleIds.isNotEmpty) "bundleIds": bundleIds,
    };

    var response = await sendPostRequest("category/create", params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => Category.fromJson(json),
    );
  }

  Future<ApiResponse<Category>> editCategory({
    required int categoryId,
    required String name,
    List<int> bundleIds = const [],
  }) async {
    var params = {
      "categoryId": categoryId.toString(),
      "name": name,
      if (bundleIds.isNotEmpty) "bundleIds": bundleIds,
    };

    var response = await sendPostRequest("category/edit", params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => Category.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> deleteCategory({
    required int categoryId,
  }) async {
    var params = {
      "categoryId": categoryId.toString(),
    };

    var response = await sendPostRequest("category/delete", params);
    return ApiResponse(
      baseApiResponse: response,
      result: response.meta?.success,
    );
  }
}
