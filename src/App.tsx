/**
 * @file App.tsx
 * @description Root component of the Irrigation Monitoring Application
 * @author [Your Company Name]
 * @version 1.0.0
 * @lastModified 2024-03-21
 *
 * This is the main entry point for the application. It sets up:
 * - Redux store for state management
 * - Navigation container and stack
 * - Authentication flow
 */

import React from 'react';
import { NavigationContainer } from '@react-navigation/native';
import { createStackNavigator } from '@react-navigation/stack';
import { Provider } from 'react-redux';
import store from './store';

import AuthStack from './navigation/AuthStack';
import MainStack from './navigation/MainStack';

const Stack = createStackNavigator();

const App = () => {
  return (
    <Provider store={store}>
      <NavigationContainer>
        <Stack.Navigator>
          <Stack.Screen name="Auth" component={AuthStack} />
          <Stack.Screen name="Main" component={MainStack} />
        </Stack.Navigator>
      </NavigationContainer>
    </Provider>
  );
};

export default App; 