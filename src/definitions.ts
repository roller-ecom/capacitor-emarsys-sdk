/// <reference types="@capacitor/cli" />

import type { PluginListenerHandle } from '@capacitor/core';

import type {
  ContactFieldId,
  PermissionStatus,
  SetAuthenticatedContactOptions,
  SetContactOptions,
} from './interfaces/base';
import type { ApplicationCode, MerchantId } from './interfaces/config';
import type { InboxTag } from './interfaces/inbox';
import type {
  CardItems,
  CustomEvent,
  Product,
  Purchase,
  RecommendedProductOptions,
  RecommendedProducts,
} from './interfaces/predict';
import type { PushMessageEvent, SilentPushMessageInformation, TokenResult } from './interfaces/push';

type ConsoleLogLevels = 'trace' | 'debug' | 'info' | 'warn' | 'error' | 'basic';

declare module '@capacitor/cli' {
  export interface PluginsConfig {
    /**
     * The following options are available to initialize the SDK:
     */
    Emarsys?: {
      /**
       * Emarsys App code, which is generated when the app is added to the account.
       *
       * @since 1.0.0
       * @example 'yourApplicationCode'
       */
      mobileEngageApplicationCode?: string;

      /**
       * Emarsys Predict Merchant ID (If the Predict feature is enabled on the Emarsys account).
       *
       * @since 1.0.0
       * @example 'yourMerchantId'
       */
      merchantId?: string;

      /**
       * The default console logging is only showing logs when you call an unallowed method.
       * You are able to modify the allowed loglevels for console logging, by setting it during the setup.
       *
       * @since 1.0.0
       * @example ['info', 'debug', '...']
       */
      consoleLogLevels?: ConsoleLogLevels[];
    };
  }
}

export interface EmarsysPlugin {
  /**
   * Check permission to receive push notifications.
   *
   * @example Test
   * @since 1.0.0
   */
  checkPermissions(): Promise<PermissionStatus>;

  /**
   * Request permission to receive push notifications.
   *
   * @since 1.0.0
   */
  requestPermissions(): Promise<PermissionStatus>;

  /**
   * Register the app to receive push notifications.
   *
   * This method will resolve with the push token or reject if there was a problem. It does not prompt the user for notification permissions, use `requestPermissions()` first.
   *
   * @since 1.0.0
   */
  register(): Promise<TokenResult>;

  /**
   * After application setup is finished, you can use this method to identify the user with `contactFieldValue`.
   *
   * Without contact identification all tracked events will be linked to an anonymous contact in Mobile Engage and will rely on visitor cookies in case of Predict.
   *
   * @since 1.0.0
   */
  setContact(options: SetContactOptions): Promise<void>;

  /**
   * After the application setup is finished, you can use this method to identify the user with an `openIdToken`.
   *
   * Without contact identification all tracked events will be linked to an anonymous contact in Mobile Engage and will rely on visitor cookies in case of Predict.
   *
   * @since 1.0.0
   */
  setAuthenticatedContact(options: SetAuthenticatedContactOptions): Promise<void>;

  /**
   * When the user signs out, this method should be used.
   *
   * You only need to call `clearContact` when you explicitly want to sign out the contact from Emarsys even if the user isn’t logged in into your application.
   *
   * @since 1.0.0
   */
  clearContact(): Promise<void>;

  /**
   * Use this method to get the current push token.
   *
   * @since 1.0.0
   */
  getPushToken(): Promise<TokenResult>;

  /**
   * Use this method to remove the push token of the contact.
   *
   * @since 1.0.0
   */
  clearPushToken(): Promise<void>;

  // In-App

  /**
   * When a critical activity starts and should not be interrupted by In-App, pause In-App messages.
   *
   * @since 1.0.0
   */
  pauseInApp(): Promise<void>;

  /**
   * Use this method to check if in app messages are paused.
   *
   * @since 1.0.0
   */
  isInAppPaused(): Promise<{ isPaused: boolean }>;

  /**
   * In order to show In-App messages after being paused, use the resume method.
   *
   * @since 1.0.0
   */
  resumeInApp(): Promise<void>;

  // Predict

  /**
   * If an item was viewed use the `trackItemView` method with an itemId.
   *
   * @since 1.0.0
   */
  trackItem(options: { itemId: string }): Promise<void>;

  /**
   * When the user navigates between the categories you should call `trackCategoryView` in every navigation. Be aware to send `categoryPath` in the required format. Please visit [Predict's documentation](https://dev.emarsys.com/v2/web-extend-command-reference) for more information.
   *
   * @since 1.0.0
   */
  trackCategory(options: { categoryPath: string }): Promise<void>;

  /**
   * To report search terms entered by the contact use `trackSearchTerm` method.
   *
   * @since 1.0.0
   */
  trackSearch(options: { searchTerm: string }): Promise<void>;

  /**
   * To report search terms entered by the contact use `trackSearchTerm` method.
   *
   * @since 1.0.0
   */
  trackTag(options: { tag: string }): Promise<void>;

  /**
   * When you want to track the cart items in the basket you can call this method with a list of CartItems.
   *
   * @since 1.0.0
   */
  trackCard(options: CardItems): Promise<void>;

  /**
   * To report a purchase event you should call this method with the items purchased and with an `orderId`.
   *
   * @since 1.0.0
   */
  trackPurchase(options: Purchase): Promise<void>;

  // Custom Events

  trackCustomEvent(event: CustomEvent): Promise<void>;

  // recommended Products

  /**
   * With the Emarsys SDK you can ask for product recommendations based on different recommendation logics.
   *
   * This method is also going to track the value attached to the logic on the backend, so no additional tracking needed when using recommendations!
   *
   * @since 1.0.0
   */
  recommendProducts(options: RecommendedProductOptions): Promise<RecommendedProducts>;

  /**
   * The Emarsys SDK doesn't track automatically recommendationClicks, so you have to call manually `trackRecommendationClick` when an interaction happens with any of the recommended `products`.
   *
   * @since 1.0.0
   */
  trackRecommendationClick(product: Product): Promise<void>;

  // Inbox

  /**
   * In order to receive the messageInbox content, you can use this method.
   *
   * @since 1.0.0
   */
  fetchMessages(): Promise<any>;

  /**
   * To label a message with a tag, you can use this method. (for example: "READ", "SEEN" etc)
   *
   * @since 1.0.0
   */
  addTag(options: InboxTag): Promise<void>;

  /**
   * To remove a label from a message, you can use this method.
   *
   * @since 1.0.0
   */
  removeTag(options: InboxTag): Promise<void>;

  // Config

  /**
   * Provides what is the actual `applicationCode` set in the SDK.
   *
   * @since 1.0.0
   */
  getApplicationCode(): Promise<ApplicationCode>;

  /**
   * If any error occurs during the change process, the Mobile Engage feature will be turned off.
   *
   * @since 1.0.0
   */
  setApplicationCode(options: ApplicationCode): Promise<void>;

  /**
   * Provides what is the actual `merchantId` set in the SDK.
   *
   * @since 1.0.0
   */
  getMerchantId(): Promise<MerchantId>;

  /**
   * Change the actual `merchantId` that is set in the SDK.
   *
   * @since 1.0.0
   */
  setMerchantId(options: MerchantId): Promise<void>;

  /**
   * Provides what is the actual `contactFieldId` set in the SDK.
   *
   * @since 1.0.0
   */
  getContactFieldId(): Promise<ContactFieldId>;

  /**
   * Provides what is the actual `hardwareId` set in the SDK.
   *
   * @since 1.0.0
   */
  getHardwareId(): Promise<{ hardwareId: string }>;

  /**
   * Provides what is the actual language of the application.
   *
   * @since 1.0.0
   */
  getLanguageCode(): Promise<{ languageCode: string }>;

  /**
   * Provides the actual `sdkVersion`
   *
   * @since 1.0.0
   */
  getSdkVersion(): Promise<{ sdkVersion: string }>;

  // Listeners

  /**
   * Called when a event is received
   *
   * @since 1.0.0
   */
  addListener(
    eventName: 'pushMessageEvent',
    listenerFunc: (event: PushMessageEvent) => void
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Called when a silent push message is received
   *
   * @since 1.0.0
   */
  addListener(
    eventName: 'silentPushMessageInformation',
    listenerFunc: (information: SilentPushMessageInformation) => void
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Remove all native listeners for this plugin.
   *
   * @since 1.0.0
   */
  removeAllListeners(): Promise<void>;
}
