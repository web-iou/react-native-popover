import { Text, View, StyleSheet, findNodeHandle } from 'react-native';
import { showPopover } from 'react-native-popover';
import { useRef } from 'react';

export default function App() {
  const ref = useRef<Text>(null);

  return (
    <View style={styles.container}>
      <Text
        onPress={() => {
          showPopover({
            anchorViewId: findNodeHandle(ref.current!)!,
            menuItems: ['11111111111111111111111111', '2', '3'],
            index: 0,
            config: {
              menuWidth: 140,
              textAlignment:'right'
            },
          });
        }}
        ref={ref}
      >
        Result:1111
      </Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    // backgroundColor: 'red',
  },
});
