import React from 'react';
import {
  SafeAreaView,
  ScrollView,
  StatusBar,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import { useNativePopover } from 'react-native-popover';

function App(): React.JSX.Element {
  const [showPopover, anchorRef] = useNativePopover(1);

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" />
      <ScrollView contentInsetAdjustmentBehavior="automatic">
        <View style={styles.content}>
          <Text style={styles.title}>React Native Popover 测试</Text>
          <Text style={styles.subtitle}>点击下面的按钮来测试popover功能</Text>

          <TouchableOpacity
            ref={anchorRef}
            style={styles.button}
            onPress={() =>
              showPopover(['选项 1', '选项 2', '选项 3', '选项 4'], {
                menuWidth: 200,
              })
            }
          >
            <Text style={styles.buttonText}>显示 Popover</Text>
          </TouchableOpacity>

          <View style={styles.info}>
            <Text style={styles.infoTitle}>功能说明:</Text>
            <Text style={styles.infoText}>
              • 支持自定义菜单宽度、圆角、颜色等样式{'\n'}•
              支持选中状态显示和自定义选中颜色{'\n'}•
              支持文本对齐、字体大小、行高等配置{'\n'}• 支持iOS和Android平台
              {'\n'}• 支持点击外部区域关闭
            </Text>
          </View>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5F5',
  },
  content: {
    padding: 20,
    alignItems: 'center',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 10,
    textAlign: 'center',
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    marginBottom: 30,
    textAlign: 'center',
  },
  button: {
    backgroundColor: '#007AFF',
    paddingHorizontal: 20,
    paddingVertical: 12,
    borderRadius: 8,
    marginBottom: 30,
  },
  buttonText: {
    color: '#FFFFFF',
    fontSize: 16,
    fontWeight: '600',
  },
  info: {
    backgroundColor: '#FFFFFF',
    padding: 20,
    borderRadius: 8,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  infoTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 10,
  },
  infoText: {
    fontSize: 14,
    color: '#666',
    lineHeight: 20,
  },
});

export default App;
