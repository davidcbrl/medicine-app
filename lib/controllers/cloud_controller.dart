import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:medicine/providers/aws_provider.dart';

enum AssetType { image, other }

class CloudController extends GetxController with StateMixin {
  var loading = false.obs;

  Map<AssetType, String> assetsRepositories = {
    AssetType.image: 'images/',
    AssetType.other: 'other/',
  };

  Future<String?> uploadAsset({
    required AssetType type,
    required String name,
    required String base64Asset,
  }) async {
    loading.value = true;
    change([], status: RxStatus.loading());
    try {
      String? repository = assetsRepositories[type];
      String objectKey = '$repository$name';
      await AwsProvider().s3PutObject(
        bucket: 'medicine-assets',
        key: objectKey,
        base64Object: base64Asset,
      );
      change([], status: RxStatus.success());
      loading.value = false;
      return 'https://d3s9fbrafjici.cloudfront.net/$objectKey';
    } catch (error) {
      if (kDebugMode) print(error);
      change([], status: RxStatus.error('Falha realizar upload: $error'));
      loading.value = false;
      return null;
    }
  }
}
