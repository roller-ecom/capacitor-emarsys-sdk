import type { PermissionState } from '@capacitor/core';

export interface PermissionStatus {
  /**
   * @since 1.0.0
   */
  receive: PermissionState;
}

export interface ContactFieldId {
  /**
   * @since 1.0.0
   */
  contactFieldId: number;
}

export interface SetContactOptions extends ContactFieldId {
  /**
   * @since 1.0.0
   */
  contactFieldValue: string;
}

export interface SetAuthenticatedContactOptions extends ContactFieldId {
  /**
   * @since 1.0.0
   */
  openIdToken: string;
}
