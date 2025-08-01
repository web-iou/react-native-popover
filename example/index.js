import { AppRegistry } from 'react-native';
import App from './src/App';
import { name as appName } from './app.json';
debugger;
try{
    AppRegistry.registerComponent(appName, () => App);
}catch(e){
    console.log(e);
}
