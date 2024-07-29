import { toFixed } from '../../common/math';
import { useBackend } from '../backend';
import { Box, Button, NumberInput, Section, Stack } from '../components';
import { Window } from '../layouts';

interface SignalerData {
  maxFrequency: number;
  minFrequency: number;
  frequency: number;
  code: number;
}

export const Signaler = (props: any, context: any) => {
  return (
    <Window width={340} height={145}>
      <Window.Content>
        <SignalerContent />
      </Window.Content>
    </Window>
  );
};

export const SignalerContent = (props: any, context: any) => {
  const { act } = useBackend<SignalerData>(context);

  return (
    <Section fill vertical>
      <Stack vertical justify="space-between">
        <Stack.Item>
          <FrequencyContent />
        </Stack.Item>
        <Stack.Item>
          <CodeContent />
        </Stack.Item>
        <Stack.Item bold fontSize="1.5rem">
          <Button
            fluid
            icon="broadcast-tower"
            color="green"
            content="Send"
            textAlign="center"
            onClick={() => act('signal')}
          />
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const FrequencyContent = (props: any, context: any) => {
  const { act, data } = useBackend<SignalerData>(context);
  const { frequency, maxFrequency, minFrequency } = data;

  return (
    <Stack justify="space-between">
      <Stack.Item width="19%">
        <Box color="label" textAlign="left">
          Frequency:
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="fast-backward"
          onClick={() =>
            act('adjust', {
              freq: -10,
            })
          }
        />
        <Button
          icon="backward"
          onClick={() =>
            act('adjust', {
              freq: -2,
            })
          }
        />
        <NumberInput
          animate
          width="80px"
          unit="kHz"
          step={3}
          stepPixelSize={6}
          minValue={minFrequency}
          maxValue={maxFrequency}
          value={frequency}
          format={(value: number) => toFixed(value / 10, 1)}
          onChange={(e: any, value: number) =>
            act('adjust', { freq: -frequency + value })
          }
        />
        <Button
          icon="forward"
          onClick={() =>
            act('adjust', {
              freq: 2,
            })
          }
        />
        <Button
          icon="fast-forward"
          onClick={() =>
            act('adjust', {
              freq: 10,
            })
          }
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="sync"
          color="red"
          onClick={() => act('reset', { freq: true })}
        />
      </Stack.Item>
    </Stack>
  );
};

const CodeContent = (props: any, context: any) => {
  const { act, data } = useBackend<SignalerData>(context);
  const { code } = data;

  return (
    <Stack justify="space-between">
      <Stack.Item width="19%">
        <Box color="label" textAlign="left">
          Code:
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="fast-backward"
          onClick={() => act('adjust', { code: -10 })}
        />
        <Button icon="backward" onClick={() => act('adjust', { code: -1 })} />
        <NumberInput
          animate
          step={1}
          stepPixelSize={6}
          minValue={1}
          maxValue={100}
          value={code}
          width="80px"
          onDrag={(e: any, value: number) =>
            act('adjust', { code: -code + value })
          }
        />
        <Button icon="forward" onClick={() => act('adjust', { code: 1 })} />
        <Button
          icon="fast-forward"
          onClick={() => act('adjust', { code: 10 })}
        />
      </Stack.Item>
      <Stack.Item>
        <Button
          icon="sync"
          color="red"
          onClick={() => act('reset', { code: true })}
        />
      </Stack.Item>
    </Stack>
  );
};
