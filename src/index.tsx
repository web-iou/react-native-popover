import Popover, { type PopOverMenuConfiguration } from './NativePopover';

export function showPopover(options: {
  anchorViewId: number;
  menuItems: string[];
  index: number;
  config: PopOverMenuConfiguration;
}): Promise<number> {
  return Popover.show(
    options.anchorViewId,
    options.menuItems,
    options.index,
    options.config
  );
}
