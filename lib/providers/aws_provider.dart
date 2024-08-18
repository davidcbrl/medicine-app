import 'dart:convert';

import 'package:aws_client/s3_2006_03_01.dart';

class AwsProvider {
  static const defaultRegion = 'us-east-1';

  Future<void> s3PutObject({
    required String bucket,
    required String key,
    required String base64Object,
  }) async {
    AwsClientCredentials credentials = AwsClientCredentials(
      accessKey: const String.fromEnvironment('AWS_ACCESS_KEY'),
      secretKey: const String.fromEnvironment('AWS_SECRET_KEY')
    );

    S3 s3 = S3(
      region: defaultRegion,
      credentials: credentials,
    );

    await s3.putObject(
      bucket: bucket,
      key: key,
      body: base64Decode(base64Object),
      acl: ObjectCannedACL.publicRead,
    );
  }
}
