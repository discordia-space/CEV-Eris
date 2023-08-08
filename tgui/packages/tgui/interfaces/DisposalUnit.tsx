import { useBackend } from '../backend';
import { Button, LabeledList, ProgressBar, Section, Stack } from '../components';
import { Window } from '../layouts';

const MODE2COLOR = {
  Off: 'bad',
  Pressurizing: 'average',
  Ready: 'good',
  Panel: 'bad',
};

type DisposalUnitData = {
  flush: boolean;
  mode: string;
  panel: boolean;
  eject: boolean;
  pressure: number;
};

export const DisposalUnit = (props: any, context: any) => {
  const { act, data } = useBackend<DisposalUnitData>(context);
  const { flush, mode, panel, eject, pressure } = data;

  return (
    <Window width={300} height={182} title="Waste Disposal Unit">
      <Window.Content>
        <Section>
          <Stack fill vertical>
            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Status" color={MODE2COLOR[mode]}>
                  {mode}
                </LabeledList.Item>
                <LabeledList.Item label="Pressure">
                  <ProgressBar
                    value={pressure}
                    minValue={0}
                    maxvalue={100}
                    ranges={{
                      good: [0, Infinity],
                    }}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Handle">
                  <Button
                    icon={!flush ? 'toggle-on' : 'toggle-off'}
                    content={!flush ? 'Disengage' : 'Engage'}
                    onClick={() => {
                      act('toggle', { handle: true });
                    }}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Pump">
                  <Button
                    icon="power-off"
                    selected={mode === ('Pressurizing' || 'Ready')}
                    onClick={() => {
                      act('toggle', { pump: true });
                    }}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                icon="eject"
                disabled={!eject}
                content="Eject"
                textAlign="center"
                style={{ 'font-size': '15px' }}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
