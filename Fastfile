# More documentation about how to customize your build
# can be found here:
# https://docs.fastlane.tools
fastlane_version "1.109.0"

# This value helps us track success metrics for Fastfiles
# we automatically generate. Feel free to remove this line
# once you get things running smoothly!
generated_fastfile_id "08ca126f-7c20-470a-87f9-c704065d01fd"

default_platform :ios

# Fastfile actions accept additional configuration, but
# don't worry, fastlane will prompt you for required
# info which you can add here later
lane :beta do
  # build your iOS app
  gym(
    # scheme: "YourScheme",
    export_method: "app-store"
  )

  # upload to Testflight
  pilot(skip_waiting_for_build_processing: true)
end
