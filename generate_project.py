#!/usr/bin/env python3
import os

def main():
    project_dir = os.path.dirname(os.path.abspath(__file__))
    xcodeproj_dir = os.path.join(project_dir, "ReceiptScanner.xcodeproj")
    os.makedirs(xcodeproj_dir, exist_ok=True)
    
    pbxproj_path = os.path.join(xcodeproj_dir, "project.pbxproj")
    
    # Complete, valid project.pbxproj configuration for a SwiftUI app
    pbxproj_content = """// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 54;
	objects = {

/* Begin PBXBuildFile section */
		B11000000000000000000001 /* ReceiptScannerApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = F11000000000000000000001 /* ReceiptScannerApp.swift */; };
		B11000000000000000000002 /* ContentView.swift in Sources */ = {isa = PBXBuildFile; fileRef = F11000000000000000000002 /* ContentView.swift */; };
		B11000000000000000000003 /* ReceiptModel.swift in Sources */ = {isa = PBXBuildFile; fileRef = F11000000000000000000003 /* ReceiptModel.swift */; };
		B11000000000000000000004 /* ReceiptParser.swift in Sources */ = {isa = PBXBuildFile; fileRef = F11000000000000000000004 /* ReceiptParser.swift */; };
		B11000000000000000000005 /* ScannerView.swift in Sources */ = {isa = PBXBuildFile; fileRef = F11000000000000000000005 /* ScannerView.swift */; };
		B11000000000000000000006 /* ResultEditView.swift in Sources */ = {isa = PBXBuildFile; fileRef = F11000000000000000000006 /* ResultEditView.swift */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		F11000000000000000000001 /* ReceiptScannerApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ReceiptScannerApp.swift; sourceTree = "<group>"; };
		F11000000000000000000002 /* ContentView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ContentView.swift; sourceTree = "<group>"; };
		F11000000000000000000003 /* ReceiptModel.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ReceiptModel.swift; sourceTree = "<group>"; };
		F11000000000000000000004 /* ReceiptParser.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ReceiptParser.swift; sourceTree = "<group>"; };
		F11000000000000000000005 /* ScannerView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ScannerView.swift; sourceTree = "<group>"; };
		F11000000000000000000006 /* ResultEditView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ResultEditView.swift; sourceTree = "<group>"; };
		F110000000000000000000FF /* ReceiptScanner.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = ReceiptScanner.app; sourceTree = BUILT_PRODUCTS_DIR; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		A1B2C3D4E5F6000000000009 /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		A1B2C3D4E5F6000000000002 = {
			isa = PBXGroup;
			children = (
				A1B2C3D4E5F6000000000003 /* Source Files */,
				F110000000000000000000FF /* ReceiptScanner.app */,
			);
			sourceTree = "<group>";
		};
		A1B2C3D4E5F6000000000003 /* Source Files */ = {
			isa = PBXGroup;
			children = (
				F11000000000000000000001 /* ReceiptScannerApp.swift */,
				F11000000000000000000002 /* ContentView.swift */,
				F11000000000000000000003 /* ReceiptModel.swift */,
				F11000000000000000000004 /* ReceiptParser.swift */,
				F11000000000000000000005 /* ScannerView.swift */,
				F11000000000000000000006 /* ResultEditView.swift */,
			);
			name = "Source Files";
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		A1B2C3D4E5F6000000000004 /* ReceiptScanner */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = A1B2C3D4E5F6000000000005 /* Build configuration list for PBXNativeTarget "ReceiptScanner" */;
			buildPhases = (
				A1B2C3D4E5F6000000000007 /* Sources */,
				A1B2C3D4E5F6000000000009 /* Frameworks */,
				A1B2C3D4E5F6000000000008 /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = ReceiptScanner;
			productName = ReceiptScanner;
			productReference = F110000000000000000000FF /* ReceiptScanner.app */;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		A1B2C3D4E5F6000000000001 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = YES;
				LastSwiftUpdateCheck = 1400;
				LastUpgradeCheck = 1400;
				TargetAttributes = {
					A1B2C3D4E5F6000000000004 = {
						CreatedOnToolsVersion = 14.0;
						LastSwiftMigration = 1400;
					};
				};
			};
			buildConfigurationList = A1B2C3D4E5F6000000000006 /* Build configuration list for PBXProject "ReceiptScanner" */;
			compatibilityVersion = "Xcode 13.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = A1B2C3D4E5F6000000000002;
			productRefGroup = A1B2C3D4E5F6000000000002;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				A1B2C3D4E5F6000000000004 /* ReceiptScanner */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		A1B2C3D4E5F6000000000008 /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		A1B2C3D4E5F6000000000007 /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				B11000000000000000000001 /* ReceiptScannerApp.swift in Sources */,
				B11000000000000000000002 /* ContentView.swift in Sources */,
				B11000000000000000000003 /* ReceiptModel.swift in Sources */,
				B11000000000000000000004 /* ReceiptParser.swift in Sources */,
				B11000000000000000000005 /* ScannerView.swift in Sources */,
				B11000000000000000000006 /* ResultEditView.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		A1B2C3D4E5F600000000000A /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_CXX_LIBRARY = "libc++";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_REWRITE_RECEIVER = YES;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUICKLOOK_OBJC_REPLACE_METHOD = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				GCC_C_LANGUAGE_STANDARD = gnu11;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = iphoneos;
			};
			name = Debug;
		};
		A1B2C3D4E5F600000000000B /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_CXX_LIBRARY = "libc++";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_REWRITE_RECEIVER = YES;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUICKLOOK_OBJC_REPLACE_METHOD = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				GCC_C_LANGUAGE_STANDARD = gnu11;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				IPHONEOS_DEPLOYMENT_TARGET = 16.0;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = iphoneos;
				VALIDATE_PRODUCT = YES;
			};
			name = Release;
		};
		A1B2C3D4E5F600000000000C /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_NSCameraUsageDescription = "Fişleri tarayabilmek için kameranıza erişmemiz gerekiyor.";
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.yavuz.ReceiptScanner;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Debug;
		};
		A1B2C3D4E5F600000000000D /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_STYLE = Automatic;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_NSCameraUsageDescription = "Fişleri tarayabilmek için kameranıza erişmemiz gerekiyor.";
				INFOPLIST_KEY_UILaunchScreen_Generation = YES;
				INFOPLIST_KEY_UISupportedInterfaceOrientations = "UIInterfaceOrientationPortrait";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/Frameworks",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.yavuz.ReceiptScanner;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
				TARGETED_DEVICE_FAMILY = "1,2";
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		A1B2C3D4E5F6000000000005 /* Build configuration list for PBXNativeTarget "ReceiptScanner" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				A1B2C3D4E5F600000000000C /* Debug */,
				A1B2C3D4E5F600000000000D /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		A1B2C3D4E5F6000000000006 /* Build configuration list for PBXProject "ReceiptScanner" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				A1B2C3D4E5F600000000000A /* Debug */,
				A1B2C3D4E5F600000000000B /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = A1B2C3D4E5F6000000000001 /* Project object */;
}
"""
    
    with open(pbxproj_path, "w", encoding="utf-8") as f:
        f.write(pbxproj_content)
        
    print("Xcode project generated successfully at: ReceiptScanner.xcodeproj")

if __name__ == "__main__":
    main()
