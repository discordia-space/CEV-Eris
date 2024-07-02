import { useBackend } from '../backend';
import { Box, Button, Section, Stack } from '../components';
import { Window } from '../layouts';

interface ProximitySensorData {
  isScanning: boolean;
  isTiming: boolean;
  minutes: number;
  seconds: number;
  range: number;
}

export const ProximitySensor = (props: any, context: any) => {
  return (
    <Window width={230} height={190}>
      <Window.Content>
        <ProximitySensorContent />
      </Window.Content>
    </Window>
  );
};

const ProximitySensorContent = (props: any, context: any) => {
  const { act, data } = useBackend<ProximitySensorData>(context);
  const { isScanning, isTiming, minutes, seconds, range } = data;

  return (
    <>
      <Section
        title="Status"
        buttons={
          <Button
            icon={isScanning ? 'lock' : 'unlock'}
            content={isScanning ? 'Armed' : 'Not Armed'}
            selected={isScanning}
            onClick={() => act('sense')}
          />
        }
      >
        <RangeContent />
      </Section>
      <Section
        title="Auto Arm"
        buttons={
          <Button
            icon={'clock-o'}
            content={isTiming ? 'Stop' : 'Start'}
            selected={isTiming}
            disabled={isScanning}
            onClick={() => act('time')}
          />
        }
      >
        <TimeContent />
      </Section>
    </>
  );
};

const RangeContent = (props: any, context: any) => {
  const { act, data } = useBackend<ProximitySensorData>(context);
  const { isScanning, range } = data;

  return (
    <Stack align="baseline" justify="space-between">
      <Stack.Item>
        <Box color="label">Detection Range:</Box>
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="backward"
          disabled={isScanning}
          onClick={() => act('adjust', { range: -1 })}
        />{' '}
        {String(range).padStart(1, '1')}{' '}
        <Button
          icon="forward"
          disabled={isScanning}
          onClick={() => act('adjust', { range: 1 })}
        />
      </Stack.Item>
    </Stack>
  );
};

const TimeContent = (props: any, context: any) => {
  const { act, data } = useBackend<ProximitySensorData>(context);
  const { isScanning, isTiming, minutes, seconds } = data;

  return (
    <Stack justify="space-around">
      <Stack.Item>
        <Button
          icon="fast-backward"
          disabled={isScanning || isTiming}
          onClick={() => act('adjust', { time: -30 })}
        />
        <Button
          icon="backward"
          disabled={isScanning || isTiming}
          onClick={() => act('adjust', { time: -1 })}
        />{' '}
        {String(minutes).padStart(2, '0')}:{String(seconds).padStart(2, '0')}{' '}
        <Button
          icon="forward"
          disabled={isScanning || isTiming}
          onClick={() => act('adjust', { time: 1 })}
        />
        <Button
          icon="fast-forward"
          disabled={isScanning || isTiming}
          onClick={() => act('adjust', { time: 30 })}
        />
      </Stack.Item>
    </Stack>
  );
};
