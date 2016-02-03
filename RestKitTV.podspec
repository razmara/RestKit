Pod::Spec.new do |s|
  s.name             =  'RestKitTV'
  s.version          =  '0.24.1'
  s.summary          =  'RestKit is a framework for consuming and modeling RESTful web resources on iOS and OS X.'
  s.homepage         =  'https://github.com/RestKit/RestKit'
  s.social_media_url =  'https://twitter.com/RestKit'
  s.author           =  { 'Blake Watters' => 'blakewatters@gmail.com' }
  s.source           =  { :git => 'https://github.com/razmara/RestKit.git', :tag => "v#{s.version}, :branch => tvos" }
  s.license          =  'Apache License, Version 2.0'

  # Platform setup
  s.requires_arc = true
  s.ios.deployment_target = '5.1.1'
  s.osx.deployment_target = '10.7'
  s.tvos.deployment_target = '9.1'

  # Exclude optional Search and Testing modules
  s.default_subspec = 'Core'

  # Add Core Data to the PCH if the Core Data subspec is imported. This enables conditional compilation to kick in.
  s.prefix_header_contents = <<-EOS
#if __has_include("RKCoreData.h")
    #import <CoreData/CoreData.h>
#endif
EOS

  # Preserve the layout of headers in the Code directory
  s.header_mappings_dir = 'Code'

  ### Subspecs

  s.subspec 'Core' do |cs|
    cs.dependency 'RestKitTV/ObjectMapping'
    cs.dependency 'RestKitTV/Network'
    cs.dependency 'RestKitTV/CoreData'
  end

  s.subspec 'ObjectMapping' do |os|
    os.source_files   = 'Code/ObjectMapping.h', 'Code/ObjectMapping'
    os.dependency       'RestKitTV/Support'
    os.dependency       'RestKitTV/RKValueTransformers'
    os.dependency       'RestKitTV/ISO8601DateFormatterValueTransformer'
  end

  s.subspec 'Network' do |ns|
    ns.source_files   = 'Code/Network.h', 'Code/Network'
    ns.ios.frameworks = 'CFNetwork', 'Security', 'MobileCoreServices', 'SystemConfiguration'
    ns.osx.frameworks = 'CoreServices', 'Security', 'SystemConfiguration'
    ns.tvos.frameworks = 'CoreServices', 'Security', 'SystemConfiguration'
    ns.dependency       'SOCKit'
    ns.dependency       'RestKitTV/AFNetworking'
    ns.dependency       'RestKitTV/ObjectMapping'
    ns.dependency       'RestKitTV/Support'

    ns.prefix_header_contents = <<-EOS
#import <Availability.h>

#define _AFNETWORKING_PIN_SSL_CERTIFICATES_

#if __IPHONE_OS_VERSION_MIN_REQUIRED
  #import <SystemConfiguration/SystemConfiguration.h>
  #import <MobileCoreServices/MobileCoreServices.h>
  #import <Security/Security.h>
#else
  #import <SystemConfiguration/SystemConfiguration.h>
  #import <CoreServices/CoreServices.h>
  #import <Security/Security.h>
#endif
EOS
  end

  s.subspec 'CoreData' do |cdos|
    cdos.source_files = 'Code/CoreData.h', 'Code/CoreData'
    cdos.frameworks   = 'CoreData'
    cdos.dependency 'RestKitTV/ObjectMapping'
  end

  s.subspec 'Testing' do |ts|
    ts.source_files = 'Code/Testing.h', 'Code/Testing'
    ts.dependency 'RestKitTV/Network'
    ts.prefix_header_contents = <<-EOS
#import <Availability.h>

#define _AFNETWORKING_PIN_SSL_CERTIFICATES_

#if __IPHONE_OS_VERSION_MIN_REQUIRED
  #import <SystemConfiguration/SystemConfiguration.h>
  #import <MobileCoreServices/MobileCoreServices.h>
  #import <Security/Security.h>
#else
  #import <SystemConfiguration/SystemConfiguration.h>
  #import <CoreServices/CoreServices.h>
  #import <Security/Security.h>
#endif
EOS
  end

  s.subspec 'Search' do |ss|
    ss.source_files   = 'Code/Search.h', 'Code/Search'
    ss.dependency 'RestKitTV/CoreData'
  end

  s.subspec 'Support' do |ss|
    ss.source_files   = 'Code/RestKit.h', 'Code/Support.h', 'Code/Support'
    ss.preserve_paths = 'Vendor/LibComponentLogging/Core' # Preserved because they are symlinked
    ss.dependency 'RestKitTV/TransitionKit'
  end

  s.subspec 'TransitionKit' do |tk|
    tk.source_files   = 'Code/RestKit.h', 'Code/TransitionKit.h', 'Code/TransitionKit'
    #ss.dependency 'RestKitTV/TransitionKit'
  end

  s.subspec 'RKValueTransformers' do |tk|
    tk.source_files   = 'Code/RestKit.h', 'RestKitTV/Code/RKValueTransformers.h', 'RestKitTV/Code/RKValueTransformers'
    #ss.dependency 'RestKitTV/TransitionKit'
  end 
  
  s.subspec 'ISO8601DateFormatterValueTransformer' do |tk|
    tk.source_files   = 'Code/RestKit.h', 'RestKitTV/ISO8601DateFormatterValueTransformer/Code/ISO8601DateFormatterValueTransformer.h', 'RestKitTV/ISO8601DateFormatterValueTransformer/Code'
  end 

  s.subspec 'AFNetworking' do |tk|
    tk.source_files   = 'Code/RestKit.h', 'RestKitTV/AFNetworking/AFNetworking.h', 'RestKitTV/AFNetworking/AFNetworking'
  end

  s.subspec 'CocoaLumberjack' do |cl|
    cl.source_files = 'Code/CocoaLumberjack/RKLumberjackLogger.*'
    cl.dependency 'CocoaLumberjack'
    cl.dependency 'RestKitTV/Support'
  end
end
