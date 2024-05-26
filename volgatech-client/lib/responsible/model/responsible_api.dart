import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/core/model/api/api_response.dart';
import 'package:volgatech_client/core/model/api/api_response_parser.dart';
import 'package:volgatech_client/core/model/api/private_api.dart';
import 'package:volgatech_client/responsible/model/entities/responsible.dart';

class ResponsibleApi extends PrivateApi {
  ResponsibleApi({required super.appModel});

  Future<ApiResponse<List<Responsible>>> loadResponsibleList({
    String searchString = "",
  }) async {
    var params = {
      if (searchString.isNotEmpty) "searchString": searchString,
    };

    var response = await sendGetRequest("responsible/list", params);
    return ApiResponseParser.parseListFromResponse(
      response,
      fromJson: (json) => Responsible.fromJson(json),
    );
  }

  Future<ApiResponse<List<BundleItemInfo>>> loadBundleItemListForResponsible({
    required int responsibleId,
  }) async {
    var params = {
      "responsibleId": responsibleId.toString(),
    };

    var response = await sendGetRequest(
      "bundle-item/list/by-responsible",
      params,
    );
    return ApiResponseParser.parseListFromResponse(
      response,
      fromJson: (json) => BundleItemInfo.fromJson(json),
    );
  }

  Future<ApiResponse<Responsible>> createResponsible({
    required String name,
  }) async {
    var params = {
      "name": name,
    };

    var response = await sendPostRequest("responsible/create", params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => Responsible.fromJson(json),
    );
  }

  Future<ApiResponse<Responsible>> editStorage({
    required int responsibleId,
    required String name,
  }) async {
    var params = {
      "responsibleId": responsibleId.toString(),
      "name": name,
    };

    var response = await sendPostRequest("responsible/edit", params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => Responsible.fromJson(json),
    );
  }
}
