" Vim syntax file
" Langauge: Bazel Build File
" Maintainer: James Durand

if exists("b:current_syntax")
	finish
endif

let b:current_syntax = "bazel"



" Language features
syntax keyword bazelTodo contained TODO FIXME XXX NOTE
syntax match bazelComment '#.*$' contains=bazelTodo
syntax match bazelString '".*"'
syntax keyword load load

highlight default link bazelTodo    Todo
highlight default link bazelComment Comment
highlight default link bazelString  String
highlight default link load         Keyword



" Android build rules
syntax keyword androidBinary android_binary
	\ name
	\ deps
	\ srcs
	\ assets
	\ assets_dir
	\ custom_package
	\ densities
	\ deprecation
	\ dex_shards
	\ dexopts
	\ distribs
	\ exports_manifest
	\ features
	\ inline_constants
	\ javacopts
	\ legacy_native_support
	\ licenses
	\ main_dex_list
	\ main_dex_list_opts
	\ main_dex_proguard_specs
	\ mainifest
	\ multidex
	\ nocompress_extensions
	\ plugins
	\ proguard_generate_mapping
	\ proguard_specs
	\ resource_configuration_filters
	\ resource_files
	\ tags
	\ testonly
	\ visibility

syntax keyword androidLibrary android_library
	\ name
	\ deps
	\ srcs
	\ data
	\ assets
	\ assets_dir
	\ custom_package
	\ deprecation
	\ distribs
	\ exports_manifest
	\ features
	\ idl_import_root
	\ idl_parcelables
	\ idl_srcs
	\ inline_constants
	\ javacopts
	\ licenses
	\ mainifest
	\ neverlink
	\ plugins
	\ proguard_specs
	\ resource_files
	\ tags
	\ testonly
	\ visibility

highlight default link androidBinary  Statement
highlight default link androidLibrary Statement



" C/C++ build rules
syntax keyword ccBinary cc_binary
	\ name
	\ deps
	\ srcs
	\ data
	\ abi
	\ abi_deps
	\ args
	\ copts
	\ defines
	\ deprecation
	\ distribs
	\ features
	\ hdrs_check
	\ includes
	\ licenses
	\ linkopts
	\ linkshared
	\ linkstatic
	\ malloc
	\ nocopts
	\ output_licenses
	\ stamp
	\ tags
	\ testonly
	\ visibility

syntax keyword ccLibrary cc_library
	\ name
	\ deps
	\ srcs
	\ data
	\ hdrs
	\ abi
	\ abi_deps
	\ alwayslink
	\ copts
	\ defines
	\ deprecation
	\ distribs
	\ features
	\ hdrs_check
	\ includes
	\ licenses
	\ linkopts
	\ linkstatic
	\ nocopts
	\ tags
	\ testonly
	\ textual_hdrs
	\ visibility

syntax keyword ccTest cc_test
	\ name
	\ deps
	\ srcs
	\ data
	\ abi
	\ abi_deps
	\ args
	\ copts
	\ defines
	\ deprecation
	\ distribs
	\ features
	\ flaky
	\ hdrs_check
	\ includes
	\ licenses
	\ linkopts
	\ linkstatic
	\ local
	\ malloc
	\ nocopts
	\ shard_count
	\ size
	\ stamp
	\ tags
	\ testonly
	\ timeout
	\ visibility

highlight default link ccBinary  Statement
highlight default link ccLibrary Statement
highlight default link ccTest    Statement



" Java build rules
syntax keyword javaBinary java_binary
	\ name
	\ deps
	\ srcs
	\ data
	\ resources
	\ args
	\ classpath_resources
	\ create_executable
	\ deploy_manifest_lines
	\ deprecation
	\ distribs
	\ features
	\ javacopts
	\ jvm_flags
	\ licenses
	\ main_class
	\ output_licenses
	\ plugins
	\ runtime_deps
	\ stamp
	\ tags
	\ testonly
	\ visibility

syntax keyword javaImport java_import
	\ name
	\ deps
	\ data
	\ constraints
	\ deprecation
	\ distribs
	\ exports
	\ features
	\ jars
	\ licenses
	\ neverlink
	\ runtime_deps
	\ srcjar
	\ tags
	\ testonly
	\ visibility

syntax keyword javaLibrary java_library
	\ name
	\ deps
	\ srcs
	\ data
	\ resources
	\ deprecation
	\ distribs
	\ exported_plugins
	\ exports
	\ features
	\ javacopts
	\ licenses
	\ neverlink
	\ plugins
	\ runtime_deps
	\ tags
	\ testonly
	\ visibility

syntax keyword javaTest java_test
	\ name
	\ deps
	\ srcs
	\ data
	\ resources
	\ args
	\ classpath_resources
	\ create_executable
	\ deploy_manifest_lines
	\ deprecation
	\ distribs
	\ features
	\ flaky
	\ javacopts
	\ jvm_flags
	\ licenses
	\ local
	\ main_class
	\ plugins
	\ runtime_deps
	\ shard_count
	\ size
	\ stamp
	\ tags
	\ testonly
	\ timeout
	\ visibility

syntax keyword javaPlugin java_plugin
	\ name
	\ deps
	\ srcs
	\ data
	\ resources
	\ deprecation
	\ distribs
	\ features
	\ javacopts
	\ licenses
	\ neverlink
	\ plugins
	\ processor_class
	\ tags
	\ testonly
	\ visibility

syntax keyword javaToolchain java_toolchain
	\ name
	\ deprecation
	\ distribs
	\ encoding
	\ features
	\ jvm_opts
	\ licenses
	\ misc
	\ source_version
	\ tags
	\ target_version
	\ testonly
	\ visibility
	\ xlint

highlight default link javaBinary    Statement
highlight default link javaImport    Statement
highlight default link javaLibrary   Statement
highlight default link javaTest      Statement
highlight default link javaPlugin    Statement
highlight default link javaToolchain Statement



" Objective-C build rules
syntax keyword iosApplication ios_application
	\ name
	\ app_icon
	\ binary
	\ bundle_id
	\ deprecation
	\ distribs
	\ entitlements
	\ extensions
	\ families
	\ features
	\ infoplist
	\ launch_image
	\ licenses
	\ provisioning_profile
	\ tags
	\ testonly
	\ visibility

syntax keyword iosDevice ios_device
	\ name
	\ deprecation
	\ distribs
	\ features
	\ ios_version
	\ licenses
	\ tags
	\ testonly
	\ type
	\ visibility

syntax keyword iosExtension ios_extension
	\ name
	\ app_icon
	\ binary
	\ bundle_id
	\ deprecation
	\ distribs
	\ entitlements
	\ families
	\ features
	\ infoplist
	\ launch_image
	\ licenses
	\ provisioning_profile
	\ tags
	\ testonly
	\ visibility

syntax keyword iosExtensionBinary ios_extension_binary
	\ name
	\ deps
	\ srcs
	\ data
	\ resources
	\ hdrs
	\ asset_catalogs
	\ bridging_header
	\ bundles
	\ copts
	\ datamodels
	\ defines
	\ deprecation
	\ distribs
	\ enable_modules
	\ features
	\ includes
	\ licenses
	\ non_arc_srcs
	\ non_propagated_deps
	\ pch
	\ sdk_dylibs
	\ sdk_frameworks
	\ sdk_includes
	\ storyboards
	\ strings
	\ structured_resources
	\ tags
	\ testonly
	\ textual_hdrs
	\ visibility
	\ weak_sdk_frameworks
	\ xibs

syntax keyword iosFramework ios_framework
	\ name
	\ hdrs
	\ app_icon
	\ binary
	\ bundle_id
	\ deprecation
	\ distribs
	\ entitlements
	\ families
	\ features
	\ infoplist
	\ launch_image
	\ licenses
	\ provisioning_profile
	\ tags
	\ testonly
	\ visibility

syntax keyword iosFrameworkBinary ios_framework_binary
	\ name
	\ deps
	\ srcs
	\ data
	\ resources
	\ hdrs
	\ asset_catalogs
	\ bridging_header
	\ bundles
	\ copts
	\ datamodels
	\ defines
	\ deprecation
	\ distribs
	\ enable_modules
	\ features
	\ includes
	\ licenses
	\ non_arc_srcs
	\ non_propagated_deps
	\ pch
	\ sdk_dylibs
	\ sdk_frameworks
	\ sdk_includes
	\ storyboards
	\ strings
	\ structured_resources
	\ tags
	\ testonly
	\ textual_hdrs
	\ visibility
	\ weak_sdk_frameworks
	\ xibs

syntax keyword objcBinary objc_binary
	\ name
	\ deps
	\ srcs
	\ data
	\ resources
	\ hdrs
	\ app_icon
	\ asset_catalogs
	\ bridging_header
	\ bundle_id
	\ bundles
	\ copts
	\ datamodels
	\ defines
	\ deprecation
	\ distribs
	\ enable_modules
	\ entitlements
	\ families
	\ features
	\ includes
	\ infoplist
	\ launch_image
	\ licenses
	\ non_arc_srcs
	\ non_propagated_deps
	\ pch
	\ provisioning_profile
	\ sdk_dylibs
	\ sdk_frameworks
	\ sdk_includes
	\ storyboards
	\ strings
	\ structured_resources
	\ tags
	\ testonly
	\ textual_hdrs
	\ visibility
	\ weak_sdk_frameworks
	\ xibs

syntax keyword j2objcLibrary j2objc_library
	\ name
	\ deps
	\ deprecation
	\ distribs
	\ entry_classes
	\ features
	\ licenses
	\ tags
	\ testonly
	\ visibility

syntax keyword objcBundle objc_bundle
	\ name
	\ bundle_imports
	\ deprecation
	\ distribs
	\ features
	\ licenses
	\ tags
	\ testonly
	\ visibility

syntax keyword objcBundleLibrary objc_bundle_library
	\ name
	\ resources
	\ asset_catalogs
	\ bundles
	\ datamodels
	\ deprecation
	\ distribs
	\ families
	\ features
	\ infoplist
	\ licenses
	\ storyboards
	\ strings
	\ structured_resources
	\ tags
	\ testonly
	\ visibility
	\ xibs

syntax keyword objcFramework objc_framework
	\ name
	\ deprecation
	\ distribs
	\ features
	\ framework_imports
	\ licenses
	\ sdk_dylibs
	\ sdk_frameworks
	\ tags
	\ testonly
	\ visibility
	\ weak_sdk_frameworks

syntax keyword objcImport objc_import
	\ name
	\ resources
	\ hdrs
	\ alwayslink
	\ archives
	\ asset_catalogs
	\ bridging_header
	\ bundles
	\ datamodels
	\ deprecation
	\ distribs
	\ features
	\ includes
	\ licenses
	\ sdk_dylibs
	\ sdk_frameworks
	\ sdk_includes
	\ storyboards
	\ strings
	\ structured_resources
	\ tags
	\ testonly
	\ textual_hdrs
	\ visibility
	\ weak_sdk_frameworks
	\ xibs

syntax keyword objcLibrary objc_library
	\ name
	\ deps
	\ srcs
	\ data
	\ resources
	\ hdrs
	\ alwayslink
	\ asset_catalogs
	\ bridging_header
	\ bundles
	\ copts
	\ datamodels
	\ defines
	\ deprecation
	\ distribs
	\ enable_modules
	\ features
	\ includes
	\ licenses
	\ non_arc_srcs
	\ non_propagated_deps
	\ pch
	\ sdk_dylibs
	\ sdk_frameworks
	\ sdk_includes
	\ storyboards
	\ strings
	\ structured_resources
	\ tags
	\ testonly
	\ textual_hdrs
	\ visibility
	\ weak_sdk_frameworks
	\ xibs

syntax keyword objcProtoLibrary objc_proto_library
	\ name
	\ deps
	\ data
	\ deprecation
	\ distribs
	\ features
	\ licenses
	\ options_file
	\ output_cpp
	\ per_proto_includes
	\ tags
	\ testonly
	\ use_objc_header_names
	\ visibility

syntax keyword experimentalIOSTest experimental_ios_test
	\ name
	\ deps
	\ srcs
	\ data
	\ resources
	\ hdrs
	\ app_icon
	\ args
	\ asset_catalogs
	\ bridging_header
	\ bundle_id
	\ bundles
	\ copts
	\ datamodels
	\ defines
	\ deprecation
	\ distribs
	\ enable_modules
	\ entitlements
	\ families
	\ features
	\ flaky
	\ includes
	\ infoplist
	\ ios_device_arg
	\ ios_test_target_device
	\ launch_image
	\ licenses
	\ local
	\ non_arc_srcs
	\ non_propagated_deps
	\ pch
	\ plugins
	\ provisioning_profile
	\ sdk_dylibs
	\ sdk_frameworks
	\ sdk_includes
	\ shard_count
	\ size
	\ storyboards
	\ strings
	\ structured_resources
	\ tags
	\ target_device
	\ testonly
	\ textual_hdrs
	\ timeout
	\ visibility
	\ weak_sdk_frameworks
	\ xctest
	\ xctest_app
	\ xibs

syntax keyword iosTest ios_test
	\ name
	\ deps
	\ srcs
	\ data
	\ resources
	\ hdrs
	\ app_icon
	\ args
	\ asset_catalogs
	\ bridging_header
	\ bundle_id
	\ bundles
	\ copts
	\ datamodels
	\ defines
	\ deprecation
	\ distribs
	\ enable_modules
	\ entitlements
	\ families
	\ features
	\ flaky
	\ includes
	\ infoplist
	\ ios_device_arg
	\ ios_test_target_device
	\ launch_image
	\ licenses
	\ local
	\ non_arc_srcs
	\ non_propagated_deps
	\ pch
	\ plugins
	\ provisioning_profile
	\ sdk_dylibs
	\ sdk_frameworks
	\ sdk_includes
	\ shard_count
	\ size
	\ storyboards
	\ strings
	\ structured_resources
	\ tags
	\ target_device
	\ testonly
	\ textual_hdrs
	\ timeout
	\ visibility
	\ weak_sdk_frameworks
	\ xctest
	\ xctest_app
	\ xibs

syntax keyword objcXCodeProj objc_xcodeproj
	\ name
	\ deps
	\ deprecation
	\ distribs
	\ features
	\ licenses
	\ tags
	\ testonly
	\ visibility

highlight default link iosApplication      Statement
highlight default link iosDevice           Statement
highlight default link iosExtension        Statement
highlight default link iosExtensionBinary  Statement
highlight default link iosFramework        Statement
highlight default link iosFrameworkBinary  Statement
highlight default link objcBinary          Statement
highlight default link j2objcLibrary       Statement
highlight default link objcBundle          Statement
highlight default link objcBundleLibrary   Statement
highlight default link objcFramework       Statement
highlight default link objcImport          Statement
highlight default link objcLibrary         Statement
highlight default link objcProtoLibrary    Statement
highlight default link experimentalIOSTest Statement
highlight default link iosTest             Statement
highlight default link objcXCodeProj       Statement



" Protocol buffer rules
" None, yet...



" Python build rules
syntax keyword pythonBinary py_binary
	\ name
	\ deps
	\ srcs
	\ data
	\ args
	\ default_python_version
	\ deprecation
	\ distribs
	\ features
	\ licenses
	\ main
	\ output_licenses
	\ srcs_version
	\ stamp
	\ tags
	\ testonly
	\ visibility

syntax keyword pythonLibrary py_library
	\ name
	\ deps
	\ srcs
	\ data
	\ deprecation
	\ distribs
	\ features
	\ licenses
	\ srcs_version
	\ tags
	\ testonly
	\ visibility

syntax keyword pythonTest py_test
	\ name
	\ deps
	\ srcs
	\ data
	\ args
	\ default_python_version
	\ deprecation
	\ distribs
	\ features
	\ flaky
	\ licenses
	\ local
	\ main
	\ shard_count
	\ size
	\ srcs_version
	\ stamp
	\ tags
	\ testonly
	\ timeout
	\ visibility

highlight default link pythonBinary  Statement
highlight default link pythonLibrary Statement
highlight default link pythonTest    Statement



" Shell build rules
syntax keyword shellBinary sh_binary
	\ name
	\ deps
	\ srcs
	\ data
	\ args
	\ deprecation
	\ distribs
	\ features
	\ licenses
	\ output_licenses
	\ tags
	\ testonly
	\ visibility

syntax keyword shellLibrary sh_library
	\ name
	\ deps
	\ srcs
	\ data
	\ deprecation
	\ distribs
	\ features
	\ licenses
	\ tags
	\ testonly
	\ visibility

syntax keyword shellTest sh_test
	\ name
	\ deps
	\ srcs
	\ data
	\ args
	\ deprecation
	\ distribs
	\ features
	\ flaky
	\ licenses
	\ local
	\ shard_count
	\ size
	\ tags
	\ testonly
	\ timeout
	\ visibility

highlight default link shellBinary  Statement
highlight default link shellLibrary Statement
highlight default link shellTest    Statement



" Actions
syntax keyword actionListener action_listener
	\ name
	\ deprecation
	\ distribs
	\ extra_actions
	\ features
	\ licenses
	\ mnemonics
	\ tags
	\ testonly
	\ visibility

syntax keyword extraAction extra_action
	\ name
	\ data
	\ cmd
	\ deprecation
	\ distribs
	\ features
	\ licenses
	\ out_templates
	\ requires_action_output
	\ tags
	\ testonly
	\ tools
	\ visibility

highlight default link actionListener Statement
highlight default link extraAction    Statement



" General rules
syntax keyword fileGroup filegroup
	\ name
	\ srcs
	\ data
	\ deprecation
	\ distribs
	\ features
	\ licenses
	\ output_licenses
	\ path
	\ tags
	\ testonly
	\ visibility

syntax keyword genQuery genquery
	\ name
	\ deps
	\ data
	\ deprecation
	\ distribs
	\ expression
	\ features
	\ licenses
	\ opts
	\ scope
	\ strict
	\ tags
	\ testonly
	\ visibility

syntax keyword testSuite test_suite
	\ name
	\ deprecation
	\ distribs
	\ features
	\ licenses
	\ tags
	\ testonly
	\ tests
	\ visibility

syntax keyword configSetting config_setting
	\ name
	\ deprecation
	\ distribs
	\ features
	\ licenses
	\ tags
	\ testonly
	\ values
	\ visibility

syntax keyword genRule genrule
	\ name
	\ srcs
	\ outs
	\ cmd
	\ deprecation
	\ distribs
	\ executable
	\ features
	\ licenses
	\ local
	\ message
	\ output_to_bindir
	\ tags
	\ testonly
	\ tools
	\ visibility

highlight default link fileGroup     Statement
highlight default link genQuery      Statement
highlight default link testSuite     Statement
highlight default link configSetting Statement
highlight default link genRule       Statement




" Workspace rules
syntax keyword bind bind
	\ name
	\ actual
	\ deprecation
	\ distribs
	\ features
	\ licenses
	\ tags
	\ testonly
	\ visibility

syntax keyword gitRepository git_repository
	\ name
	\ commit
	\ init_submodules
	\ remote
	\ tag

syntax keyword httpArchive http_archive
	\ name
	\ sha256
	\ type
	\ url

syntax keyword httpFile http_file
	\ name
	\ sha256
	\ url

syntax keyword httpJar http_jar
	\ name
	\ sha256
	\ url

syntax keyword localRepository local_repository
	\ name
	\ path

syntax keyword mavenJar maven_jar
	\ name
	\ artifact
	\ repository
	\ server
	\ sha1

syntax keyword mavenServer maven_server
	\ name
	\ settings_file
	\ url

syntax keyword newGitRepository new_git_repository
	\ name
	\ build_file
	\ init_submodules
	\ remote

syntax keyword newHttpArchive new_http_archive
	\ name
	\ build_file
	\ sha256
	\ strip_prefix
	\ type
	\ url

syntax keyword newLocalRepository new_local_repository
	\ name
	\ build_file
	\ path

highlight default link bind               Statement
highlight default link gitRepository      Statement
highlight default link httpArchive        Statement
highlight default link httpFile           Statement
highlight default link httpJar            Statement
highlight default link localRepository    Statement
highlight default link mavenJar           Statement
highlight default link mavenServer        Statement
highlight default link newGitRepository   Statement
highlight default link newHttpArchive     Statement
highlight default link newLocalRepository Statement



" Herebe official Bazel plugins

" Closure build rules
syntax keyword closureJSBinary closer_js_binary
	\ name
	\ main
	\ compilation_level
	\ externs
	\ deps

syntax keyword closureJSLibrary closure_js_library
	\ name
	\ srcs
	\ deps

syntax keyword closureStylesheetLibrary closure_stylesheet_library
	\ name
	\ srcs
	\ deps

syntax keyword closureTemplateLibrary closure_template_library
	\ name
	\ srcs
	\ deps

highlight default link closureJSBinary          Statement
highlight default link closureJSLibrary         Statement
highlight default link closureStylesheetLibrary Statement
highlight default link closureTemplateLibrary   Statement



" Docker build rules
syntax keyword dockerBuild docker_build
	\ name
	\ base
	\ data_path
	\ directory
	\ files
	\ mode
	\ tars
	\ debs
	\ symlinks
	\ entrypoint
	\ cmd
	\ env
	\ ports
	\ volumes
	\ workdir
	\ repository



highlight default link dockerBuild Statement



" Groovy build rules

syntax keyword groovyLibrary groovy_library
	\ name
	\ srcs
	\ deps
	\ data
	\ resources
	\ args
	\ classpath_resources
	\ create_executable
	\ deploy_manifest_lines
	\ deprecation
	\ distribs
	\ features
	\ javacopts
	\ jvm_flags
	\ licenses
	\ main_class
	\ output_licenses
	\ plugins
	\ runtime_deps
	\ stamp
	\ tags
	\ testonly
	\ visibility

syntax keyword groovyAndJavaLibrary groovy_and_java_library
	\ name
	\ srcs
	\ deps
	\ data
	\ resources
	\ args
	\ classpath_resources
	\ create_executable
	\ deploy_manifest_lines
	\ deprecation
	\ distribs
	\ features
	\ javacopts
	\ jvm_flags
	\ licenses
	\ main_class
	\ output_licenses
	\ plugins
	\ runtime_deps
	\ stamp
	\ tags
	\ testonly
	\ visibility

syntax keyword groovyBinary groovy_binary
	\ name
	\ main_class
	\ srcs
	\ deps
	\ data
	\ resources
	\ args
	\ classpath_resources
	\ create_executable
	\ deploy_manifest_lines
	\ deprecation
	\ distribs
	\ features
	\ javacopts
	\ jvm_flags
	\ licenses
	\ main_class
	\ output_licenses
	\ plugins
	\ runtime_deps
	\ stamp
	\ tags
	\ testonly
	\ visibility

syntax keyword groovyTest groovy_test
	\ name
	\ srcs
	\ deps
	\ resources
	\ jvm_flags
	\ size
	\ tags

highlight default link groovyLibrary        Statement
highlight default link groovyAndJavaLibrary Statement
highlight default link groovyBinary         Statement
highlight default link groovyTest           Statement



" Java App Engine build rules
syntax keyword appengineWar appengine_war
	\ name
	\ jars
	\ data
	\ data_path

syntax keyword javaWar java_war
	\ name
	\ data
	\ data_path
	\ resources
	\ deprecation
	\ distribs
	\ exported_plugins
	\ exports
	\ features
	\ javacopts
	\ licenses
	\ neverlink
	\ plugins
	\ runtime_deps
	\ tags
	\ testonly
	\ visibility

highlight default link appengineWar Statement
highlight default link javaWar      Statement



" D build rules
syntax keyword dLibrary d_library
	\ name
	\ srcs
	\ deps
	\ includes
	\ linkopts
	\ versions

syntax keyword dSourceLibrary d_source_library
	\ name
	\ srcs
	\ deps
	\ includes
	\ linkopts
	\ versions

syntax keyword dBinary d_binary
	\ name
	\ srcs
	\ deps
	\ includes
	\ linkopts
	\ versions

syntax keyword dTest d_test
	\ name
	\ srcs
	\ deps
	\ includes
	\ linkopts
	\ versions

syntax keyword dDocs d_docs
	\ name
	\ dep

highlight default link dLibrary       Statement
highlight default link dSourceLibrary Statement
highlight default link dBinary        Statement
highlight default link dTest          Statement
highlight default link dDocs          Statement



" Rust build rules
syntax keyword rustLibrary rust_library
	\ name
	\ srcs
	\ deps
	\ data
	\ crate_features
	\ rustc_flags

syntax keyword rustBinary rust_binary
	\ name
	\ srcs
	\ deps
	\ data
	\ crate_features
	\ rustc_flags

syntax keyword rustTest rust_test
	\ name
	\ srcs
	\ deps
	\ data
	\ crate_features
	\ rustc_flags

syntax keyword rustDocs rust_docs
	\ name
	\ dep
	\ markdown_css
	\ html_in_header
	\ html_before_content
	\ html_after_content

highlight default link rustLibrary Statement
highlight default link rustBinary  Statement
highlight default link rustTest    Statement
highlight default link rustDocs    Statement



" Jsonnet build rules
syntax keyword jsonnetLibrary jsonnet_library
	\ name
	\ srcs
	\ deps
	\ imports

syntax keyword jsonnetToJson jsonnet_to_json
	\ name
	\ src
	\ deps
	\ outs
	\ multiple_outputs
	\ imports

highlight default link jsonnetLibrary Statement
highlight default link jsonnetToJson  Statement



" Scala build rules
syntax keyword scalaLibrary scala_library
	\ name
	\ main_class
	\ srcs
	\ data
	\ scalacopts
	\ jvm_flags
	\ deps

syntax keyword scalaBinary scala_binary
	\ name
	\ main_class
	\ srcs
	\ data
	\ scalacopts
	\ jvm_flags
	\ deps

highlight default link scalaLibrary Statement
highlight default link scalaBinary  Statement

