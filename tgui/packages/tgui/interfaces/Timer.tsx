import { useBackend } from 'tgui/backend';
import { Button, Section, Stack } from 'tgui-core/components';

import { Window } from '../layouts';

interface TimerData {
  isTiming: boolean;
  minutes: number;
  seconds: number;
}

export const Timer = (props: any) => {
  const { act, data } = useBackend<TimerData>();
  const { isTiming } = data;

  return (
    <Window width={275} height={115}>
      <Window.Content>
        <Section
          title="Timing Unit"
          buttons={
            <Button
              icon={'clock-o'}
              selected={isTiming}
              onClick={() => act('time')}
            >
              {isTiming ? 'Stop' : 'Start'}
            </Button>
          }
        >
          <TimerContent />
        </Section>
      </Window.Content>
    </Window>
  );
};

const TimerContent = (props: any) => {
  const { act, data } = useBackend<TimerData>();
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
