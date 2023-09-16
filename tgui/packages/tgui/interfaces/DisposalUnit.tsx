import { useBackend } from '../backend';
import { Button, LabeledList, ProgressBar, Section, Stack } from '../components';
import { Window } from '../layouts';

const MODE2COLOR = {
  Off: 'bad',
  Panel: 'bad',
  Ready: 'good',
  Pressurizing: 'average',
};

type DisposalUnitData = {
  isai: boolean;
  mode: string;
  panel: boolean;
  eject: boolean;
  handle: boolean;
  pressure: number;
};

export const DisposalUnit = (props: any, context: any) => {
  const { act, data } = useBackend<DisposalUnitData>(context);
  const { isai, mode, handle, panel, eject, pressure } = data;
  let modeColor = MODE2COLOR[panel ? 'Panel' : mode];
  let modeText = panel ? 'Power Disabled' : mode;

  return (
    <Window width={300} height={183} title="Waste Disposal Unit">
      <Window.Content>
        <Section>
          <Stack fill vertical>
            <Stack.Item>
              <LabeledList>
                <LabeledList.Item label="Status" color={modeColor}>
                  {modeText}
                </LabeledList.Item>
                <LabeledList.Item label="Pressure">
                  <ProgressBar
                    value={pressure}
                    minValue={0}
                    maxValue={1}
                    ranges={{
                      bad: [-Infinity, 0.7],
                      average: [0.7, 0.99],
                      good: [0.99, Infinity],
                    }}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Handle">
                  <Button
                    icon={handle ? 'toggle-on' : 'toggle-off'}
                    content={handle ? 'Disengage' : 'Engage'}
                    onClick={() => {
                      act('toggle', { handle: true });
                    }}
                    disabled={isai}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Pump">
                  <Button
                    icon="power-off"
                    selected={mode !== 'Off'}
                    onClick={() => {
                      act('toggle', { pump: true });
                    }}
                    disabled={panel}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Stack.Item>
            <Stack.Item>
              <Button
                fluid
                color="red"
                textAlign="center"
                icon="eject"
                content="Eject"
                disabled={!eject}
                style={{ 'font-size': '15px' }}
                onClick={() => {
                  act('eject');
                }}
              />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
