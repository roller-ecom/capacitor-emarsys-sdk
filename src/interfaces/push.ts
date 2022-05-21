export interface TokenResult {
  /**
   * @since 1.0.0
   */
  token: string;
}

export interface SilentPushMessageInformation {
  /**
   * @since 1.0.0
   */
  campaignId: string;
}

export interface PushMessageEvent {
  /**
   * @since 1.0.0
   */
  eventName: string;

  /**
   * @since 1.0.0
   */
  data: { key: string; value: string }[];
}
