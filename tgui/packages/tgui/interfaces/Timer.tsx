import { useBackend } from '../backend';
import { Button, Section, Stack } from '../components';
import { Window } from '../layouts';

interface TimerData {
  isTiming: boolean;
  minutes: number;
  seconds: number;
}

export const Timer = (props: any, context: any) => {
  const { act, data } = useBackend<TimerData>(context);
  const { isTiming } = data;

  return (
    <Window width={275} height={115}>
      <Window.Content>
        <Section
          title="Timing Unit"
          buttons={
            <Button
              icon={'clock-o'}
              content={isTiming ? 'Stop' : 'Start'}
              selected={isTiming}
              onClick={() => act('time')}
            />
          }
        >
          <TimerContent />
        </Section>
      </Window.Content>
    </Window>
  );
};

const TimerContent = (props: any, context: any) => {
  const { act, data } = useBackend<TimerData>(context);
  const { minutes, seconds, isTiming } = data;

  return (
    <Stack justify="space-around">
      <Stack.Item>
        <Button
          icon="fast-backward"
          disabled={isTiming}
          onClick={() => act('adjust', { value: -30 })}
        />
        <Button
          icon="backward"
          disabled={isTiming}
          onClick={() => act('adjust', { value: -1 })}
        />
        {String(minutes).padStart(2, '0')}:{String(seconds).padStart(2, '0')}{' '}
        <Button
          icon="forward"
          disabled={isTiming}
          onClick={() => act('adjust', { value: 1 })}
        />
        <Button
          icon="fast-forward"
          disabled={isTiming}
          onClick={() => act('adjust', { value: 30 })}
        />
      </Stack.Item>
    </Stack>
  );
};
