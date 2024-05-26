import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/core/model/api/api_response.dart';
import 'package:volgatech_client/core/model/api/api_response_parser.dart';
import 'package:volgatech_client/core/model/api/custom_json_formatters.dart';
import 'package:volgatech_client/core/model/api/private_api.dart';
import 'package:volgatech_client/storage/model/entities/storage.dart';

class StorageApi extends PrivateApi {
  StorageApi({required super.appModel});

  Future<ApiResponse<List<Storage>>> loadStorageList({
    String searchString = "",
    int? parentId,
    bool onlySuperStorage = false,
  }) async {
    var params = {
      if (searchString.isNotEmpty) "searchString": searchString,
      if (parentId != null) "parentId": parentId.toString(),
      "onlySuperStorage":
          const BoolJsonConverter().toJson(onlySuperStorage).toString(),
    };

    var response = await sendGetRequest("storage/list", params);
    return ApiResponseParser.parseListFromResponse(
      response,
      fromJson: (json) => Storage.fromJson(json),
    );
  }

  Future<ApiResponse<List<BundleItemInfo>>> loadBundleItemListForStorage({
    required int storageId,
  }) async {
    var params = {
      "storageId": storageId.toString(),
    };

    var response = await sendGetRequest(
      "bundle-item/list/by-storage",
      params,
    );
    return ApiResponseParser.parseListFromResponse(
      response,
      fromJson: (json) => BundleItemInfo.fromJson(json),
    );
  }

  Future<ApiResponse<Storage>> createStorage({
    required String name,
    int? parentId,
  }) async {
    var params = {
      "name": name,
      if (parentId != null) "parentId": parentId.toString(),
    };

    var response = await sendPostRequest("storage/create", params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => Storage.fromJson(json),
    );
  }

  Future<ApiResponse<Storage>> editStorage({
    required int storageId,
    required String name,
    int? parentId,
  }) async {
    var params = {
      "storageId": storageId.toString(),
      "name": name,
      if (parentId != null) "parentId": parentId.toString(),
    };

    var response = await sendPostRequest("storage/edit", params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => Storage.fromJson(json),
    );
  }
}
