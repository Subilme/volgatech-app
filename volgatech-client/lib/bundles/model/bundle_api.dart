import 'package:volgatech_client/bundles/model/entities/functional_type.dart';
import 'package:volgatech_client/bundles/model/entities/bundle.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_info.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item.dart';
import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/core/model/api/api_response.dart';
import 'package:volgatech_client/core/model/api/api_response_parser.dart';
import 'package:volgatech_client/core/model/api/custom_json_formatters.dart';
import 'package:volgatech_client/core/model/api/private_api.dart';

class BundleApi extends PrivateApi {
  BundleApi({required super.appModel});

  Future<ApiResponse<List<BundleInfo>>> loadBundleList({
    String searchString = "",
    bool groupItems = false,
  }) async {
    var params = {
      if (searchString.isNotEmpty) "searchString": searchString,
      "groupItems": const BoolJsonConverter().toJson(groupItems).toString(),
    };

    var response = await sendGetRequest('bundle/list', params);
    return ApiResponseParser.parseListFromResponse(
      response,
      fromJson: (json) => BundleInfo.fromJson(json),
    );
  }

  Future<ApiResponse<BundleInfo>> loadBundleDetails({
    required int itemId,
  }) async {
    var params = {
      'bundleId': itemId.toString(),
    };

    var response = await sendGetRequest('bundle/details', params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => BundleInfo.fromJson(json),
    );
  }

  Future<ApiResponse<List<Bundle>>> loadBundleInstanceList({
    int? bundleInfoId,
  }) async {
    var params = {
      if (bundleInfoId != null) "bundleInfoId": bundleInfoId.toString(),
    };

    var response = await sendGetRequest('bundle/instance/list', params);
    return ApiResponseParser.parseListFromResponse(
      response,
      fromJson: (json) => Bundle.fromJson(json),
    );
  }

  Future<ApiResponse<List<BundleItemInfo>>> loadBundleItemList({
    String searchString = "",
  }) async {
    var params = {
      if (searchString.isNotEmpty) "searchString": searchString,
    };

    var response = await sendGetRequest('bundle-item/list', params);
    return ApiResponseParser.parseListFromResponse(
      response,
      fromJson: (json) => BundleItemInfo.fromJson(json),
    );
  }

  Future<ApiResponse<BundleItemInfo>> loadBundleItemDetails({
    required int bundleItemInfoId,
  }) async {
    var params = {
      'bundleItemInfoId': bundleItemInfoId.toString(),
    };

    var response = await sendGetRequest('bundle-item/details', params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => BundleItemInfo.fromJson(json),
    );
  }

  Future<ApiResponse<BundleInfo>> createBundle({
    int? categoryId,
    required String name,
    String? description,
    int count = 0,
    Map<BundleItemInfo, int> bundleItems = const {},
  }) async {
    var params = {
      if (categoryId != null) "categoryId": categoryId.toString(),
      "name": name,
      "count": count.toString(),
      if (description?.isNotEmpty ?? false) "description": description,
      if (bundleItems.isNotEmpty)
        "bundleItems": bundleItems.map(
          (key, value) => MapEntry(
            key.bundleItemInfoId.toString(),
            value.toString(),
          ),
        ),
    };

    var response = await sendPostRequest("bundle/create", params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => BundleInfo.fromJson(json),
    );
  }

  Future<ApiResponse<BundleInfo>> editBundle({
    required int bundleId,
    int? categoryId,
    required String name,
    String? description,
    int count = 0,
    Map<BundleItemInfo, int> bundleItems = const {},
  }) async {
    var params = {
      "bundleId": bundleId.toString(),
      if (categoryId != null) "categoryId": categoryId.toString(),
      "name": name,
      "count": count.toString(),
      if (description?.isNotEmpty ?? false) "description": description,
      if (bundleItems.isNotEmpty)
        "bundleItems": bundleItems.map(
          (key, value) => MapEntry(
            key.bundleItemInfoId.toString(),
            value.toString(),
          ),
        ),
    };

    var response = await sendPostRequest("bundle/edit", params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => BundleInfo.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> changeBundleStorage({
    required int bundleId,
    required int storageId,
  }) async {
    var params = {
      "bundleId": bundleId.toString(),
      "storageId": storageId.toString(),
    };

    var response = await sendPostRequest(
      "bundle/change-storage",
      params,
    );
    return ApiResponse<bool>(
      baseApiResponse: response,
      result: response.meta?.success ?? false,
    );
  }

  Future<ApiResponse<bool>> deleteBundle({
    required int bundleId,
  }) async {
    var params = {
      "bundleId": bundleId.toString(),
    };

    var response = await sendPostRequest("bundle/delete", params);
    return ApiResponse<bool>(
      baseApiResponse: response,
      result: response.meta?.success ?? false,
    );
  }

  Future<ApiResponse<BundleItemInfo>> createBundleItem({
    int? categoryId,
    required String name,
    int count = 0,
  }) async {
    var params = {
      if (categoryId != null) "categoryId": categoryId.toString(),
      "name": name,
      "count": count.toString(),
    };

    var response = await sendPostRequest("bundle-item/create", params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => BundleItemInfo.fromJson(json),
    );
  }

  Future<ApiResponse<BundleItemInfo>> editBundleItem({
    required int bundleItemId,
    required String name,
    int count = 0,
  }) async {
    var params = {
      "bundleItemId": bundleItemId.toString(),
      "name": name,
      "count": count.toString(),
    };

    var response = await sendPostRequest("bundle-item/edit", params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => BundleItemInfo.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> deleteBundleItem({
    required int bundleItemId,
  }) async {
    var params = {
      "bundleItemId": bundleItemId.toString(),
    };

    var response = await sendPostRequest("bundle-item/delete", params);
    return ApiResponse<bool>(
      baseApiResponse: response,
      result: response.meta?.success ?? false,
    );
  }

  Future<ApiResponse<List<BundleItem>>> loadBundleItemInstanceList({
    int? bundleItemInfoId,
  }) async {
    var params = {
      if (bundleItemInfoId != null)
        "bundleItemInfoId": bundleItemInfoId.toString(),
    };

    var response = await sendGetRequest('bundle-item/instance/list', params);
    return ApiResponseParser.parseListFromResponse(
      response,
      fromJson: (json) => BundleItem.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> changeBundleItemFunctional({
    required int bundleItemId,
    required FunctionalType type,
  }) async {
    var params = {
      "bundleItemId": bundleItemId.toString(),
      "type": type.value.toString(),
    };

    var response = await sendPostRequest(
      "bundle-item/change-functional",
      params,
    );
    return ApiResponse<bool>(
      baseApiResponse: response,
      result: response.meta?.success ?? false,
    );
  }

  Future<ApiResponse<bool>> changeBundleItemStorage({
    required int bundleItemId,
    required int storageId,
  }) async {
    var params = {
      "bundleItemId": bundleItemId.toString(),
      "storageId": storageId.toString(),
    };

    var response = await sendPostRequest(
      "bundle-item/change-storage",
      params,
    );
    return ApiResponse<bool>(
      baseApiResponse: response,
      result: response.meta?.success ?? false,
    );
  }

  Future<ApiResponse<BundleItem>> changeBundleItemProject({
    required int bundleItemId,
    required int projectId,
  }) async {
    var params = {
      "bundleItemId": bundleItemId.toString(),
      "projectId": projectId.toString(),
    };

    var response = await sendPostRequest(
      "bundle-item/change-project",
      params,
    );
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => BundleItem.fromJson(json),
    );
  }
}
