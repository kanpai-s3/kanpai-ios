ProjectName   = "kanpai-ios"
XcodeProject  = "./#{ProjectName}.xcodeproj"
TargetVersion = "8.0"
FORMATBASE    = "file"

desc "Run Unit Tests"
task :test do
  sh "xcodebuild -destination 'platform=iOS Simulator,name=iPhone 6,OS=latest' -scheme #{ProjectName} -workspace #{ProjectName}.xcworkspace GCC_GENERATE_TEST_COVERAGE_FILES=YES GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES clean test"
end

