import 'package:volgatech_client/bundles/model/entities/bundle_item_info.dart';
import 'package:volgatech_client/core/model/api/api_response.dart';
import 'package:volgatech_client/core/model/api/api_response_parser.dart';
import 'package:volgatech_client/core/model/api/private_api.dart';
import 'package:volgatech_client/projects/model/entities/project.dart';

class ProjectApi extends PrivateApi {
  ProjectApi({required super.appModel});

  Future<ApiResponse<List<Project>>> loadProjectList() async {
    var response = await sendGetRequest("project/list", {});
    return ApiResponseParser.parseListFromResponse(
      response,
      fromJson: (json) => Project.fromJson(json),
    );
  }

  Future<ApiResponse<Project>> loadProjectDetail({
    required int projectId,
  }) async {
    var params = {
      "projectId": projectId.toString(),
    };

    var response = await sendGetRequest("project/details", params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => Project.fromJson(json),
    );
  }

  Future<ApiResponse<Project>> createProject({
    required String name,
    String? description,
    String? author,
    String? responsible,
    Map<BundleItemInfo, int> bundleItems = const {},
  }) async {
    var params = {
      "name": name,
      if (description?.isNotEmpty ?? false) "description": description,
      if (author?.isNotEmpty ?? false) "author": author,
      if (responsible?.isNotEmpty ?? false) "responsible": responsible,
      if (bundleItems.isNotEmpty)
        "bundleItems": bundleItems.map(
          (key, value) => MapEntry(
            key.bundleItemInfoId.toString(),
            value.toString(),
          ),
        ),
    };
    var response = await sendPostRequest("project/create", params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => Project.fromJson(json),
    );
  }

  Future<ApiResponse<Project>> editProject({
    required int projectId,
    required String name,
    String? description,
    String? responsible,
    Map<BundleItemInfo, int> bundleItems = const {},
  }) async {
    var params = {
      "projectId": projectId.toString(),
      "name": name,
      if (description?.isNotEmpty ?? false) "description": description,
      if (responsible?.isNotEmpty ?? false) "responsible": responsible,
      if (bundleItems.isNotEmpty)
        "bundleItems": bundleItems.map(
          (key, value) => MapEntry(
            key.bundleItemInfoId.toString(),
            value.toString(),
          ),
        ),
    };

    var response = await sendPostRequest("project/edit", params);
    return ApiResponseParser.parseObjectFromResponse(
      response,
      fromJson: (json) => Project.fromJson(json),
    );
  }

  Future<ApiResponse<bool>> deleteProject({
    required int projectId,
  }) async {
    var params = {
      "projectId": projectId.toString(),
    };
    var response = await sendPostRequest("project/delete", params);
    return ApiResponse(
      baseApiResponse: response,
      result: response.meta?.success ?? false,
    );
  }
}
