import { globalStore } from 'tgui/backend';
import { IconProvider } from './Icons';

export function App() {
  const { getRoutedComponent } = require('./routes');
  const Component = getRoutedComponent(globalStore);

  return (
    <>
      <Component />
      <IconProvider />
    </>
  );
}
