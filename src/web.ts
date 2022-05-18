import { WebPlugin } from '@capacitor/core';

import type { EmarsysPlugin } from './definitions';

export class EmarsysWeb extends WebPlugin implements EmarsysPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
