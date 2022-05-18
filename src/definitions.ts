export interface EmarsysPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
