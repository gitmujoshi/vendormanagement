import { MD3LightTheme, configureFonts } from 'react-native-paper';

/**
 * Custom theme configuration for the application
 * Defines colors, typography, component styles, and responsive breakpoints
 */
export const theme = {
  ...MD3LightTheme,
  colors: {
    ...MD3LightTheme.colors,
    primary: '#2196f3',
    secondary: '#ff9800',
    background: '#f5f5f5',
  },
  fonts: configureFonts({
    config: {
      fontFamily: 'Roboto',
    },
  }),
}; 