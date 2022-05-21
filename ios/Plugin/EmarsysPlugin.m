#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(EmarsysPlugin, "Emarsys",
           CAP_PLUGIN_METHOD(requestPermissions, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(checkPermissions, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(register, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setContact, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setAuthenticatedContact, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(clearContact, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getPushToken, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(clearPushToken, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(pauseInApp, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(isInAppPaused, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(resumeInApp, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(trackItem, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(trackCategory, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(trackSearch, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(trackTag, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(trackCard, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(trackPurchase, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(recommendProducts, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(trackRecommendationClick, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(fetchMessages, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(addTag, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(removeTag, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getApplicationCode, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setApplicationCode, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getMerchantId, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getContactFieldId, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getHardwareId, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getLanguageCode, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(getSdkVersion, CAPPluginReturnPromise);
)
