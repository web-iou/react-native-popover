import { Text, View, StyleSheet, findNodeHandle } from 'react-native';
import { showPopover } from 'react-native-popover';
import { useRef } from 'react';

export default function App() {
  const ref = useRef<Text>(null);

  return (
    <View style={styles.container}>
      <Text
        style={{
          width: 140,
          paddingHorizontal: 16,
          backgroundColor:'red'
        }}
        onPress={() => {
          showPopover({
            anchorViewId: findNodeHandle(ref.current!)!,
            menuItems: ['111111111111', '2322222222222', '3'],
            index: 0,
            config: {
              menuWidth: 140,
              textAlignment: 'left',
              shadowColor:'#000000',
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
