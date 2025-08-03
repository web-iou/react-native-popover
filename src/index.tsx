import { findNodeHandle } from 'react-native';
import Popover, { type PopOverMenuConfiguration } from './NativePopover';
import { useCallback, useRef, useState } from 'react';

export { Popover };

export const useNativePopover = (initialIndex: number | null = null) => {
  const anchorRef = useRef(null);
  const [selectedIndex, setSelectedIndex] = useState<number | null>(
    initialIndex
  );
  /**
   * 显示 Popover 菜单
   * @param menuItems 菜单选项
   * @param icons 图标选项
   * @param config 菜单配置
   * @returns Promise<number> 选中的索引
   */
  const showPopover = useCallback(
    async (
      menuItems: string[],
      config?: PopOverMenuConfiguration
    ): Promise<number | null> => {
      if (!anchorRef.current) {
        console.warn('useNativePopover: anchorRef is not attached to a View.');
        return null;
      }
      const anchorViewId = findNodeHandle(anchorRef.current);
      if (!anchorViewId) {
        console.warn(
          'useNativePopover: Cannot find node handle for anchorRef.'
        );
        return null;
      }
      try {
        const index = await Popover.show(
          anchorViewId,
          menuItems,
          selectedIndex,
          config
        );
        (initialIndex || initialIndex === 0) && setSelectedIndex(index);
        return index;
      } catch (error) {
        console.error('Error showing popover:', error);
        return null;
      }
    },
    [selectedIndex]
  );

  return [showPopover, anchorRef, selectedIndex, setSelectedIndex] as const;
};
