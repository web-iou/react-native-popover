# React Native Popover

一个跨平台的React Native弹出菜单组件，支持iOS和Android平台。
## 预览
![Demo](./doc/Simulator%20Screen%20Recording%20-%20iPhone%2016%20Pro%20-%202025-08-03%20at%2021.22.36.gif)
## 功能特性

- ✅ 支持iOS和Android平台
- ✅ 自定义菜单样式（宽度、圆角、颜色等）
- ✅ 选中状态显示和自定义选中颜色
- ✅ 文本对齐、字体大小、行高等配置
- ✅ 点击外部区域自动关闭
- ✅ 支持动画效果
- ✅ TypeScript支持
- ✅ 提供便捷的Hook API

## 安装

```bash
npm install react-native-popover
# 或
yarn add react-native-popover
```

### iOS 安装

```bash
cd ios && pod install
```

## 使用方法

### 方法一：使用 Hook（推荐）

```typescript
import React from 'react';
import { View, TouchableOpacity, Text } from 'react-native';
import { useNativePopover } from 'react-native-popover';

const MyComponent = () => {
  const [showPopover, anchorRef, selectedIndex, setSelectedIndex] = useNativePopover();

  const handleShowMenu = async () => {
    const result = await showPopover(
      ['选项 1', '选项 2', '选项 3', '选项 4'],
      1, // 默认选中的索引
      {
        menuWidth: 200,
        menuCornerRadius: 8,
        textColor: '#262626',
        backgroundColor: '#FFFFFF',
        selectedTextColor: '#FF891F',
        // ... 更多配置选项
      }
    );
    
    if (result !== null) {
      console.log('选中的索引:', result);
      setSelectedIndex(result);
    }
  };

  return (
    <View>
      <TouchableOpacity ref={anchorRef} onPress={handleShowMenu}>
        <Text>点击显示菜单</Text>
      </TouchableOpacity>
      <Text>当前选中: {selectedIndex}</Text>
    </View>
  );
};
```

### 方法二：直接调用 API

```typescript
import { showPopover } from 'react-native-popover';
import { findNodeHandle } from 'react-native';

// 在你的组件中
const buttonRef = useRef(null);

const handleShowPopover = async () => {
  try {
    const anchorViewId = findNodeHandle(buttonRef.current);
    if (anchorViewId) {
      const selectedIndex = await showPopover({
        anchorViewId,
        menuItems: ['选项 1', '选项 2', '选项 3'],
        index: 1, // 默认选中的索引
        config: {
          menuWidth: 200,
          menuCornerRadius: 8,
          textColor: '#262626',
          backgroundColor: '#FFFFFF',
          selectedTextColor: '#FF891F',
          // ... 更多配置选项
        }
      });
      console.log('选中的索引:', selectedIndex);
    }
  } catch (error) {
    console.error('显示popover失败:', error);
  }
};
```

## API 文档

### useNativePopover Hook

返回一个包含以下元素的数组：
- `showPopover`: 显示弹出菜单的函数
- `anchorRef`: 用于绑定锚点视图的ref
- `selectedIndex`: 当前选中的索引
- `setSelectedIndex`: 设置选中索引的函数

#### 参数

- `showPopover(menuItems, config?)`
  - `menuItems` (string[]): 菜单项数组
  - `config` (PopOverMenuConfiguration): 可选的菜单配置

#### 返回值

Promise<number | null>: 返回选中的菜单项索引，如果用户取消或出错则返回null

### showPopover(options)

显示弹出菜单并返回选中的索引。

#### 参数

- `anchorViewId` (number): 锚点视图的原生ID
- `menuItems` (string[]): 菜单项数组
- `index` (number): 默认选中的菜单项索引
- `config` (PopOverMenuConfiguration): 菜单配置选项

#### 返回值

Promise<number>: 返回选中的菜单项索引，如果用户取消则返回-1

### PopOverMenuConfiguration

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| menuWidth | number | 160 | 菜单宽度 |
| menuCornerRadius | number | 8 | 菜单圆角半径 |
| textColor | string | '#262626' | 文本颜色 |
| backgroundColor | string | '#FFFFFF' | 背景颜色 |
| borderColor | string | '#E6E6E6' | 边框颜色 |
| borderWidth | number | 0 | 边框宽度 |
| padding | object | {top: 0, left: 16, bottom: 0, right: 16} | 内边距 |
| rowHeight | number | 48 | 行高 |
| textFont | object | {fontSize: 15, fontWeight: 500} | 文本字体 |
| textAlignment | 'left' \| 'center' \| 'right' | 'left' | 文本对齐方式 |
| animationDuration | number | 0.2 | 动画持续时间（秒） |
| selectedTextColor | string | '#FF891F' | 选中项的文本颜色 |
| separatorColor | string | '#E6E6E6' | 分隔线颜色 |
| checkIconSize | number | 16 | 选中图标大小 |
| shadowColor | string | - | 阴影颜色（仅iOS） |
| shadowOpacity | number | - | 阴影不透明度（仅iOS） |
| shadowRadius | number | - | 阴影半径（仅iOS） |
| shadowOffsetX | number | - | 阴影X轴偏移量（仅iOS） |
| shadowOffsetY | number | - | 阴影Y轴偏移量（仅iOS） |

## 平台实现

### iOS
使用 `UIView` 实现，提供原生的弹出菜单体验。

### Android  
使用 `PopupWindow` 实现，支持自定义样式和动画效果。

## 示例

查看 `example/src/App.tsx` 文件获取完整的使用示例。

## 开发

```bash
# 安装依赖
yarn install

# 运行示例
cd example
yarn ios
# 或
yarn android
```

## 许可证

MIT
