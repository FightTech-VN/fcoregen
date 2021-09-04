const String scriptBuildIOS = '''
flutter build ipa --flavor production --export-options-plist=pathFileExportOption
cd ios/
fastlane ios upload_to_firebase --env production
''';
const contentIOSEnv = '''
APP_ID="firebaseAppId"
TESTER="emailTester"
APP_BUNDLE="bundleId"
ITC_PROVIDER="teamId"
TEAM_ID="teamId"
APPLE_ID="appAppleId"
USERNAME="emailAppleDevelop"
PATH_IPA="pathIPA"
PROVIS_APPSTORE="provisioningAppStore"
PROVIS_DISTRIBUTE="provisioningAdhoc"
CSIDENTITY_DISTRIBUTION="codeSignIdentifyDistribute"
BUILD_CONFIG="buildConfiguration"''';

const contentIOSAppFile = '''
# app_identifier("[[APP_IDENTIFIER]]") # The bundle identifier of your app
# apple_id("[[APPLE_ID]]") # Your Apple email address


# For more information about the Appfile, see:
#     https://docs.fastlane.tools/advanced/#appfile
''';

const contentIOSFastfile = '''
default_platform(:ios)

platform :ios do
  desc "Description of what the lane does"
    # build_app(
    #     scheme: "Runner",
    #     archive_path: "./build/Runner.xcarchive",
    #     export_method: "development",
    #     output_directory: "./build/Runner"
    # )

      lane :upload_to_firebase do
        if (ENV['APP_ID'] && ENV['APP_ID'] != "") && (ENV['TESTER'] && ENV['TESTER'] != "") && ( ENV['NAME_FLAVOR'] && ENV['NAME_FLAVOR'] != "") && (ENV['PATH_IPA'] && ENV['PATH_IPA'] != "")
          # Load config from ENV
          appId=ENV['APP_ID'] 
          tester=ENV['TESTER'] 
          pathIPA=ENV['PATH_IPA']

           # Load data update provisioning info
          provisioningFile=ENV['PROVIS_DISTRIBUTE']
          codeSignIdentity=ENV['CSIDENTITY_DISTRIBUTION']
          buildConfig=ENV['BUILD_CONFIG']

          puts "[Fastlane IOS] Load data from ENV successfully!"

          # Update provisioning
          update_project_provisioning(
            xcodeproj: "Runner.xcodeproj",
            profile: provisioningFile, 
            build_configuration: buildConfig, 
            code_signing_identity: codeSignIdentity,
          )

          # Upload to Firebase Distribution
          puts "[Fastlane IOS] Starting upload to Firebase Distribution..."
          firebase_app_distribution(
              app: appId,
              testers: tester,
              groups: "public_ios",
              release_notes: sh("git log -1 --pretty='%s'"),
              firebase_cli_path: "/usr/local/bin/firebase",
              ipa_path: pathIPA
          )
          puts "[Fastlane IOS] Upload to Distribution completed!"
        else
          raise RuntimeError, '[Fastlane IOS] ENV is not found so Fastlane will stop the process! Please try again!'
        end
      end

    lane :upload_testflight do
      if (ENV['APP_BUNDLE'] && ENV['APP_BUNDLE'] != "") && (ENV['ITC_PROVIDER'] && ENV['ITC_PROVIDER'] != "") && ( ENV['TEAM_ID'] && ENV['TEAM_ID'] != "") && (ENV['APPLE_ID'] && ENV['APPLE_ID'] != "") && (ENV['USERNAME'] && ENV['USERNAME'] != "") && (ENV['PATH_IPA'] && ENV['PATH_IPA'] != "")
        # Load config from ENV
        app_identifier=ENV['APP_BUNDLE'] 
        itc_provider=ENV['ITC_PROVIDER'] 
        team_id=ENV['TEAM_ID'] 
        apple_id=ENV['APPLE_ID'] 
        username=ENV['USERNAME'] 
        pathIPA=ENV['PATH_IPA']
        # Load data update provisioning info
        provisioningFile=ENV['PROVIS_APPSTORE']
        buildConfig=ENV['BUILD_CONFIG']
        codeSignIdentity=ENV['CSIDENTITY_DISTRIBUTION']

        puts "[Fastlane IOS] Load data from ENV successfully!"

        # Update provisioning
        update_project_provisioning(
          xcodeproj: "Runner.xcodeproj",
          profile: provisioningFile, 
          build_configuration: buildConfig, 
          code_signing_identity: codeSignIdentity,
        )

        # Upload to TestFlight
        puts "[Fastlane IOS] Starting upload to testflight..."
        upload_to_testflight(
          username: username,
          app_identifier: app_identifier, 
          itc_provider: itc_provider,
          team_id: team_id,
          apple_id: apple_id,
          skip_waiting_for_build_processing: true,
          skip_submission: true,
          ipa: pathIPA
        )
        puts "[Fastlane IOS] Upload to testflight completed!"
      else
        raise RuntimeError, '[Fastlane IOS] ENV is not found so Fastlane will stop the process! Please try again!'
      end
    end
   
end
''';

const contentIOSPluginfile = '''
# Autogenerated by fastlane
#
# Ensure this file is checked in to source control!

gem 'fastlane-plugin-firebase_app_distribution'
''';

const contentIOSReadme = '''
fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios upload_to_firebase
```
fastlane ios upload_to_firebase
```
Description of what the lane does
### ios upload_testflight
```
fastlane ios upload_testflight
```


----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
''';