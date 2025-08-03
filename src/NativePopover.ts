import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';
import type { Int32 } from 'react-native/Libraries/Types/CodegenTypes';

/**
 * PopOver菜单配置接口
 */
export interface PopOverMenuConfiguration {
  /** 菜单宽度 */
  menuWidth: Int32;

  /** 菜单圆角半径 */
  menuCornerRadius?: Int32;

  /** 文本颜色 */
  textColor?: string;

  /** 背景颜色 */
  backgroundColor?: string;

  /** 边框颜色 */
  borderColor?: string;

  /** 边框宽度 */
  borderWidth?: Int32;

  /** 内边距 */
  padding?: {
    top?: Int32;
    left?: Int32;
    bottom?: Int32;
    right?: Int32;
  };
  rowHeight?: Int32;
  /** 文本字体 */
  textFont?: {
    fontSize?: Int32;
    fontWeight?: Int32;
  };
  checkIconSize?: Int32;
  /** 文本对齐方式 */
  textAlignment?: 'left' | 'center' | 'right';
  /**
   * @platform ios
   * 动画持续时间（秒） */
  animationDuration?: number;

  /** 选中项的文本颜色 */
  selectedTextColor?: string;

  /** 分隔线颜色 */
  separatorColor?: string;

  /**
   * @platform ios
   * 阴影颜色
   */
  shadowColor?: string;

  /**
   * @platform ios
   * 阴影不透明度
   */
  shadowOpacity?: number;

  /**
   * @platform ios
   * 阴影半径
   */
  shadowRadius?: number;

  /**
   * @platform ios
   * 阴影X轴偏移量
   */
  shadowOffsetX?: number;

  /**
   * @platform ios
   * 阴影Y轴偏移量
   */
  shadowOffsetY?: number;
}

export interface Spec extends TurboModule {
  /**
   * 显示 PopOverMenu，并返回选中的索引
   * @param anchorViewId 目标视图的原生 ID
   * @param menuItems 菜单项数组
   * @param index 默认选中的菜单项索引
   * @param config 菜单配置
   * @returns 选中的菜单索引
   */
  show: (
    anchorViewId: number,
    menuItems: string[],
    index: number | null,
    config?: PopOverMenuConfiguration
  ) => Promise<number>;
}

export default TurboModuleRegistry.getEnforcing<Spec>('Popover');
